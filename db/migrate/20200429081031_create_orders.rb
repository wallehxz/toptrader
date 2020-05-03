class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer   :market_id
      t.integer   :user_id
      t.integer   :order_id, limit: 8
      t.string    :type
      t.string    :pattern
      t.float     :price
      t.float     :amount
      t.float     :total
      t.datetime  :created_at
    end
  end
end
