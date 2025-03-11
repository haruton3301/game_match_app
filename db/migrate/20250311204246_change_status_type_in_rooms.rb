class ChangeStatusTypeInRooms < ActiveRecord::Migration[6.0]
  def change
    change_column :rooms, :status, :integer, default: 0, null: false
  end
end
