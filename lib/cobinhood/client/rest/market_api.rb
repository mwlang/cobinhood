module Cobinhood
  module Client
    class REST
      # Public: A Module containing all of the Public API endpoints
      module MarketAPI

        def currencies
          request :market, :get, :currencies
        end
        alias :get_all_currencies :currencies

        def trading_pairs
          request :market, :get, :trading_pairs
        end
        alias :get_all_trading_pairs :trading_pairs

        def order_book trading_pair_id
          request :market, :get, :order_book, trading_pair_id: trading_pair_id
        end
        alias :get_order_book :order_book

        def precisions trading_pair_id
          request :market, :get, :precisions, trading_pair_id: trading_pair_id
        end
        alias :get_order_book_precisions :precisions

        def stats
          request :market, :get, :stats
        end

        def tickers trading_pair_id
          request :market, :get, :tickers, trading_pair_id: trading_pair_id
        end
        alias :get_ticker :tickers

        def market_trades trading_pair_id
          request :market, :get, :trades, trading_pair_id: trading_pair_id
        end
        alias :get_recent_trades :market_trades
      end
    end
  end
end
