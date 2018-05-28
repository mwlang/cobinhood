module Cobinhood
  module Client
    class REST
      API_ENDPOINTS = {
        system: {
          time:           'v1/system/time',
          info:           'v1/system/info',
        },

        market: {
          currencies:     '/v1/market/currencies',
          trading_pairs:  '/v1/market/trading_pairs',
          order_book:     '/v1/market/orderbooks/:trading_pair_id',
          precisions:     '/v1/market/orderbook/precisions/:trading_pair_id',
          stats:          '/v1/market/stats',
          tickers:        '/v1/market/tickers/:trading_pair_id',
          trades:         '/v1/market/trades/:trading_pair_id',
        },

        chart: {
          candles:        '/v1/chart/candles/:trading_pair_id',
        },

        trading: {
          order:          '/v1/trading/orders/:order_id',
          order_trades:   '/v1/trading/orders/:order_id/trades',
          orders:         '/v1/trading/orders',
          order_history:  '/v1/trading/order_history',
          get_trade:      '/v1/trading/trades/:trade_id',
          trades:         '/v1/trading/trades',
        },

        wallet: {
          balances:             '/v1/wallet/balances',
          ledger:               '/v1/wallet/ledger',
          deposit_addresses:    '/v1/wallet/deposit_addresses',
          withdrawal_addresses: '/v1/wallet/withdrawal_addresses',
          withdrawal:           '/v1/wallet/withdrawals/:withdrawal_id',
          withdrawals:          '/v1/wallet/withdrawals',
          deposit:              '/v1/wallet/deposits/:deposit_id',
          deposits:             '/v1/wallet/deposits',
        },
      }.freeze
    end
  end
end
