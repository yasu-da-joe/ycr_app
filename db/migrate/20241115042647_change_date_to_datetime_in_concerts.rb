class ChangeDateToDatetimeInConcerts < ActiveRecord::Migration[7.2]
  def change
    change_column :concerts, :date, :datetime
  end
end
