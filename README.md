# Cobinhood

This is an unofficial Ruby wrapper for the Cobinhood exchange REST and WebSocket APIs.

##### Notice

* This is Alpha software.  All issues should be aggressively reported for quick resolution!
* RESTful interface is fully implemented.
* Websocket interface is fully implemented.
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

* Basic implementation of WebSocket API
  * Pass procs or lambdas to event handlers
  * Single and multiple streams supported
  * Runs on EventMachine

#### Planned

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
client = Cobinhood::Client::REST.new api_key: 'your.api_key'
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
```ruby
time
```
* required params: none
----
```ruby
info
```
* required params: none

#### Market Endpoints
----
```ruby
currencies
```
* alias: get_all_currencies
* required params: none
----
```ruby
trading_pairs
```
* alias: get_all_trading_pairs
* required params: none
----
```ruby
order_book trading_pair_id
```
* alias: get_order_book
* required params: trading_pair_id
----
```ruby
precisions trading_pair_id
```
* alias: get_order_book_precisions
* required params: trading_pair_id
----
```ruby
stats
```
* required params: none
----
```ruby
tickers trading_pair_id
```
* alias: get_ticker
* required params: none
----
```ruby
market_trades trading_pair_id
```
* alias: get_recent_trades
* required params: none

#### Chart Endpoints
----
```ruby
candles trading_pair_id, options={}
```
* required params: trading_pair_id, timeframe

#### Trading Endpoints
----
```ruby
order order_id
```
* alias: get_order
* required params: order_id
----
```ruby
order_trades order_id
```
* alias: get_trades_of_an_order
* required params: order_id
----
```ruby
orders
```
* alias: get_all_orders
* required params: none
----
```ruby
place_order trading_pair_id, options={}
  ```
* required params: side, type, size, price (except market orders)
----
```ruby
modify_order order_id, options={}
```
* required params: order_id, size, price
----
```ruby
cancel_order order_id
```
* required params: order_id
----
```ruby
order_history trading_pair_id=nil, options={}
```
* alias: get_order_history
* required params: none
----
```ruby
get_trade trade_id
```
* alias: trade
* required params: trade_id
----
```ruby
trades trading_pair_id, options={}
```
* required params: trading_pair_id

#### Wallet Endpoints
----
```ruby
balances
```
* alias: get_wallet_balances
* required params: none
----
```ruby
ledger
```
* alias: get_ledger_entries
* required params: none
----
```ruby
deposit_addresses
```
* alias: get_deposit_addresses
* required params: none
----
```ruby
withdrawal_addresses
```
* alias: get_withdrawal_addresses
* required params: none
----
```ruby
withdrawal withdrawal_id
```
* alias: get_withdrawal
* required params: withdrawal_id
----
```ruby
withdrawals
```
* alias: get_all_withdrawals
* required params: none
----
```ruby
deposit deposit_id
```
* alias: get_deposit
* required params: deposit_id
----
```ruby
deposits
```
* alias: get_all_deposits
* required params: none

### WebSocket Client


Create a new instance of the WebSocket Client:

```ruby
# If you only plan on subscribing public topics, you can forgo any arguments
client = Cobinhood::Client::Websocket.new

# Otherwise provide an api_key as keyword arguments
client = Cobinhood::Client::Websocket.new api_key: 'your.api_key'
```

ALTERNATIVELY, set your API key in exported environment variable:

```bash
export COBINHOOD_API_KEY=your.api_key
```

Subscribe various topics:

```ruby
# Candle
methods = { message: proc { |event| puts event.data } }
client.candle(trading_pair_id: 'COB-ETH', timeframe: '1m', methods: methods)
  # => {"h":["candle.COB-ETH.1m","2","subscribed"],"d":[]}
  # => {"h":["candle.COB-ETH.1m","2","s"],"d":[[...], ...]}
```

All subscription topic method will expect "methods" in argument(As shown above).
It's The Hash which contains the event handler methods to pass to the WebSocket client methods.
Proc is the expected value of each event handler key. Following are list of expected event handler keys.
  - :open    - The Proc called when a stream is opened (optional)
  - :message - The Proc called when a stream receives a message
  - :error   - The Proc called when a stream receives an error (optional)
  - :close   - The Proc called when a stream is closed (optional)

### WebSocket Subscribe Topics

Subscribe topics are in order as documented on the Cobinhood GitHub Page (linked above).

#### User's balance updates [Auth]

```ruby
  client.user_updates params: {}, methods: methods
```
* required params: methods*

#### Candle

```ruby
  client.candle trading_pair_id:, timeframe:, params: {}, methods:
```
* required params: trading_pair_id, timeframe, methods*

#### Funding [Auth]

```ruby
  client.funding params: {}, methods:
```
* required params: methods*

#### Matched loans

```ruby
  client.matched_loans currency_id:, params: {}, methods:
```
* required params: currency_id, methods*

#### Loan Ticker

```ruby
  client.loan_ticker currency_id:, params: {}, methods:
```
* required params: currency_id, methods*

#### User's loan updates [Auth]

```ruby
  client.user_loan_updates params: {}, methods:
```
* required params: methods*

#### Order, Limit Order, Limit Stop Order, Market Order, Stop Order [Auth]

```ruby
  client.order type:, action:, params: {}, methods:
```
* required params: type, action, methods*

#### Orderbook

```ruby
  client.orderbook trading_pair_id:, params: {}, methods:
```
* required params: trading_pair_id, methods*

#### User's position updates [Auth]

```ruby
  client.user_position_updates params: {}, methods:
```
* required params: methods*

#### Orderbook - repl

```ruby
  client.repl_orderbook trading_pair_id:, params: {}, methods:
```
* required params: trading_pair_id, methods*

#### Ticker

```ruby
  client.ticker trading_pair_id:, params: {}, methods:
```
* required params: trading_pair_id, methods*

#### Trade

```ruby
  client.trade trading_pair_id:, params: {}, methods:
```
* required params: trading_pair_id, methods*

## Development

* RSPECs coming soon!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mwlang/cobinhood.

## Inspiration

The inspiration for architectural layout of this gem comes nearly one-for-one from the [Binance gem](https://github.com/craysiii/binance) by craysiii.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
