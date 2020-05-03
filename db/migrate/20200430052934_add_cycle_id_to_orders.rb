class AddCycleIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cycle_id, :integer
  end
end
