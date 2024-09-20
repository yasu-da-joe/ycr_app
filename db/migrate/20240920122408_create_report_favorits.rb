class CreateReportFavorits < ActiveRecord::Migration[7.2]
  def change
    create_table :report_favorits do |t|
      t.references :user, foreign_key: true
      t.references :report, foreign_key: true
      t.integer :favorit_report_id

      t.timestamps
    end
  end
end