# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :graphs, only: %i[index create show update destroy] do
      resources :nodes, only: %i[index create show update destroy]
      resources :edges, only: %i[index create show update destroy]
      end
    end

  root 'home#index'
end
