class Backend::PositionCyclesController < Backend::BaseController

  def index
    @markets = current_user.markets
  end

  def new; end

  def edit; end

  def create
    @position_cycle = PositionCycle.new(position_cycle_params)
    if @position_cycle.save
      redirect_to backend_position_cycles_path, notice: '新持仓周期添加成功'
    else
      flash[:warn] = @position_cycle.errors.messages.values.first
      render :new
    end
  end

  def update
    if @position_cycle.update(position_cycle_params)
      redirect_to backend_position_cycles_path, notice: '持仓周期更新成功'
    else
      flash[:warn] = @position_cycle.errors.messages.values.first
      render :edit
    end
  end

  def destroy
    if @position_cycle.orders.count > 0
      flash[:notice] = "持仓周期已有订单，不能删除"
      redirect_to :back
    else
      @position_cycle.destroy
      flash[:notice] = "持仓周期删除成功"
      redirect_to :back
    end
  end

  def collect_orders
    @position_cycle
  end

private

  def position_cycle_params
    params.require(:position_cycle).permit(:market_id, :title)
  end

end
