class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :status
      t.integer :creator_id
      t.integer :participant_id
      t.integer :winner_id
      t.integer :loser_id
      t.datetime :finished_at

      t.timestamps
    end
  end
end
