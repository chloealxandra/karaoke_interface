class AddSingersToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :karaoke_rooms, :singers, :json
  end
end
