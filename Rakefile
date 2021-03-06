require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rack-async2sync"
    gem.summary = %Q{A Rack middleware that transforms async requests (using thin + async_sinatra for example) into synchronous requests.}
    gem.description = %Q{A Rack middleware that transforms async requests (using thin + async_sinatra for example) into synchronous requests. Useful for testing Async Sinatra apps with a minimum of changes in your testing environment.}
    gem.email = "cyril.rohr@gmail.com"
    gem.homepage = "http://github.com/crohr/rack-async2sync"
    gem.authors = ["Cyril Rohr"]
    gem.add_development_dependency "contest"
    gem.add_dependency "eventmachine"
    gem.add_dependency "async_sinatra"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rack-async2sync #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
