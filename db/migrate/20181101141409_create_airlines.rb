class CreateAirlines < ActiveRecord::Migration[5.1]
  def change
    create_table :airlines do |t|
      ## Airline name
      t.string :name, null: false

      ## Photo of airline logo
      t.string :logo_url

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Always include timestamps
      t.timestamps
    end
  end
end
