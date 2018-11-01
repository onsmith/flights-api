class CreatePlanes < ActiveRecord::Migration[5.1]
  def change
    create_table :planes do |t|
      ## Plane name
      t.string :name, null: false

      ## Picture of seatmap
      t.string :seatmap_url

      ## Might belong to an airline
      t.belongs_to :airline, index: true

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Client-defined info
      t.text :info

      ## Always include timestamps
      t.timestamps null: false
    end
  end
end
