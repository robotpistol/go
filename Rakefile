# frozen_string_literal: true
require './app/db.rb'

migration_path = 'app/migrations'

namespace :db do
  namespace :migrate do
    Sequel.extension(:migration)

    desc 'Perform migration reset (full erase and migration up)'
    task reset: %i[down up] do
    end

    desc 'Perform migration up/down to VERSION'
    task :to do
      raise 'No VERSION was provided' if ENV['VERSION'].nil?

      Sequel::Migrator.run(DB, migration_path, target: ENV['VERSION'].to_i)
      puts "<= sq:migrate:to version=[#{version}] executed"
    end

    desc 'Perform migration up to latest migration available'
    task :up do
      Sequel::Migrator.run(DB, migration_path)
      puts '<= sq:migrate:up executed'
    end

    desc 'Perform migration down (erase all data)'
    task :down do
      Sequel::Migrator.run(DB, migration_path, target: 0)
      puts '<= sq:migrate:down executed'
    end
  end
  task migrate: 'migrate:up'
end
