# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    resources :graphs, only: %i[index create show update destroy] do
      post :validate, on: :member
      post :reserve, on: :member
      resources :nodes, only: %i[index create show update destroy]
      resources :edges, only: %i[index create show update destroy]
      resources :members, only: %i[index show create update destroy] do
        delete :unsubscribe, on: :collection
      end
    end
  end
  resources :graphs, only: %i[show]
  root 'home#index'
  get 'new_graph', to: 'home#new_graph'
  get 'test-graph', to: 'home#test_graph'
  get 'editor/:id', to: 'home#editor'
  get 'player', to: 'home#player'
  get 'graphList', to:'home#graphList'

end
