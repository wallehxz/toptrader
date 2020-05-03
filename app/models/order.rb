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

class Order < ActiveRecord::Base
  validates_uniqueness_of :order_id, scope: :market_id

  before_create :set_total
  def set_total
    self.total = self.price * self.amount
  end

end
