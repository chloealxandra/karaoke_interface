class AddTextBoxToFavorites < ActiveRecord::Migration[5.0]
  def change
    add_column :favorites, :text_box, :string
  end
end
