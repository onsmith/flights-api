class CreateSeats < ActiveRecord::Migration[5.1]
  def change
    create_table :seats do |t|
      ## Seat number and info
      t.string  :number, null: false
      t.string  :type
      t.string  :class
      t.boolean :is_exit

      ## Plane this seat belongs to
      t.belongs_to :plane, index: true, null: false

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Always include timestamps
      t.timestamps
    end
  end
end
