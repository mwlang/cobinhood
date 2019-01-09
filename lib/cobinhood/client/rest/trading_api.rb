# frozen_string_literal: true
module Cobinhood
  module Client
    class REST
      # Public: A Module containing all of the Public API endpoints
      module TradingAPI

        def check_order options={}
          assert_required_param options, :trading_pair_id
          assert_required_param options, :stop_price
          assert_required_param options, :side, sides
          assert_required_param options, :type, check_order_types
          request :trading, :post, :check_order, options
        end

        def order_history options={}
          request :trading, :get, :order_history, options
        end
        alias get_order_history order_history

        def place_order options={}
          assert_required_param options, :trading_pair_id
          assert_required_param options, :price unless market_order?(options)
          assert_required_param options, :stop_price if market_stop_order?(options)
          assert_required_param options, :type, order_types
          assert_required_param options, :side, sides
          assert_required_param options, :size
          request :trading, :post, :orders, options
        end

        def orders options={}
          request :trading, :get, :orders, options
        end
        alias get_open_orders orders

        def modify_order order_id, options={}
          assert_required_param options, :size
          assert_required_param options, :price
          assert_required_param options, :stop_price if market_stop_order?(options)
          request :trading, :put, :orders, options.merge(order_id: order_id)
        end

        def cancel_order order_id
          request :trading, :delete, :order, order_id: order_id
        end

        def order order_id
          request :trading, :get, :order, order_id: order_id
        end
        alias get_order order

        def order_trades order_id
          request :trading, :get, :order_trades, order_id: order_id
        end
        alias get_trades_of_an_order order_trades

        def positions
          request :trading, :get, :positions
        end
        alias get_all_open_positions positions

        def claim_position trading_pair_id, options={}
          request :trading, :patch, :position, options.merge(trading_pair_id: trading_pair_id)
        end

        def position trading_pair_id
          request :trading, :get, :position, trading_pair_id: trading_pair_id
        end
        alias get_position position

        def close_position trading_pair_id
          request :trading, :delete, :position, trading_pair_id: trading_pair_id
        end

        def claimable_size trading_pair_id
          request :trading, :get, :claimable_size, trading_pair_id: trading_pair_id
        end
        alias get_claimable_size claimable_size

        def trades options={}
          request :trading, :get, :trades, options
        end
        alias get_trade_history trades

        def get_trade trade_id
          request :trading, :get, :get_trade, trade_id: trade_id
        end
        alias trade get_trade

        def trading_volume currency_id, options={}
          request :trading, :get, :trading_volume, options.merge(currency_id: currency_id)
        end
        alias get_trading_volume trading_volume

        private

        def market_order? options
          options[:type].to_s == "market"
        end

        def market_stop_order? options
          stop_price_types.include?(options[:type].to_s)
        end

        def stop_price_types
          %w{market_stop limit_stop}
        end

        def order_types
          %w{market limit market_stop limit_stop}
        end

        def check_order_types
          %w{market_stop limit_stop}
        end

        def sides
          %w{bid ask}
        end
      end
    end
  end
end
