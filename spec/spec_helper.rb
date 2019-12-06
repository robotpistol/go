require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'
require File.expand_path('../../app/airgo.rb', __FILE__)

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true){example.run}
  end
end
