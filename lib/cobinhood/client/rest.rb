# frozen_string_literal: true
require_relative 'rest/api_endpoints'
require_relative 'rest/nonce_request_middleware'
require_relative 'rest/auth_request_middleware'

require_relative 'rest/system_api'
require_relative 'rest/market_api'
require_relative 'rest/chart_api'
require_relative 'rest/funding_api'
require_relative 'rest/trading_api'
require_relative 'rest/wallet_api'

module Cobinhood
  MissingParamError = Class.new(StandardError)
  InvalidParamError = Class.new(StandardError)
  MissingApiKeyError = Class.new(StandardError)
  ClientError = Class.new(StandardError)

  module Client
    # Public: Client with methods mirroring the Cobinhood REST APIs
    class REST
      # Public: String base url for REST client to use
      BASE_URL = "https://api.cobinhood.com".freeze

      include SystemAPI
      include MarketAPI
      include ChartAPI
      include FundingAPI
      include TradingAPI
      include WalletAPI

      # Public: Initialize a REST Client
      #
      # :api_key    - The String API key to authenticate (Default = '').
      #
      # :adapter    - The Faraday::Adapter to be used for the client
      #               (Default = Faraday.default_adapter).
      def initialize api_key: Cobinhood.default_api_key, adapter: Faraday.default_adapter

        @library = {
            system: public_client(adapter),
            market: public_client(adapter),
             chart: public_client(adapter),
           funding: auth_client(api_key, adapter),
           trading: auth_client(api_key, adapter),
            wallet: auth_client(api_key, adapter),
        }
      end

      def assert_required_param options, param, valid_values=nil
        raise Cobinhood::MissingParamError.new("#{param} is required") unless options.has_key?(param)
        assert_param_is_one_of options, param, valid_values if valid_values
      end

      def assert_param_is_one_of options, param, valid_values
        return if valid_values.include? options[param].to_s
        raise Cobinhood::InvalidParamError.new("#{param} must be one of #{valid_values.inspect}")
      end

      private

      def public_client adapter
        Faraday.new(url: BASE_URL) do |conn|
          conn.request :json
          conn.response :json, content_type: /\bjson\z/
          conn.use NonceRequestMiddleware
          conn.adapter adapter
        end
      end

      def auth_client api_key, adapter
        Faraday.new(url: BASE_URL) do |conn|
          conn.request :json
          conn.response :json, content_type: /\bjson\z/
          conn.use NonceRequestMiddleware
          conn.use AuthRequestMiddleware, api_key
          conn.adapter adapter
        end
      end

      # Internal: Create a request that hits one of the REST APIs
      #
      # api - The Symbol that represents which API to use.
      #
      # method - The Symbol that represents which HTTP method to use.
      #
      # endpoint - The String that represents which API endpoint to request
      #            from.
      #
      # options - The Hash which hosts various REST query params. (Default = {})
      #           Each endpoint will have their own required and optional
      #           params.
      def request api, method, endpoint, options = {}
        response = @library[api].public_send(method) do |req|

          # substitute path parameters and remove from options hash
          endpoint_url = API_ENDPOINTS[api][endpoint].dup
          options.each do |option, value|
            path_param = /:#{option}/
            if endpoint_url.match? path_param
              options.delete(option)
              endpoint_url.gsub!(path_param, value)
            end
          end

          # Cobinhood wants certain parameters a certain way.
          adapt_price_param options
          adapt_size_param options
          [:start_time, :end_time].each{|key| adapt_timestamp_param key, options}

          req.url endpoint_url

          # parameters go into request body, not headers on POSTs
          if method == :post
            req.body = options.to_json
          else
            req.params.merge!(options)
          end
        end
        success_or_error response
      end

      private

      def success_or_error response
        if response.body.is_a?(Hash)
          return response.body["result"] if response.body["success"]
          json = response.body
        else
          json = JSON.parse(response.body)
        end
        raise Cobinhood::ClientError.new("#{json["error"]["error_code"]} for REQUEST ID: #{json["request_id"]}")
      rescue => e
        raise Cobinhood::ClientError.new("#{e.message}\nresponse body : #{json})")
      end

      # TODO:  This needs more testing!  I'm not sure about precision of the epoche nor if
      # adjustments are needed to account for timezone differences.
      # Currently only used for params of Cobinhood::Client::REST.candles
      def adapt_timestamp_param key, params
        return unless params.has_key? key
        return if params[key].is_a?(Integer)
        params[key] = (params[key].to_time.to_f * 1000).ceil
      end

      def adapt_price_param params
        return unless params.has_key? :price
        params[:price] = '%0.8f' % params[:price].to_f
      end

      def adapt_size_param params
        return unless params.has_key? :size
        params[:size] = params[:size].to_s
      end

    end
  end
end
