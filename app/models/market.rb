# == Schema Information
#
# Table name: markets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  base_unit  :string
#  quote_unit :string
#  source     :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Market < ActiveRecord::Base
  extend Enumerize
  self.per_page = 10
  enumerize :source, in: ['ftx', 'binance']
  has_many :cycles, class_name: 'PositionCycle'
  has_many :orders
  has_one  :balance
  has_many :bids, class_name: 'OrderBid'
  has_many :asks, class_name: 'OrderAsk'
  has_one :token, -> (this) { where(market: this.source) }, class_name: 'ApiToken', primary_key: 'user_id', foreign_key: 'user_id'
  validates_uniqueness_of :source, scope: [:user_id, :base_unit, :quote_unit], message: '请勿重复添加交易所市场'

  before_save :set_type_of_source
  def set_type_of_source
    self.type = self.source.capitalize if self.source
  end

  def self.select_lists
    [['FTX EXCHANGE','ftx'],['Binance EXCHANGE','binance']]
  end

  # Market.select(:type).distinct.map { |x| x.type.underscore.pluralize }
  def self.exchanges
    ['ftx', 'binance']
  end

  def blank_orders
    orders.where(cycle_id: nil).order(created_at: :asc)
  end

  def collection_orders
    while blank_orders.count > 0
      cycle = cycles.where(state: 'open').first || cycles.create(title: Time.now.to_s(:short))
      cycle.collection_orders
    end
  end

end
