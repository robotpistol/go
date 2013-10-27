require 'sequel'

Sequel.migration 'create links' do
  up do
    create_table :links do
      primary_key :id
      String :name, :unique => true, :null => false
      String :url, :unique => false, :null => false
      Integer :hits, :default => 0
      DateTime :created_at
      index :name
    end
  end

  down do
    drop_table(:links)
  end
end

