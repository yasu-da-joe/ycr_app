class RenameUserFavoritsToUserFavorites < ActiveRecord::Migration[6.1]
  def change
    rename_table :user_favorits, :user_favorites
    rename_column :user_favorites, :favorit_user_id, :favorited_user_id
  end
end