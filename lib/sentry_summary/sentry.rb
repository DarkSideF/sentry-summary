require 'nestful'
require 'chronic'

require 'sentry_summary/models/base'
require 'sentry_summary/models/event'

module SentrySummary
  API_URI = 'api/0'.freeze

  class Sentry
    def initialize
      @token = ENV.fetch('API_TOKEN')
      @base_url = ENV.fetch('BASE_URL')
      @organization = ENV.fetch('ORGANIZATION')
    end

    def issues(project, since = nil)
      paginate("projects/#{@organization}/#{project}/issues/", since) do |issue|
        Issue.build(issue)
      end
    end

    def latest_samples(project)
      issues(project).map do |issue|
        dto = request(:get, "issues/#{issue.id}/events/latest/").merge(issue_id: issue.id)
        Event.build(dto)
      end
    end

    def events(issue, since = nil)
      paginate("/issues/#{issue}/events/", since) do |event|
        SentrySummary::Models::Event.new(event.merge(issue_id: issue, full: 1))
      end
    end

    private

    def request(method, path, parameters = {})
      request_url = "#{@base_url}#{API_URI}#{path}"

      response = Nestful::Request.new(
        request_url,
        method: method,
        auth_type: :bearer,
        password: @token,
        params: parameters
      ).execute

      links = response.headers['link'].split(',').map do |link|
        Link.build(link)
      end

      next_link = links.find { |link| link.rel == :next && link.results? }

      Response.new(JSON.parse(response.body, symbolize_names: true), next_link)
    end

    def paginate(path, since, &block)
      since ||= '24 hours ago'
      since = Chronic.parse(since)

      items = []
      cursor = nil

      begin
        response = request(:get, path, cursor: cursor)
        new_items = response.body.map(&block)

        items_in_time_range = new_items.select { |item| item.dateCreated >= since }
        items.concat(items_in_time_range)

        cursor = response.cursor
      end while response.next? && new_items.count == items_in_time_range.count

      items
    end
  end

  class Response
    attr_reader :body

    def initialize(body, next_link)
      @body = body
      @next_link = next_link
    end

    def cursor
      @next_link&.cursor
    end

    def next?
      !cursor.nil?
    end
  end

  class Link
    attr_reader :rel, :cursor

    def initialize(rel, cursor, results)
      @rel = rel.to_sym
      @cursor = cursor
      @results = results
    end

    def results?
      @results == 'true'
    end

    def self.build(link)
      match = link.strip.match(/^<[^>]+>\s*((?:;\s*(?:[^;]+))*)$/)

      parameters = match[1]

      parameters = parameters.scan(/;\s*([^;]+)/).map(&:first)

      parameters = parameters.map do |parameter|
        parameter.scan(/^([^=]+)="([^"]+)"$/).first
      end.to_h

      Link.new(parameters['rel'], parameters['cursor'], parameters['results'])
    end
  end
end
