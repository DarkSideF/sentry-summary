module SentrySummary
  module Models
    class Event < Base
      # @!attribute date_received
      # @return [Array<Time>] Дата получениия
      coerce_key :dateReceived,
                 lambda { |date|
                   Time.parse(date)
                 }

      # @!attribute dateCreated
      # @return [Array<Time>] Дата создания
      coerce_key :dateCreated,
                 lambda { |date|
                   Time.parse(date)
                 }
    end
  end
end
