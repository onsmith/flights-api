class CreatePlanes < ActiveRecord::Migration[5.1]
  def change
    create_table :planes do |t|
      ## Plane name
      t.string :name, null: false

      ## URL to photo of seatmap
      t.string :seatmap_url

      ## Might belong to a student
      t.belongs_to :user, index: true

      ## Always include timestamps
      t.timestamps
    end
  end
end
