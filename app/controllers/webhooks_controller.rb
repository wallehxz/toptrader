class WebhooksController < ApplicationController

  # 每天缓存用户账户资产，用于对比预警通知
  # crontab 0 0 * * *  curl http://www.example.com/webhook/cache_balances
  def cache_balances
    User.all.each do |usr|
      usr.markets.each do |user_market|
        user_market.sync_balances rescue nil
      end
    end
    render text:'User balances sync successed'
  end

  # crontab */10 * * * * curl http://www.example.com/webhook/cache_balances
  def risk_notice
    User.all.each do |usr|
      usr_total = 0
      usr.markets.each do |user_market|
        usr_total += user_market.current_balances
      end
      usr_balance = usr.current_balance
      usr.risk_coercion.contrast(usr_balance, usr_total)
    end
    render text:'Risk notice successed'
  end
end
