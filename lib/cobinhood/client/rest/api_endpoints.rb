# frozen_string_literal: true
module Cobinhood
  module Client
    class REST
      API_ENDPOINTS = {
        system: {
          time:           'v1/system/time',
          info:           'v1/system/info',
        },

        market: {
          currencies:               '/v1/market/currencies',
          funding_book_precisions:  '/v1/market/fundingbook/precisions/:currency_id',
          funding_book:             '/v1/market/fundingbooks/:currency_id',
          trading_pairs:            '/v1/market/trading_pairs',
          order_book_precisions:    '/v1/market/orderbook/precisions/:trading_pair_id',
          order_book:               '/v1/market/orderbooks/:trading_pair_id',
          quote_currencies:         '/v1/market/quote_currencies',
          stats:                    '/v1/market/stats',
          tickers:                  '/v1/market/tickers',
          ticker:                   '/v1/market/tickers/:trading_pair_id',
          trades:                   '/v1/market/trades/:trading_pair_id',
          trades_history:           '/v1/market/trades_history/:trading_pair_id',
        },

        chart: {
          candles:        '/v1/chart/candles/:trading_pair_id',
        },

        trading: {
          check_order:    '/v1/trading/check_order',
          order_history:  '/v1/trading/order_history',
          orders:         '/v1/trading/orders',
          order:          '/v1/trading/orders/:order_id',
          order_trades:   '/v1/trading/orders/:order_id/trades',
          positions:      '/v1/trading/positions',
          position:       '/v1/trading/positions/:trading_pair_id',
          claimable_size: '/v1/trading/positions/:trading_pair_id/claimable_size',
          trades:         '/v1/trading/trades',
          get_trade:      '/v1/trading/trades/:trade_id',
          trading_volume: '/v1/trading/volume',
        },

        wallet: {
          balances:               '/v1/wallet/balances',
          ledger_in_csv:          '/v1/wallet/csv/ledgers',
          deposit_addresses:      '/v1/wallet/deposit_addresses',
          iota_deposit_addresses: '/v1/wallet/deposit_addresses/iota',
          generic_deposits:       '/v1/wallet/generic_deposits',
          generic_deposit:        '/v1/wallet/generic_deposits/:generic_deposit_id',
          generic_withdrawals:    '/v1/wallet/generic_withdrawals',
          generic_withdrawal:     '/v1/wallet/generic_withdrawals/:generic_withdrawal_id',
          ledger:                 '/v1/wallet/ledger',
          withdrawal_limit:       '/v1/wallet/limits/withdrawal',
          transfer:               '/v1/wallet/transfer',
          withdrawal_addresses:   '/v1/wallet/withdrawal_addresses',
          withdrawal_address:     '/v1/wallet/withdrawal_addresses/:wallet_id',
          withdrawal_frozen:      '/v1/wallet/withdrawal_frozen',
          withdrawals:            '/v1/wallet/withdrawals',
          withdrawal:             '/v1/wallet/withdrawals/:withdrawal_id',
          withdrawal_fee:         '/v1/wallet/withdrawals/fee',
        },

        funding: {
          auto_offerings:  '/v1/funding/auto_offerings',
          auto_offering:   '/v1/funding/auto_offerings/:currency_id',
          funding_history: '/v1/funding/funding_history',
          fundings:        '/v1/funding/fundings',
          funding:         '/v1/funding/fundings/:funding_id',
          loans:           '/v1/funding/loans',
          loan:            '/v1/funding/loans/:loan_id',
        }
      }.freeze
    end
  end
end
