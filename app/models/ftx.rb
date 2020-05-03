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

class Ftx < Market
  HOST = 'https://ftx.com/api'

  def symbols
    "#{base_unit}-#{quote_unit}"
  end

  def history_orders(start_time: nil, end_time: nil)
    params = [['market', symbols]]
    params << ['start_time', start_time] if start_time
    params << ['end_time', end_time] if end_time
    get_path = "/orders/history?#{URI.encode_www_form(params.sort)}"
    host_url = "#{HOST}#{get_path}"
    timestamp = (Time.now.to_f * 1000).to_i.to_s
    signed_string = auth_signed("#{timestamp}GET#{URI(host_url).request_uri}")
    res = Faraday.get do |req|
      req.url host_url
      req.headers['FTX-KEY'] = token.key
      req.headers['FTX-TS'] = timestamp
      req.headers['FTX-SIGN'] = signed_string
    end
    result = JSON.parse(res.body)
  end

  def sync_orders
    has_more = true
    end_time = nil
    while has_more
      result = history_orders(end_time: end_time)
      order_lists = result['result']
      order_lists.map {|i| orders.create(build_new_order(i)) if i['avgFillPrice']}
      has_more = result['hasMoreData']
      end_time = Time.parse(order_lists[-1]['createdAt']).to_i
      puts "Start request before #{end_time} Time Data"
    end
  end

  def build_new_order(order)
    _order = {}
    _order[:user_id] = self.user_id
    _order[:order_id] = order['id']
    _order[:type] = trans_order_side(order['side'])
    _order[:pattern] = order['type']
    _order[:price] = order['avgFillPrice']
    _order[:amount] = order['size']
    _order[:created_at] = order['createdAt']
    _order
  end

  def trans_order_side(side)
    {'buy'=> 'OrderBid', 'sell'=> 'OrderAsk'}[side]
  end

  def auth_signed(payload)
    digest = OpenSSL::Digest.new('sha256')
    OpenSSL::HMAC.hexdigest(digest, token.secret, payload)
  end

  def get_all_balances
    get_path = "/wallet/all_balances"
    host_url = "#{HOST}#{get_path}"
    timestamp = (Time.now.to_f * 1000).to_i.to_s
    signed_string = auth_signed("#{timestamp}GET#{URI(host_url).request_uri}")
    res = Faraday.get do |req|
      req.url host_url
      req.headers['FTX-KEY'] = token.key
      req.headers['FTX-TS'] = timestamp
      req.headers['FTX-SIGN'] = signed_string
    end
    result = JSON.parse(res.body)
  end

  def current_balances
    lists = get_all_balances['result']
    current = 0
    lists.each do |account, _balances|
      _balances.each do |balance|
        current += balance['usdValue']
      end
    end
    current
  end

  def sync_balances
    lists = get_all_balances['result']
    lists.each do |account, _balances|
      _balances.each do |balance|
        params = {}
        params[:user_id] = self.user_id
        params[:account] = account
        params[:coin] = balance['coin']
        params[:free] = balance['free']
        params[:total] = balance['total']
        params[:usd_value] = balance['usdValue']
        params[:date_at] = Date.current
        Balance.create_or_update_by(params)
      end
    end
  end

end
