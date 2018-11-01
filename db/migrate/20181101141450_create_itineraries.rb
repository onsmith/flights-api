class CreateItineraries < ActiveRecord::Migration[5.1]
  def change
    create_table :itineraries do |t|
      ## Confirmation
      t.string :confirmation_code

      ## Purchaser information
      t.string :email

      ## Purchase status
      t.boolean :is_purchased, null: false, default: false

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Always include timestamps
      t.timestamps
    end
  end
end
