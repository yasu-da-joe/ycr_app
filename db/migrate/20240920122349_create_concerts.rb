class CreateConcerts < ActiveRecord::Migration[7.2]
  def change
    create_table :concerts do |t|
      t.string :name
      t.date :date
      t.string :artist

      t.timestamps
    end
  end
end
