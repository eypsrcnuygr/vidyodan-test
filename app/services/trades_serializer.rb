require 'date'

class TradesSerializer
  def initialize(trades_object)
    @trade = trades_object
  end

  def to_serialized_json
    excepter(@trade)
  end

  def to_serialized_json_all
    @trade.map do |trade|
      excepter(trade)
    end
  end

  private

  def excepter(trade)
    parsed_excluded_json = JSON.parse(trade.to_json(except: %i[created_at updated_at]))
    if parsed_excluded_json['timestamp']
      parsed_excluded_json['timestamp'] =
        parsed_excluded_json['timestamp'].to_time.to_i * 1000
    end
    parsed_excluded_json
  end
end
