class AddMulticolumnIndexToNameAndCompanyIdOnFlights < ActiveRecord::Migration[7.2]
  def up
    execute <<-SQL
      CREATE UNIQUE INDEX multicolumn_index_flights_on_name_and_company_id
      ON flights (lower(name), company_id);
    SQL
  end

  def down
    execute 'DROP INDEX multicolumn_index_flights_on_name_and_company_id;'
  end
end
