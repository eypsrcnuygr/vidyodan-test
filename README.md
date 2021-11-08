# Ruby on Rails: Stock Trades API

## Project Specifications

**Read-Only Files**
- spec/*
- db/migrate/*

**Environment**  

- Ruby version: 2.7.1
- Rails version: 6.0.2
- Default Port: 8000

**Commands**
- run: 
```bash
bin/bundle exec rails server --binding 0.0.0.0 --port 8000
```
- install: 
```bash
bin/env_setup && source ~/.rvm/scripts/rvm && rvm --default use 2.7.1 && bin/bundle install
```
- test: 
```bash
RAILS_ENV=test bin/rails db:migrate && RAILS_ENV=test bin/bundle exec rspec
```
    
## Question description

In this challenge, your task is to implement a simple REST API to manage a collection of stock trades.

Each trade has the following structure:

- `id`: The unique ID of the trade.
- `trade_type`: The type of the trade, either 'buy' or 'sell'.
- `user_id`: The unique user ID
- `symbol`: Currency symbol of the trade.
- `shares`: The total number of shares traded. The traded shares value is between 10 and 30 shares, inclusive.
- `price`: The price of one share of stock at the time of the trade.
- `timestamp`: The epoch time of the stock trade in milliseconds.

Example of a trade data JSON object:
```
{
    "id":1,
    "trade_type": "buy",
    "user_id": 23,
    "symbol": "ABX",
    "shares": 30,
    "price": 134,
    "timestamp": 1531522701000
}
```

## Requirements:
The model implementation is provided, you may add methods, but you cannot alter its schema. It has a timestamp field of
DateTime type, which must be serialized to/from JSON's timestamp of integer
type.

The REST service must expose the `/trades` endpoint, which allows for managing
the collection of trade records in the following way:

**POST** request to `/trades`

- creates a new trade
- expects a JSON trade object without an id property as a body payload. You can
  assume that the given object is always valid.
- adds the given trade object to the collection of trades and assigns a unique
  integer id to it. The first created trade must have id 1, the second one 2,
and so on.
- the response code is 201, and the response body is the created trade object

**GET** request to `/trades`

- return a collection of all trades
- the response code is 200, and the response body is an array of all trades
  objects ordered by their ids in increasing order
- optionally accepts query parameters trade_type and user_id, for example
  `/trades?trade_type=buy&user_id=122`. All these parameters are optional. In case
they are present, only objects matching the parameters must be returned.

**GET** request to `/trades/:id`

- returns a trade with the given id
- if the matching trade exists, the response code is 200 and the response body
  is the matching trade object
- if there is no trade with the given id in the collection, the response code is
  404

**DELETE**, **PUT**, **PATCH** request to `/trades/:id`

- the response code is 405 because the API does not allow deleting or modifying
  trades for any id value
