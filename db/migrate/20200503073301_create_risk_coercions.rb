class CreateRiskCoercions < ActiveRecord::Migration
  def change
    create_table :risk_coercions do |t|
      t.integer   :user_id
      t.float     :daily_loss
      t.float     :week_loss
      t.float     :daily_ratio
      t.float     :week_ratio
      t.string    :notice_webhook
    end
  end
end
