class Backend::BalancesController < Backend::BaseController
  def index
    @balances = current_user.balances.current
  end

end
