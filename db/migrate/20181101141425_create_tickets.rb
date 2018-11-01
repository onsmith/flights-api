class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      ## Passenger info
      t.string  :first_name,  null: false
      t.string  :middle_name
      t.string  :last_name,   null: false
      t.integer :age,         null: false
      t.string  :gender,      null: false

      ## Price paid for the ticket
      t.float :is_purchased, null: false, default: false

      ## Price paid for the ticket
      t.float :price_paid

      ## Seat on the plane the ticket is good for
      t.belongs_to :seat, index: true

      ## Flight instance the ticket is good for
      t.belongs_to :instance, index: true, null: false

      ## Itinerary to which the ticket belongs
      t.belongs_to :itinerary, index: true

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Always include timestamps
      t.timestamps
    end
  end
end
