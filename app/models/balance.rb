# == Schema Information
#
# Table name: balances
#
#  id        :integer          not null, primary key
#  user_id   :integer
#  account   :string
#  coin      :string
#  free      :float
#  locked    :float
#  total     :float
#  usd_value :float
#  date_at   :date
#

class Balance < ActiveRecord::Base
  scope :current, -> {where(date_at: Date.current)}

  class << self
    def create_or_update_by(**params)
      if bal = Balance.where(user_id: params[:user_id], account: params[:account], coin: params[:coin], date_at: params[:date_at]).first
        bal.update(params)
      else
        Balance.create(params)
      end
    end
  end
end
