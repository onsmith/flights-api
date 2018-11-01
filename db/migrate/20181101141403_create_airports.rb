class CreateAirports < ActiveRecord::Migration[5.1]
  def change
    create_table :airports do |t|
      ## Airport name and code
      t.string :name, null: false
      t.string :code, null: false

      ## Geolocation
      t.string :latitude
      t.string :longitude

      ## Address
      t.string :city
      t.string :state

      ## Photo of city
      t.string :city_url

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Always include timestamps
      t.timestamps
    end
  end
end
