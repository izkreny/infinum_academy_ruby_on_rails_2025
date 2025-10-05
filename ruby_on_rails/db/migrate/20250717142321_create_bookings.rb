class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.integer :no_of_seats, null: false
      t.integer :seat_price, null: false

      t.timestamps

      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :flight, index: true, foreign_key: true
    end
  end
end
