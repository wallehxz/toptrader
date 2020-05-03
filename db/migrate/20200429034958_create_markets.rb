class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.integer  :user_id
      t.string   :base_unit
      t.string   :quote_unit
      t.string   :source
      t.string   :type
      t.timestamps null: false
    end
  end
end
