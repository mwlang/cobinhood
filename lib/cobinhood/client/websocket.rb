# frozen_string_literal: true

module Cobinhood
  module Client
    class Websocket
      # Public: String base url for Websocket client to use
      BASE_URL = "wss://ws.cobinhood.com/v2/ws".freeze

      attr_reader :api_key
      def initialize api_key: Cobinhood.default_api_key
        @api_key = api_key
      end

      # Public: Create a WebSocket stream
      #
      # :type   - To define stream type.
      #   :open (Default)
      #   :auth
      # :stream - The Hash used to define the stream
      # :topic  - The String channel to listen to
      #
      # :methods - The Hash which contains the event handler methods to pass to
      #            the WebSocket client
      #   :open    - The Proc called when a stream is opened (optional)
      #   :message - The Proc called when a stream receives a message
      #   :error   - The Proc called when a stream receives an error (optional)
      #   :close   - The Proc called when a stream is closed (optional)
      def start(type: :open, topic:, stream:, methods:)
        channel = type == :auth ? auth_stream(methods: methods) : open_stream(methods: methods)
        channel.send({ action: 'subscribe', type: topic }.merge(stream).to_json)
        channel
      end

      def user_updates(params: {}, methods:)
        start type: :auth, topic: 'balance-update', stream: params, methods: methods
      end

      def candle(trading_pair_id:, timeframe:, params: {}, methods:)
        start topic: 'candle', stream: { trading_pair_id: trading_pair_id, timeframe: timeframe }.merge(params), methods: methods
      end

      def funding(params: {}, methods:)
        start type: :auth, topic: 'funding', stream: params, methods: methods
      end

      def matched_loans(currency_id:, params: {}, methods:)
        start topic: 'loan', stream: { currency_id: currency_id }.merge(params), methods: methods
      end

      def loan_ticker(currency_id:, params: {}, methods:)
        start topic: 'loan-ticker', stream: { currency_id: currency_id }.merge(params), methods: methods
      end

      def user_loan_updates(params: {}, methods:)
        start type: :auth, topic: 'loan-update', stream: params, methods: methods
      end

      def order(type:, action:, params: {}, methods:)
        start type: :auth, topic: type.to_s, stream: { action: action }.merge(params), methods: methods
      end

      def orderbook(trading_pair_id:, params: {}, methods:)
        start topic: 'order-book', stream: { trading_pair_id: trading_pair_id }.merge(params), methods: methods
      end

      def user_position_updates(params: {}, methods:)
        start type: :auth, topic: 'position-update', stream: params, methods: methods
      end

      def repl_orderbook(trading_pair_id:, params: {}, methods:)
        start topic: 'repl-order-book', stream: { trading_pair_id: trading_pair_id }.merge(params), methods: methods
      end

      def ticker(trading_pair_id:, params: {}, methods:)
        start topic: 'ticker', stream: { trading_pair_id: trading_pair_id }.merge(params), methods: methods
      end

      def trade(trading_pair_id:, params: {}, methods:)
        start topic: 'trade', stream: { trading_pair_id: trading_pair_id }.merge(params), methods: methods
      end

      private

      def open_stream(methods:)
        create_stream(BASE_URL, methods: methods)
      end

      def auth_stream(methods:)
        create_stream(BASE_URL, headers: { 'authorization' => api_key }, methods: methods)
      end

      # Internal: Initialize and return a Faye::WebSocket::Client
      #
      # url - The String url that the WebSocket should try to connect to
      #
      # :headers - The Hash which contains "headers"
      # :methods - The Hash which contains the event handler methods to pass to
      #            the WebSocket client
      #   :open    - The Proc called when a stream is opened (optional)
      #   :message - The Proc called when a stream receives a message
      #   :error   - The Proc called when a stream receives an error (optional)
      #   :close   - The Proc called when a stream is closed (optional)
      def create_stream(url, headers: {}, methods:)
        Faye::WebSocket::Client.new(url, [], headers: headers).tap { |ws| attach_methods(ws, methods) }
      end

      # Internal: Iterate through methods passed and add them to the WebSocket
      #
      # websocket - The Faye::WebSocket::Client to apply methods to
      #
      # methods - The Hash which contains the event handler methods to pass to
      #   the WebSocket client
      #   :open    - The Proc called when a stream is opened (optional)
      #   :message - The Proc called when a stream receives a message
      #   :error   - The Proc called when a stream receives an error (optional)
      #   :close   - The Proc called when a stream is closed (optional)
      def attach_methods(websocket, methods)
        methods.each_pair do |key, method|
          websocket.on(key) { |event| method.call(event) }
        end
      end
    end
  end
end
