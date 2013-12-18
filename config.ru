require 'sequel'
require 'yaml'

database_creds = YAML::load(File.read(File.join(File.dirname(__FILE__), 'config/database.yml')))

database = ENV['DATABASE_URL'] || 'sqlite://development.db'
# if database_creds
#   database = database_creds["airgo_db"]
# end
Sequel.connect(database)

require './app'

run Sinatra::Application
