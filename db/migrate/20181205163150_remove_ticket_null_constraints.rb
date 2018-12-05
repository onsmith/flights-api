class RemoveTicketNullConstraints < ActiveRecord::Migration[5.1]
  def change
    change_column_null :tickets, :instance_id, true
    change_column_null :tickets, :seat_id,     true
  end
end
