require 'sequel'
require 'yaml'

config_file_path = File.join(File.dirname(__FILE__), '../config/database.yml')
database_creds = YAML.safe_load(File.read(config_file_path))
database = database_creds['airgo_db']

DB = Sequel.connect(database)
