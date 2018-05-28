# Cobinhood

This is an unofficial Ruby wrapper for the Cobinhood exchange REST and WebSocket APIs.

##### Notice

* This is Alpha software.  All issues should be aggressively reported for quick resolution!
* RESTful interface is fully implemented.
* Websocket is *not* done.
* Pull Requests are very welcome!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cobinhood'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cobinhood

## Features

#### Current

* Basic implementation of REST API
  * Easy to use authentication
  * Methods return parsed JSON
  * No need to generate timestamps
  * No need to generate signatures

#### Planned

* Basic implementation of WebSocket API
  * Pass procs or lambdas to event handlers
  * Single and multiple streams supported
  * Runs on EventMachine

* Exception handling with responses
* High level abstraction

## Getting Started

#### REST Client

Require Cobinhood:

```ruby
require 'cobinhood'
```

Create a new instance of the REST Client:

```ruby
# If you only plan on touching public API endpoints, you can forgo any arguments
client = Cobinhood::Client::REST.new

# Otherwise provide an api_key as keyword arguments
client = Cobinhood::Client::REST.new api_key: 'x'
```

ALTERNATIVELY, set your API key in exported environment variable:

```bash
export COBINHOOD_API_KEY=your.api_key
```

Then you can instantiate client without parameters as in first variation above.

Create various requests:

```ruby
# Ping the server
client.time
  # => {"time"=>1527470756975}

# Get candle data
client.candles "ABT-BTC", timeframe: '1m'
  # => {"candles"=>[
  #   {"timeframe"=>"1m", "trading_pair_id"=>"ABT-BTC", "timestamp"=>1527384360000, "volume"=>"0",
  #     "open"=>"0.00012873", "close"=>"0.00012873", "high"=>"0.00012873", "low"=>"0.00012873"
  #   },
  #   {"timeframe"=>"1m", "trading_pair_id"=>"ABT-BTC", "timestamp"=>1527384420000, "volume"=>"0",
  #     "open"=>"0.00012873", "close"=>"0.00012873", "high"=>"0.00012873", "low"=>"0.00012873"
  #   },
  #   {"timeframe"=>"1m", "trading_pair_id"=>"ABT-BTC", ...


# Place an order
client.place_order 'ABT-BTC', side: :ask, type: :limit, price: 0.000127, size: 22
  # => {
  #   "order"=>{
  #     "id"=>"298e5465-7282-47ca-9a1f-377c56487f5f",
  #     "trading_pair_id"=>"ABT-BTC",
  #     "side"=>"ask",
  #     "type"=>"limit",
  #     "price"=>"0.000127",
  #     "size"=>"22",
  #     "filled"=>"0",
  #     "state"=>"queued",
  #     "timestamp"=>1527471152779,
  #     "eq_price"=>"0",
  #     "completed_at"=>nil,
  #     "source"=>"exchange"
  #     }
  #   }


# Get deposit address
client.get_deposit_addresses
  => { "deposit_addresses"=>[
    { "address"=>"0x8bdFCC26CaA363234528288471107D90525d6BF923",
      "blockchain_id"=>"ethereum",
      "created_at"=>1527263083623,
      "currency"=>"FXT",
      "type"=>"exchange"
      },
    ...
```

Required and optional parameters, as well as enum values, can currently be found on the [Cobinhood GitHub Page](https://cobinhood.github.io/api-public). Parameters should always be passed to client methods as keyword arguments in snake_case form.  trading_pair_id, when a required parameter is simply passed as first parameter for most API calls.

### REST Endpoints

REST endpoints are in order as documented on the Cobinhood Github page (linked above).  The following lists only the method
names, aliases (if any) and parameters of the methods to access endpoints.  For the most part, method names follow naming
of the endpoint's URL and alias method follows the title/name given in Cobinhood API documentation.  There were some deviations
where there would otherwise be name clashes/overloading.

#### System Endpoints
----
name: time
* required params: none
----
name: info
* required params: none

#### Market Endpoints
----
name: currencies
* alias: get_all_currencies
* required params: none
----
name: trading_pairs
* alias: get_all_trading_pairs
* required params: none
----
name: order_book trading_pair_id
* alias: get_order_book
* required params: trading_pair_id
----
name: precisions trading_pair_id
* alias: get_order_book_precisions
* required params: trading_pair_id
----
name: stats
* required params: none
----
name: tickers trading_pair_id
* alias: get_ticker
* required params: none
----
name: market_trades trading_pair_id
* alias: get_recent_trades
* required params: none

#### Chart Endpoints
----
name: candles trading_pair_id, options={}
* required params: trading_pair_id, timeframe

#### Trading Endpoints
----
name: order order_id
* alias: get_order
* required params: order_id
----
name: order_trades order_id
* alias: get_trades_of_an_order
* required params: order_id
----
name: orders
* alias: get_all_orders
* required params: none
----
name: place_order trading_pair_id, options={}
* required params: side, type, size, price (except market orders)
----
name: modify_order order_id, options={}
* required params: order_id, size, price
----
name: cancel_order order_id
* required params: order_id
----
name: order_history trading_pair_id=nil, options={}
* alias: get_order_history
* required params: none
----
name: get_trade trade_id
* alias: trade
* required params: trade_id
----
name: trades trading_pair_id, options={}
* required params: trading_pair_id

#### Wallet Endpoints
----
name: balances
* alias: get_wallet_balances
* required params: none
----
name: ledger
* alias: get_ledger_entries
* required params: none
----
name: deposit_addresses
* alias: get_deposit_addresses
* required params: none
----
name: withdrawal_addresses
* alias: get_withdrawal_addresses
* required params: none
----
name: withdrawal withdrawal_id
* alias: get_withdrawal
* required params: withdrawal_id
----
name: withdrawals
* alias: get_all_withdrawals
* required params: none
----
name: deposit deposit_id
* alias: get_deposit
* required params: deposit_id
----
name: deposits
* alias: get_all_deposits
* required params: none

#### WebSocket Client

* COMING SOON!

## Development

* RSPECs coming soon!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mwlang/cobinhood.

## Inspiration

The inspiration for architectural layout of this gem comes nearly one-for-one from the [Binance gem](https://github.com/craysiii/binance) by craysiii.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
