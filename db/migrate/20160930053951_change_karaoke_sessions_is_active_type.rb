class ChangeKaraokeSessionsIsActiveType < ActiveRecord::Migration[5.0]
  def change
    change_column :karaoke_sessions, :is_active, :string
  end
end
