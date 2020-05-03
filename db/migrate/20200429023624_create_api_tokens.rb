class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.integer :user_id
      t.string  :market
      t.string  :key
      t.string  :secret

      t.timestamps null: false
    end
  end
end
