module Cobinhood
  module Client
    class REST
      module SystemAPI
        def time
          request :system, :get, :time
        end

        def localtime
          Time.at time["result"]["time"] / 1000.0
        end

        def info
          request :system, :get, :info
        end
      end
    end
  end
end
