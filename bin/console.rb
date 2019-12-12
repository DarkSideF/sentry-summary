#!/usr/bin/env ruby
require 'bundler/setup'

require 'dotenv/load'
require 'sentry_summary'
require 'byebug'

require 'irb'
IRB.start(__FILE__)
