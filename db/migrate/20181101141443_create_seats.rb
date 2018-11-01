class CreateSeats < ActiveRecord::Migration[5.1]
  def change
    create_table :seats do |t|
      ## Seat number and info
      t.string  :class
      t.integer :row,       null: false
      t.string  :number,    null: false
      t.boolean :is_window, null: false, default: false
      t.boolean :is_isle,   null: false, default: false
      t.boolean :is_exit,   null: false, default: false

      ## Plane this seat belongs to
      t.belongs_to :plane, index: true, null: false

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Client-defined info
      t.text :info

      ## Always include timestamps
      t.timestamps null: false
    end
  end
end
