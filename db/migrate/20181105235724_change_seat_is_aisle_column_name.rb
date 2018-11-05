class ChangeSeatIsAisleColumnName < ActiveRecord::Migration[5.1]
  def change
    change_table :seats do |t|
      t.rename :is_isle, :is_aisle
    end
  end
end
