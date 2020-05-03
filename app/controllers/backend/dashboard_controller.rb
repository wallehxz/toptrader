class Backend::DashboardController < Backend::BaseController
  skip_load_and_authorize_resource

  def index
    cycles = current_user.cycles.closed
    @evaluates = evaluate_date_info(cycles).sort_by {|x| x[:day] }
  end

  def daemon; end

  def daemon_operate
    status = {'on': '开启', 'off': '关闭'}
    operate = params[:operate]
    Daemons::Rails::Monitoring.start("#{params[:daemon]}.rb") if operate == 'on'
    Daemons::Rails::Monitoring.stop("#{params[:daemon]}.rb") if operate == 'off'
    flash[:notice] = "进程 #{params[:daemon]} 已#{status[operate.to_sym]}"
    redirect_to backend_daemon_path
  end

private

  def evaluate_info(cycles)
    orders = []
    cycles.each do |cycle|
      _order = {}
      _order[:day] = cycle.orders.order(created_at: :desc).first.created_at.to_date
      _order[:count] = cycle.orders.count
      _order[:amount] = cycle.bids.all.map(&:amount).sum
      _order[:funds] = cycle.bids.map(&:total).sum
      _order[:profit] = cycle.asks.all.map(&:total).sum - cycle.bids.all.map(&:total).sum
      _order[:turnover] = "#{cycle.bids.size}:#{cycle.asks.size}"
      orders << _order
    end
    orders
  end

  def evaluate_date_info(cycles)
    _orders = []
    cycles.each do |cycle|
      _order = {}
      _order[:day]    = cycle.orders.order(created_at: :desc).first.created_at.to_date
      _order[:profit] = cycle.asks.all.map(&:total).sum - cycle.bids.all.map(&:total).sum
      _order[:result] = _order[:profit] > 0 ? 'gain' : 'deficit'
      _orders << _order
    end
    lists = []
    _orders.group_by {|x| x[:day] }.each do |day, orders|
      _order = {}
      _order[:day] = day
      _order[:count] = orders.size
      _gain_orders = orders.select {|x| x[:result] == 'gain' }
      _deficit_orders = orders.select {|x| x[:result] == 'deficit' }
      _order[:ave_gain] = _gain_orders.map { |x| x[:profit] }.sum / _gain_orders.size rescue 0
      _order[:ave_deficit] = _deficit_orders.map { |x| x[:profit] }.sum / _deficit_orders.size rescue 0
      _order[:ratio] = "#{_gain_orders.size} : #{_deficit_orders.size}"
      lists << _order
    end
    lists
  end

end
