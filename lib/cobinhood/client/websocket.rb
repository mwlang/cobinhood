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

      def library
        {
          'balance-update':  auth_client(api_key),
          candle:            public_client,
          funding:           auth_client(api_key),
          loan:              public_client,
          'loan-ticker':     public_client,
          'loan-update':     auth_client(api_key),
          order:             auth_client(api_key),
          'order-book':      public_client,
          'position-update': auth_client(api_key),
          'repl-order-book': public_client,
          ticker:            public_client,
          trade:             public_client,
        }
      end

      # Public: Create a WebSocket stream
      #
      # :key    - The symbol topic key from defined @library
      # :topic  - The String channel type to listen to
      # :stream - The Hash used to define the stream
      #
      # :methods - The Hash which contains the event handler methods to pass to
      #            the WebSocket client
      #   :open    - The Proc called when a stream is opened (optional)
      #   :message - The Proc called when a stream receives a message
      #   :error   - The Proc called when a stream receives an error (optional)
      #   :close   - The Proc called when a stream is closed (optional)
      def start key: nil, topic:, stream:, methods:
        channel = create_stream(library[(key || topic).to_sym], methods: methods)
        channel.send({ action: 'subscribe', type: topic }.merge(stream).to_json)
        channel
      end

      def user_updates params: {}, methods:
        start topic: 'balance-update', stream: params, methods: methods
      end

      def candle trading_pair_id:, timeframe:, params: {}, methods:
        start topic: 'candle', stream: { trading_pair_id: trading_pair_id, timeframe: timeframe }.merge(params), methods: methods
      end

      def funding params: {}, methods:
        start topic: 'funding', stream: params, methods: methods
      end

      def matched_loans currency_id:, params: {}, methods:
        start topic: 'loan', stream: { currency_id: currency_id }.merge(params), methods: methods
      end

      def loan_ticker currency_id:, params: {}, methods:
        start topic: 'loan-ticker', stream: { currency_id: currency_id }.merge(params), methods: methods
      end

      def user_loan_updates params: {}, methods:
        start topic: 'loan-update', stream: params, methods: methods
      end

      def order type:, action:, params: {}, methods:
        start key: :order, topic: type.to_s, stream: { action: action }.merge(params), methods: methods
      end

      def orderbook trading_pair_id:, params: {}, methods:
        start topic: 'order-book', stream: { trading_pair_id: trading_pair_id }.merge(params), methods: methods
      end

      def user_position_updates params: {}, methods:
        start topic: 'position-update', stream: params, methods: methods
      end

      def repl_orderbook trading_pair_id:, params: {}, methods:
        start topic: 'repl-order-book', stream: { trading_pair_id: trading_pair_id }.merge(params), methods: methods
      end

      def ticker trading_pair_id:, params: {}, methods:
        start topic: 'ticker', stream: { trading_pair_id: trading_pair_id }.merge(params), methods: methods
      end

      def trade trading_pair_id:, params: {}, methods:
        start topic: 'trade', stream: { trading_pair_id: trading_pair_id }.merge(params), methods: methods
      end

      private

      # Internal: return a Faye::WebSocket::Client
      def public_client
        Faye::WebSocket::Client.new(BASE_URL, [], headers: {})
      end

      # Internal: return a Faye::WebSocket::Client
      #
      # api_key: COBINHOOD uses token for APIs that require authentication.
      #   Token header field name is authorization.
      def auth_client api_key
        Faye::WebSocket::Client.new(BASE_URL, [], headers: { 'authorization' => api_key })
      end

      # Internal: Attach methods and return a Faye::WebSocket::Client
      #
      # websocket - The Faye::WebSocket::Client to apply methods to
      #
      # :methods - The Hash which contains the event handler methods to pass to
      #            the WebSocket client
      #   :open    - The Proc called when a stream is opened (optional)
      #   :message - The Proc called when a stream receives a message
      #   :error   - The Proc called when a stream receives an error (optional)
      #   :close   - The Proc called when a stream is closed (optional)
      def create_stream websocket, methods:
        attach_methods websocket, methods
        websocket
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
      def attach_methods websocket, methods
        methods.each_pair do |key, method|
          websocket.on(key) { |event| method.call(event) }
        end
      end
    end
  end
end
