class Trade < ApplicationRecord

  def as_json(_trade)
    super(except: %i[created_at updated_at], methods: [:timestamp])
  end

  def timestamp
    self['timestamp'].to_time.to_i * 1000
  end
end
