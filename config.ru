require './app'

configure :development do
    set :database, 'sqlite://development.db'
end

configure :production do
    Sequel.connect(ENV['DATABASE_URL'])
end

run Sinatra::Application
