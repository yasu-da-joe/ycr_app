class CreateSections < ActiveRecord::Migration[7.2]
  def change
    create_table :sections do |t|
      t.references :report, null: false, foreign_key: true
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
