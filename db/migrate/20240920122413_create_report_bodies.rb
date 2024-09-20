class CreateReportBodies < ActiveRecord::Migration[7.2]
  def change
    create_table :report_bodies do |t|
      t.references :report, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
