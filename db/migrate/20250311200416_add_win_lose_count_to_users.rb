class AddWinLoseCountToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :win_count, :integer, default: 0, null: false
    add_column :users, :lose_count, :integer, default: 0, null: false
  end
end
