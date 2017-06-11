class CreateKaraokeSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :karaoke_sessions do |t|
      t.string :token
      t.integer :room
      t.date :StartTime
      t.string :time
      t.string :users
      t.date :CreatedAt
      t.string :time
      t.datetime :UpdatedAt

      t.timestamps
    end
  end
end
