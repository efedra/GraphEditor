Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  #Rails.application.routes.draw do
  #  get'/users'
  #  root'users#index'
  #end

  namespace :Api do
    #get '/games', to: 'games#index'
    get '/users', to: 'users#index'
  end
end
