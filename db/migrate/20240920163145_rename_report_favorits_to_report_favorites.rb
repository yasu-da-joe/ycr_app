class RenameReportFavoritsToReportFavorites < ActiveRecord::Migration[6.1]
  def change
    rename_table :report_favorits, :report_favorites
  end
end
