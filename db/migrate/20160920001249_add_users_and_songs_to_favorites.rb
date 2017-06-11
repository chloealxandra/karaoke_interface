class AddUsersAndSongsToFavorites < ActiveRecord::Migration[5.0]
  def change
    add_reference :favorites, :user, index: true, foreign_key: true
    add_reference :favorites, :song, index: true, foreign_key: true
  end
end