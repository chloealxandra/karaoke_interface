class CreatePlays < ActiveRecord::Migration[5.0]
  def change
      create_table :plays do |t|
      t.belongs_to :user, index: true
      t.belongs_to :song, index: true
      t.belongs_to :karaoke_session, index: true
      t.timestamps
    end
  end
end
