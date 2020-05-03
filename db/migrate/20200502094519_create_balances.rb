class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.integer   :user_id
      t.string    :account
      t.string    :coin
      t.float     :free
      t.float     :locked
      t.float     :total
      t.float     :usd_value
      t.date      :date_at
    end
  end
end
