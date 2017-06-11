class AddAssociationsToKaraokeSessions < ActiveRecord::Migration[5.0]
  def change
    change_table :karaoke_sessions do |t|
      t.remove :time, :users, :CreatedAt, :UpdatedAt, :room, :StartTime
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :is_active
    end
    add_reference :karaoke_sessions, :karaoke_room, foreign_key: true
    create_table :karaoke_sessions_users, :id => false do |t|
      t.belongs_to :karaoke_sessions, index: true
      t.belongs_to :users, index: true
    end
  end
end
