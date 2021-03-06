class CreateFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flights do |t|
      t.datetime :departure_datetime
      t.datetime :arrival_datetime
      t.float :price
      t.float :flight_duration
      t.references :from_airport
      t.references :to_airport
      t.references :airline, foreign_key: true

      t.timestamps
    end
  end
end
