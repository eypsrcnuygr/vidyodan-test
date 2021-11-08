require "rails_helper"

RSpec.describe "Trades", type: :request do
  trade_params = {
    trade_type: "buy",
    user_id: 23,
    symbol: "ABX",
    shares: 30,
    price: 134,
    timestamp: 1531522701000,
  }

  sell_params = {
    trade_type: "sell",
    user_id: 24,
    symbol: "ABX",
    shares: 20,
    price: 133,
    timestamp: 1531524301000,
  }

  def serialize_trade(trade)
    {
      id: trade.id,
      trade_type: trade.trade_type,
      user_id: trade.user_id,
      symbol: trade.symbol,
      shares: trade.shares,
      price: trade.price,
      timestamp: trade.timestamp.to_i * 1000,
    }.stringify_keys
  end

  describe "GET /trades" do
    before do
      Trade.create(trade_params)
      Trade.create(sell_params)
    end

    it "returns http success" do
      get "/trades"
      expect(response).to have_http_status(:success)
    end

    it "returns a serialized collection of all trades" do
      get "/trades"
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to be_nil
      expect(parsed_response.length).to eq(Trade.count)
      expect(parsed_response[0]).to eq(serialize_trade(Trade.first))
      expect(parsed_response[1]).to eq(serialize_trade(Trade.second))
    end

    it "filters by trade_type" do
      get "/trades?trade_type=buy"
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to be_nil
      expect(parsed_response.length).to eq(Trade.where(trade_type: "buy").count)
    end
    it "filters by user_id" do
      get "/trades?user_id=23"
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to be_nil
      expect(parsed_response.length).to eq(Trade.where(user_id: 23).count)
    end
    it "filters can be combined" do
      get "/trades?user_id=23&trade_type=buy"
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to be_nil
      expect(parsed_response.length).to eq(Trade.where({ user_id: 23, trade_type: "buy" }).count)
    end
  end

  describe "GET /trades/:id" do
    before do
      Trade.create(trade_params)
    end

    it "returns http success" do
      get "/trades/#{Trade.first.id}"
      expect(response).to have_http_status(:success)
    end

    it "returns the serialized trade object" do
      get "/trades/#{Trade.first.id}"
      expect(JSON.parse(response.body)).to eq(serialize_trade(Trade.first))
    end

    it "returns 404 if no trade with id is found" do
      get "/trades/83492642394"
      expect(response).to have_http_status(404)
    end
  end

  describe "POST /trades" do
    it "returns http created" do
      post "/trades", { params: trade_params }
      expect(response).to have_http_status(:created)
    end

    it "adds a trade to the database" do
      post "/trades", { params: trade_params }
      expect(Trade.count).to eq(1)
    end

    it "returns the created trade object" do
      post "/trades", { params: trade_params }
      expected = trade_params.stringify_keys
      expected["id"] = 1
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it "ignores id param" do
      params = trade_params
      params[:id] = 5
      post "/trades", { params: params }

      expect(JSON.parse(response.body)["id"]).to eq(1)
    end
  end

  describe "/trades/:id" do
    before do
      Trade.create(trade_params)
    end

    it "DELETE returns a 405 status code" do
      delete "/trades/#{Trade.first.id}"

      expect(response.status).to eq(405)
    end
    it "PUT returns a 405 status code" do
      new_trade_params = trade_params
      new_trade_params[:trade_type] = "sell"
      put "/trades/#{Trade.first.id}", params: new_trade_params

      expect(response.status).to eq(405)
    end
    it "PATCH returns a 405 status code" do
      patch "/trades/#{Trade.first.id}", params: { trade_type: "sell" }

      expect(response.status).to eq(405)
    end
  end
end
