# frozen_string_literal: true
require 'date'

module Cobinhood
  class NonceRequestMiddleware < Faraday::Middleware
    def call env
      env[:request_headers]["nonce"] = DateTime.now.strftime('%Q')
      @app.call(env)
    end
  end
end
