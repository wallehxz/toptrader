Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users
  devise_scope :user do
    get 'sign_in',          to:'users/sessions#new'
    post 'sign_in',         to:'users/sessions#create'
    get 'sign_up',          to:'users/registrations#new'
    post 'sign_up',         to:'users/registrations#create'
    get 'sign_out',         to:'users/sessions#destroy'
    get 'forgot_password',  to:'users/passwords#new'
    post 'forgot_password', to:'users/passwords#create'
    get 'reset_password',   to:'users/passwords#edit'
    put 'reset_password',   to:'users/passwords#update'
  end

  namespace :backend do
    root 'dashboard#index'
    get 'daemons', to: 'dashboard#daemon', as: :daemons
    get 'daemon_operate', to: 'dashboard#daemon_operate'

    resources :api_tokens
    resources :markets do
      get 'sync_orders', on: :member
    end

    resources :balances
    resources :risk_coercions

    resources :position_cycles do
      get 'collect_orders', on: :member
    end

    Market.exchanges.each do |exchange|
      patch "/#{exchange.pluralize}/:id", to: "markets#update", as: exchange.to_sym
    end
  end

  get '/webhooks/cache_balances',  to: "webhooks#cache_balances"
  get '/webhooks/risk_notice',     to: "webhooks#risk_notice"

  # https://doc.bccnsoft.com/docs/rails-guides-4.1-cn/routing.html
end
