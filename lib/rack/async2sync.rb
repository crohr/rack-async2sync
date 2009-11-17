require 'eventmachine'
module Rack
  # A Rack middleware that transforms async requests (using thin + async_sinatra for example) into synchronous requests
  # Useful for testing with a minimum of changes in your testing environment.
  # e.g.
  # 
  #   class MyAsyncRackApp < Sinatra::Base
  #     register Sinatra::Async
  #     aget '/delay/:n' do |n|
  #       content_type :txt
  #       EM.add_timer(n.to_i) { body { "delayed for #{n} seconds" } }
  #     end
  #   end
  #   
  #   
  #   class TestRackAsync2Sync < Test::Unit::TestCase
  #     test "gets the response for an async request" do
  #       @app = Rack::Async2Sync.new(MyAsyncRackApp)
  #       get '/delay/1'
  #       assert last_response.ok?
  #       assert_equal "delayed for 1 seconds", last_response.body
  #       assert_equal "text/plain", last_response.headers['Content-Type']
  #     end
  #   end
  # 
  # Author: Cyril Rohr (cyril.rohr@irisa.fr)
  #
  class Async2Sync
    class AsyncResponse
      attr_reader :status, :headers, :body
      # used to register the response given by async_sinatra in the 'async.callback' env variable.
      def [](response)
        @status, @headers, @body = response
        EM.stop
      end
    end
  
    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      response = AsyncResponse.new
      EM.run do      
        catch(:async) do
          @app.call(env.merge('async.callback' => response))
        end
      end  
      [response.status, response.headers, response.body]
    end
  end
end