class CreateUserFavorits < ActiveRecord::Migration[7.2]
  def change
    create_table :user_favorits do |t|
      t.references :user, foreign_key: true
      t.integer :favorit_user_id

      t.timestamps
    end
  end
end
