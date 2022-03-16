require 'date'

class TradesSerializer
  def initialize(trades_object)
    @trade = trades_object
  end

  def to_serialized_json
    parsed_excluded_json = JSON.parse(@trade.to_json( :except => [:created_at, :updated_at]))
    parsed_excluded_json['timestamp'] = parsed_excluded_json['timestamp'].to_time.to_i * 1000 if parsed_excluded_json['timestamp']
    parsed_excluded_json 
  end

  def to_serialized_json_all
    result = @trade.map do |trade|
      parsed_excluded_json = JSON.parse(trade.to_json( :except => [:created_at, :updated_at]))
      parsed_excluded_json['timestamp'] = parsed_excluded_json['timestamp'].to_time.to_i * 1000 if parsed_excluded_json['timestamp']
      parsed_excluded_json 
    end
    result
  end
end