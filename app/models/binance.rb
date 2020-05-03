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

class Binance < Market
end
