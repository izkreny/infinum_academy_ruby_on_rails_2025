class CreateFlights < ActiveRecord::Migration[7.2]
  def change
    create_table :flights do |t|
      t.string   :name, null: false
      t.integer  :no_of_seats
      t.integer  :base_price, null: false
      t.datetime :departs_at, null: false
      t.datetime :arrives_at, null: false

      t.timestamps

      t.belongs_to :company, index: true, foreign_key: true
    end
  end
end
