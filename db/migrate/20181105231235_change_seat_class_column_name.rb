class ChangeSeatClassColumnName < ActiveRecord::Migration[5.1]
  def change
    change_table :seats do |t|
      t.rename :class, :cabin
    end
  end
end
