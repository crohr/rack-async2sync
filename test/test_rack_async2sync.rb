require 'helper'

class MyAsyncRackApp < Sinatra::Base
  register Sinatra::Async
  aget '/delay/:n' do |n|
    content_type :txt
    EM.add_timer(n.to_i) { body { "delayed for #{n} seconds" } }
  end
end


class TestRackAsync2Sync < Test::Unit::TestCase
  test "gets the response for an async request" do
    @app = Rack::Async2Sync.new(MyAsyncRackApp)
    get '/delay/1'
    assert last_response.ok?
    assert_equal "delayed for 1 seconds", last_response.body
    assert_equal "text/plain", last_response.headers['Content-Type']
  end
end
