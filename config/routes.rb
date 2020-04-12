# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    resources :graphs, only: %i[index create show update destroy] do
      resources :nodes, only: %i[index create show update destroy]
      resources :edges, only: %i[index create show update destroy]
      resources :members, only: %i[index show create update destroy] do
        delete :unsubscribe, on: :collection
      end
    end
  end

  root 'home#index'
  get 'random-graph', to: 'home#new_graph'
end
