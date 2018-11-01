class CreateItinerarys < ActiveRecord::Migration[5.1]
  def change
    create_table :itineraries do |t|
      ## Confirmation
      t.string :confirmation_code

      ## Purchaser information
      t.string :email

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Always include timestamps
      t.timestamps
    end
  end
end
