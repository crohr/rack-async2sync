begin
  require 'rack'
rescue LoadError
  require 'rubygems'
  require 'rack'
end

libdir = File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require 'contest'
require 'rack/test'
require 'sinatra/base'
require 'sinatra/async'
require 'rack/async2sync'

class Sinatra::Base
  # Allow assertions in request context
  include Test::Unit::Assertions
end

class Test::Unit::TestCase
  include Rack::Test::Methods
  def app
    Rack::Lint.new(@app)
  end
end
