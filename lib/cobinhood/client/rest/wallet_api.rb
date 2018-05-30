# frozen_string_literal: true
module Cobinhood
  module Client
    class REST
      # Public: A Module containing all of the Public API endpoints
      module WalletAPI

        def balances
          request :wallet, :get, :balances
        end
        alias get_wallet_balances balances

        def ledger
          request :wallet, :get, :ledger
        end
        alias get_ledger_entries ledger

        def deposit_addresses
          request :wallet, :get, :deposit_addresses
        end
        alias get_deposit_addresses deposit_addresses

        def withdrawal_addresses
          request :wallet, :get, :withdrawal_addresses
        end
        alias get_withdrawal_addresses withdrawal_addresses

        def withdrawal withdrawal_id
          request :wallet, :get, :withdrawal, withdrawal_id: withdrawal_id
        end
        alias get_withdrawal withdrawal

        def withdrawals
          request :wallet, :get, :withdrawals
        end
        alias get_all_withdrawals withdrawals

        def deposit deposit_id
          request :wallet, :get, :deposit, deposit_id: deposit_id
        end
        alias get_deposit deposit

        def deposits
          request :wallet, :get, :deposits
        end
        alias get_all_deposits deposits
      end
    end
  end
end
