class Backend::MarketsController < Backend::BaseController

  def index
    @markets = current_user.markets.paginate(page:params[:page])
  end

  def new; end

  def edit; end

  def create
    @market = current_user.markets.new(market_params)
    if @market.save
      redirect_to backend_markets_path, notice: '新交易市场添加成功'
    else
      flash[:warn] = @market.errors.messages.values.first
      render :new
    end
  end

  def update
    if @market.update(exchange_params)
      redirect_to backend_markets_path, notice: '交易市场更新成功'
    else
      flash[:warn] = @market.errors.messages.values.first
      render :edit
    end
  end

  def destroy
    @market.destroy
    flash[:notice] = "交易市场删除成功"
    redirect_to :back
  end

  def sync_orders
    @market.sync_orders
    @market.collection_orders
    flash[:notice] = "已同步 #{@market.orders.count} 订单"
    redirect_to :back
  end

private

  def market_params
    params.require(:market).permit(:base_unit, :quote_unit, :source)
  end

  def exchange_params
    Market.exchanges.each do |ex|
      return params.require(ex.to_sym).permit(:base_unit, :quote_unit, :source) if params[ex.to_sym]
    end
  end

end
