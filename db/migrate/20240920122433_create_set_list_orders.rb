class CreateSetListOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :set_list_orders do |t|
      t.references :section, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.integer :order
      t.text :body

      t.timestamps
    end
  end
end
