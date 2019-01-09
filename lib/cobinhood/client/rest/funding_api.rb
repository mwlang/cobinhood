# frozen_string_literal: true
module Cobinhood
  module Client
    class REST
      # Public: A Module containing all of the Public API endpoints
      module FundingAPI

        def create_auto_offering options={}
          assert_required_param options, :currency
          assert_required_param options, :interest_rate
          assert_required_param options, :period
          assert_required_param options, :size
          request :funding, :post, :auto_offerings, options
        end
        alias setup_auto_offering create_auto_offering

        def auto_offerings
          request :funding, :get, :auto_offerings
        end
        alias get_all_active_auto_offerings auto_offerings

        def disable_auto_offering currency_id
          request :funding, :delete, :auto_offering, currency_id: currency_id
        end

        def auto_offering currency_id
          request :funding, :get, :auto_offering, currency_id: currency_id
        end
        alias get_auto_offering auto_offering

        def funding_history options={}
          request :funding, :get, :funding_history, options
        end
        alias get_funding_orders_history funding_history

        def create_funding options={}
          assert_required_param options, :currency
          assert_required_param options, :interest_rate
          assert_required_param options, :size
          assert_required_param options, :type, order_types
          assert_required_param options, :period
          assert_required_param options, :side, sides
          request :funding, :post, :fundings, options
        end
        alias place_funding_order create_funding

        def fundings options={}
          request :funding, :get, :fundings, options
        end
        alias get_open_funding_orders fundings

        def modify_funding funding_id, options={}
          assert_required_param options, :interest_rate
          assert_required_param options, :size
          request :funding, :put, :funding, options.merge(funding_id: funding_id)
        end
        alias modify_funding_order modify_funding

        def cancel_funding funding_id
          request :funding, :delete, :funding, funding_id: funding_id
        end
        alias cancel_funding_order cancel_funding

        def loans options={}
          assert_required_param options, :state, loan_states if options[:state]
          assert_required_param options, :side, sides if options[:side]
          request :funding, :get, :loans, options
        end
        alias get_all_loans loans

        def close_loan loan_id
          request :funding, :delete, :loan, loan_id: loan_id
        end

        def loan loan_id
          request :funding, :get, :loan, loan_id: loan_id
        end
        alias get_loan loan

        private

        def loan_states
          %w{in_use active}
        end
      end
    end
  end
end
