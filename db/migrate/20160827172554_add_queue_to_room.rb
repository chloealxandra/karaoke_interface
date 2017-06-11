class AddQueueToRoom < ActiveRecord::Migration[5.0]
  def change
    add_column :karaoke_rooms, :queue, :json
  end
end
