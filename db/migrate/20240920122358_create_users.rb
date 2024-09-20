class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :x_account
      t.string :profile
      t.string :profile_image

      t.timestamps
    end
  end
end
