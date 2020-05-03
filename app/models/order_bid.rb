# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  market_id  :integer
#  user_id    :integer
#  order_id   :bigint
#  type       :string
#  pattern    :string
#  price      :float
#  amount     :float
#  total      :float
#  created_at :datetime
#  cycle_id   :integer
#

class OrderBid < Order
end
