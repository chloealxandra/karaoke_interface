class AddSoIdToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :soID, :integer
  end
end
