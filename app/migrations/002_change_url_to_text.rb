# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :links do
      set_column_type :url, String, text: true
    end
  end

  down do
    alter_table :links do
      set_column_type :url, String
    end
  end
end
