# frozen_string_literal: true
module Cobinhood
  module Client
    class REST
      # Public: A Module containing all of the Public API endpoints
      module WalletAPI

        def balances options={}
          assert_required_param options, :type, ledger_types if options[:type]
          request :wallet, :get, :balances, options
        end
        alias get_balances balances

        def ledger_in_csv begin_time
          request :wallet, :get, :ledger_in_csv, begin_time: begin_time
        end
        alias get_ledger_in_csv ledger_in_csv

        def deposit_addresses
          request :wallet, :get, :deposit_addresses
        end
        alias get_deposit_addresses deposit_addresses

        def create_deposit_address currency, options={}
          assert_required_param options, :ledger_type, ledger_types
          request :wallet, :post, :deposit_addresses, options.merge(currency: currency)
        end
        alias create_new_deposit_address create_deposit_address

        def iota_deposit_address
          request :wallet, :get, :iota_deposit_addresses
        end
        alias get_iota_deposit_address iota_deposit_address

        def create_iota_deposit_address
          request :wallet, :post, :iota_deposit_addresses
        end

        def generic_deposits options={}
          request :wallet, :get, :generic_deposits, options
        end
        alias get_all_generic_deposits generic_deposits

        def generic_deposit generic_deposit_id
          request :wallet, :get, :generic_deposit, generic_deposit_id: generic_deposit_id
        end
        alias get_generic_deposit generic_deposit

        def generic_withdrawals
          request :wallet, :get, :generic_withdrawals
        end
        alias get_all_generic_withdrawals generic_withdrawals

        def cancel_generic_withdrawal generic_withdrawal_id
          request :wallet, :delete, :generic_withdrawal, generic_withdrawal_id: generic_withdrawal_id
        end

        def generic_withdrawal generic_withdrawal_id
          request :wallet, :get, :generic_withdrawal, generic_withdrawal_id: generic_withdrawal_id
        end
        alias get_generic_withdrawal generic_withdrawal

        def ledger options={}
          request :wallet, :get, :ledger, options
        end
        alias get_ledger_entries ledger

        def withdrawal_limit
          request :wallet, :get, :withdrawal_limit
        end
        alias get_withdrawal_limit withdrawal_limit

        def transfer options={}
          assert_required_param options, :from
          assert_required_param options, :to
          assert_required_param options, :currency
          assert_required_param options, :amount
          request :wallet, :post, :transfer, options
        end
        alias transfer_balance_between_wallets transfer

        def withdrawal_addresses options={}
          request :wallet, :get, :withdrawal_addresses, options
        end
        alias get_withdrawal_addresses withdrawal_addresses

        def create_withdrawal_address options={}
          assert_required_param options, :currency
          assert_required_param options, :name
          assert_required_param options, :address
          request :wallet, :post, :withdrawal_addresses, options
        end
        alias add_withdrawal_wallet create_withdrawal_address

        def delete_withdrawal_address wallet_id
          request :wallet, :delete, :withdrawal_address, wallet_id: wallet_id
        end
        alias delete_withdrawal_wallet delete_withdrawal_address

        def withdrawal_frozen
          request :wallet, :get, :withdrawal_frozen
        end
        alias get_withdrawal_frozen_status withdrawal_frozen

        def withdrawals
          request :wallet, :get, :withdrawals
        end
        alias get_all_withdrawals withdrawals

        def create_withdrawal options={}
          assert_required_param options, :currency
          assert_required_param options, :ledger_type, ledger_types
          assert_required_param options, :address
          request :wallet, :post, :withdrawals, options
        end

        def withdrawal withdrawal_id
          request :wallet, :get, :withdrawal, withdrawal_id: withdrawal_id
        end
        alias get_withdrawal withdrawal

        def withdrawal_fee options={}
          assert_required_param options, :currency
          assert_required_param options, :ledger_type, ledger_types
          assert_required_param options, :memo
          assert_required_param options, :address
          request :wallet, :post, :withdrawal_fee, options
        end
        alias get_withdrawal_fee withdrawal_fee

        private

        def ledger_types
          %w{funding margin tradable exchange coblet cob_point}
        end
      end
    end
  end
end
