class CreateInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :instances do |t|
      ## Flight
      t.belongs_to :flight, null: false, index: true

      ## Date of flight
      t.date :date, null: false

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Always include timestamps
      t.timestamps
    end
  end
end
