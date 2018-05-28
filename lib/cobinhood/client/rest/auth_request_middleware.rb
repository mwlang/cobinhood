module Cobinhood
  class AuthRequestMiddleware < Faraday::Middleware
    def initialize app, api_key
      super(app)
      @api_key = api_key
    end

    def call env
      raise Cobinhood::MissingApiKeyError.new('API KEY not provided') if @api_key.to_s == ''
      env[:request_headers]["authorization"] = @api_key
      @app.call(env)
    end
  end
end
