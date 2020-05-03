class CreatePositionCycles < ActiveRecord::Migration
  def change
    create_table :position_cycles do |t|
      t.integer   :market_id
      t.integer   :user_id
      t.integer   :cycle_id
      t.string    :title
      t.string    :state
      t.timestamps null: false
    end
  end
end
