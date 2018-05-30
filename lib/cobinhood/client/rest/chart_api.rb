# frozen_string_literal: true
module Cobinhood
  module Client
    class REST
      # Public: A Module containing all of the Public API endpoints
      module ChartAPI

        def candles trading_pair_id, options={}
          assert_required_param options, :timeframe, timeframes
          request :chart, :get, :candles, options.merge!(trading_pair_id: trading_pair_id)
        end

        private

        def timeframes
          %w{1m 5m 15m 30m 1h 3h 6h 12h 1D 7D 14D 1M}
        end

      end
    end
  end
end
