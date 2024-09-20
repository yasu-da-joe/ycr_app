class SchemaImprovements < ActiveRecord::Migration[7.2]
  def change
    # report_favoritesの改善
    remove_column :report_favorites, :favorit_report_id
    add_index :report_favorites, [:user_id, :report_id], unique: true

    # user_favoritesの改善
    add_foreign_key :user_favorites, :users, column: :favorited_user_id
    add_index :user_favorites, [:user_id, :favorited_user_id], unique: true

    # reportsの改善
    change_column_default :reports, :report_status, 0

    # インデックスの追加
    add_index :concerts, :date
    add_index :songs, :name
    add_index :songs, :artist

    # usersのemailにユニーク制約を追加
    add_index :users, :email, unique: true
  end
end
