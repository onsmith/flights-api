class CreateInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :instances do |t|
      ## Flight
      t.belongs_to :flight, null: false, index: true

      ## Date of flight
      t.date :date, null: false

      ## Cancellation status
      t.boolean :is_cancelled, null: false, default: false

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Client-defined info
      t.text :info

      ## Always include timestamps
      t.timestamps null: false
    end
  end
end
