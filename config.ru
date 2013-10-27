require 'sequel'

database = ENV['DATABASE_URL'] || 'sqlite://development.db';
Sequel.connect(database)

require './app'

run Sinatra::Application
