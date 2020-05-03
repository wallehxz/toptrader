class Backend::ApiTokensController < Backend::BaseController

  def index
    @tokens = current_user.tokens.paginate(page:params[:page])
  end

  def new;end

  def edit;end

  def create
    @api_token = current_user.tokens.new(api_token_params)
    if @api_token.save
      redirect_to backend_api_tokens_path, notice: '交易所秘钥添加成功'
    else
      flash[:warn] = @api_token.errors.messages.values.first rescue "请完善表单信息"
      render :new
    end
  end

  def update
    if @api_token.update(api_token_params)
      redirect_to backend_api_tokens_path, notice: '交易所秘钥更新成功'
    else
      flash[:warn] = @api_token.errors.messages.values.first rescue "请完善表单信息"
      render :edit
    end
  end

  def destroy
    @api_token.destroy
    flash[:notice] = "交易所秘钥删除成功"
    redirect_to :back
  end

private

  def api_token_params
    params.require(:api_token).permit(:market, :key, :secret)
  end

end
