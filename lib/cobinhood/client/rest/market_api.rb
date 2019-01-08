# frozen_string_literal: true
module Cobinhood
  module Client
    class REST
      # Public: A Module containing all of the Public API endpoints
      module MarketAPI

        def currencies
          request :market, :get, :currencies
        end
        alias get_all_currencies currencies

        def funding_book_precisions currency_id
          request :market, :get, :funding_book_precisions, currency_id: currency_id
        end
        alias get_funding_book_precisions funding_book_precisions

        def funding_book currency_id, options={}
          request :market, :get, :funding_book, options.merge(currency_id: currency_id)
        end
        alias get_funding_book funding_book

        def trading_pairs
          request :market, :get, :trading_pairs
        end
        alias get_all_trading_pairs trading_pairs

        def order_book_precisions trading_pair_id
          request :market, :get, :order_book_precisions, trading_pair_id: trading_pair_id
        end
        alias get_order_book_precisions order_book_precisions

        def order_book trading_pair_id, options={}
          request :market, :get, :order_book, options.merge(trading_pair_id: trading_pair_id)
        end
        alias get_order_book order_book

        def quote_currencies
          request :market, :get, :quote_currencies
        end
        alias get_quote_currencies quote_currencies

        def stats
          request :market, :get, :stats
        end

        def tickers
          request :market, :get, :tickers
        end
        alias get_tickers tickers

        def ticker trading_pair_id
          request :market, :get, :ticker, trading_pair_id: trading_pair_id
        end
        alias get_ticker ticker

        def market_trades trading_pair_id
          request :market, :get, :trades, trading_pair_id: trading_pair_id
        end
        alias get_recent_trades market_trades

        def market_trades_history trading_pair_id, options={}
          request :market, :get, :trades_history, trading_pair_id: trading_pair_id
        end
        alias get_trades_with_history market_trades_history
      end
    end
  end
end
