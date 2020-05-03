class Backend::RiskCoercionsController < Backend::BaseController

  def index
    @risk = current_user.risk_coercion
  end

  def new
    if current_user.risk_coercion
      flash[:notice] = "请勿重复添加风控指标"
      redirect_to :back
    end
  end

  def edit; end

  def create
    @risk_coercion = current_user.build_risk_coercion(risk_coercion_params)
    if @risk_coercion.save
      redirect_to backend_risk_coercions_path, notice: '新风控预警添加成功'
    else
      flash[:warn] = @risk_coercion.errors.messages.values.first
      render :new
    end
  end

  def update
    if @risk_coercion.update(risk_coercion_params)
      redirect_to backend_risk_coercions_path, notice: '风控预警更新成功'
    else
      flash[:warn] = @risk_coercion.errors.messages.values.first
      render :edit
    end
  end

  def destroy
    @risk_coercion.destroy
    flash[:notice] = "风控预警删除成功"
    redirect_to :back
  end

private

  def risk_coercion_params
    params.require(:risk_coercion).permit(:daily_loss, :week_loss, :daily_ratio, :week_ratio, :notice_webhook)
  end
end
