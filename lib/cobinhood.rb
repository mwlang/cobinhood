# frozen_string_literal: true
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'faye/websocket'

require 'cobinhood/version'
require 'cobinhood/client/rest'
require 'cobinhood/client/websocket'

module Cobinhood
  def self.default_api_key
    ENV["COBINHOOD_API_KEY"].to_s
  end
end
