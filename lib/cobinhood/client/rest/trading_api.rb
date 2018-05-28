module Cobinhood
  module Client
    class REST
      # Public: A Module containing all of the Public API endpoints
      module TradingAPI

        def order order_id
          request :trading, :get, :order, order_id: order_id
        end
        alias :get_order :order

        def order_trades order_id
          request :trading, :get, :order_trades, order_id: order_id
        end
        alias :get_trades_of_an_order :order_trades

        def orders
          request :trading, :get, :orders
        end
        alias :get_all_orders :orders

        def place_order trading_pair_id, options={}
          assert_required_param options, :side, sides
          assert_required_param options, :type, order_types
          assert_required_param options, :size
          assert_required_param options, :price unless market_order?(options)
          request :trading, :post, :orders, options.merge(trading_pair_id: trading_pair_id)
        end

        def modify_order order_id, options={}
          assert_required_param options, :size
          assert_required_param options, :price
          request :trading, :put, :orders, options.merge(order_id: order_id)
        end

        def cancel_order order_id
          request :trading, :delete, :order, order_id: order_id
        end

        def order_history trading_pair_id=nil, options={}
          options.merge!(trading_pair_id: trading_pair_id) unless trading_pair_id.nil?
          request :trading, :get, :order_history, options
        end
        alias :get_order_history :order_history

        def get_trade trade_id
          request :trading, :get, :get_trade, options.merge(trade_id: trade_id)
        end
        alias :trade :get_trade

        def trades trading_pair_id, options={}
          request :trading, :get, :trades, options.merge(trading_pair_id: trading_pair_id)
        end

        private

        def market_order? options
          options[:type].to_s == "market"
        end

        def order_types
          %w{market limit stop stop_limit}
        end

        def sides
          %w{bid ask}
        end
      end
    end
  end
end
