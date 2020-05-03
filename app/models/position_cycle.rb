# == Schema Information
#
# Table name: position_cycles
#
#  id         :integer          not null, primary key
#  market_id  :integer
#  user_id    :integer
#  cycle_id   :integer
#  title      :string
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PositionCycle < ActiveRecord::Base
  extend Enumerize
  self.per_page = 10
  enumerize :state, in: ['open', 'closed'], default: 'open'
  belongs_to :market
  scope :closed, -> { where(state: 'closed')}
  has_many   :orders, foreign_key: :cycle_id
  has_many   :bids, class_name: 'OrderBid', foreign_key: :cycle_id
  has_many   :asks, class_name: 'OrderAsk', foreign_key: :cycle_id

  before_create :set_cycle_id_user_id
  def set_cycle_id_user_id
    self.cycle_id = PositionCycle.where(market_id: self.market_id).count + 1
    self.user_id = self.market.user_id
  end

  def collection_orders
    blank_orders = market.orders.where(cycle_id: nil).order(created_at: :asc)
    blank_orders.each do |item|
      if self.state == 'open'
        item.update(cycle_id: self.id)
        bid_ask_contrast
      end
    end
  end

  def bid_ask_contrast
    if bids.all.count > 0 && asks.all.count > 0
      if bids.all.map(&:amount).sum.round(2) - asks.all.map(&:amount).sum.round(2) < 0.01
        self.update(state: 'closed')
      end
    end
  end
end
