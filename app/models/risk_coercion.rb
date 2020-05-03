# == Schema Information
#
# Table name: risk_coercions
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  daily_loss     :float
#  week_loss      :float
#  daily_ratio    :float
#  week_ratio     :float
#  notice_webhook :string
#

class RiskCoercion < ActiveRecord::Base
  validates_uniqueness_of :user_id

  def contrast(historical, latest)
    if historical - latest >= daily_loss
      content = "当前亏损额度已达到每日预警 #{daily_loss} 请注意行情变动！"
      notice(content)
    end

    if historical - latest >= week_loss
      content = "当前亏损额度已达到每周预警 #{week_loss} 请注意行情变动！"
      notice(content)
    end

    if historical * (1 - daily_ratio) >= latest
      content = "当前亏损比率已达到每日 #{daily_ratio * 100}% 请注意行情变动！"
      notice(content)
    end

    if historical * (1 - week_ratio) >= latest
      content = "当前亏损比率已达到每日 #{week_ratio * 100}% 请注意行情变动！"
      notice(content)
    end
  end

  def notice(content)
    push_url = "https://oapi.dingtalk.com/robot/send?access_token=#{notice_webhook}"
    body_params ={ msgtype:'text', text:{ content: content } }
    res = Faraday.post do |req|
      req.url push_url
      req.headers['Content-Type'] = 'application/json'
      req.body = body_params.to_json
    end
  end

end
