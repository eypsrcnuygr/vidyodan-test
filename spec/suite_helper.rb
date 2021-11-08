# Files the standard test suite runner command runs

RSpec.configure do |config|
  config.files_to_run = %w[
    spec/requests/trades_request_spec.rb
  ]
end
