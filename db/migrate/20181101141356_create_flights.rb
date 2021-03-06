class CreateFlights < ActiveRecord::Migration[5.1]
  def change
    create_table :flights do |t|
      ## Departure/arrival times
      t.time :departs_at, null: false
      t.time :arrives_at, null: false

      ## Flight number
      t.string :number, null: false

      ## Airports
      t.belongs_to :departure, null: false, index: true
      t.belongs_to :arrival,   null: false, index: true

      ## Airline, Plane
      t.belongs_to :plane,   index: true
      t.belongs_to :airline, index: true

      ## Next flight segment, to be used by multi-hop flights
      t.belongs_to :next_flight, index: true

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Client-defined info
      t.text :info

      ## Always include timestamps
      t.timestamps null: false
    end
  end
end
