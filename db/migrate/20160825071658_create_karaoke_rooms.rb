class CreateKaraokeRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :karaoke_rooms do |t|
      t.string :name
    end
  end
end
