require 'eventmachine'
module Rack
  # A Rack middleware that transforms async requests (using thin + async_sinatra for example) into synchronous requests
  # Useful for testing with a minimum of changes in your testing environment.
  # e.g.
  #   require 'sinatra/base'
  #   require 'sinatra/async'
  #   require 'rack/async2sync'
  #   require 'spec'
  #   require 'rack/test'
  #   Test::Unit::TestCase.send :include, Rack::Test::Methods
  # 
  #   class MyAsyncRackApp < Sinatra::Base
  #     register Sinatra::Async
  #     aget '/delay/:n' do |n|
  #       EM.add_timer(n.to_i) { body { "delayed for #{n} seconds" } }
  #     end
  #   end
  # 
  #   def app
  #     Rack::Async2Sync.new(MyAsyncRackApp)
  #   end
  # 
  #   it "requests the /delay/:n asynchronous method" do
  #     get '/delay/2'
  #     # you can use the usual methods of Rack::Test::Methods
  #     last_response.status.should == 200
  #     last_response.body.should == "delayed for 2 seconds"
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