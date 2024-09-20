class CreateReports < ActiveRecord::Migration[7.2]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :concert, null: false, foreign_key: true
      t.boolean :is_spoiler
      t.date :spoiler_until
      t.integer :report_status

      t.timestamps
    end
  end
end
