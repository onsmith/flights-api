class CreateItineraries < ActiveRecord::Migration[5.1]
  def change
    create_table :itineraries do |t|
      ## Confirmation
      t.string :confirmation_code

      ## Purchaser information
      t.string :email

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Client-defined info
      t.text :info

      ## Always include timestamps
      t.timestamps null: false
    end
  end
end
