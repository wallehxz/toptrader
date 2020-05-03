# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  market     :string
#  key        :string
#  secret     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ApiToken < ActiveRecord::Base
  extend Enumerize
  self.per_page = 10
  validates_uniqueness_of :market, scope: :user_id, message: '请勿重复添加交易所秘钥'

  enumerize :market, in: ['ftx', 'binance']
end
