class RenameOrderToPositionInSetListOrders < ActiveRecord::Migration[7.2]
  def change
    rename_column :set_list_orders, :order, :position
  end
end
