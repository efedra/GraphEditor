# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :graphs, :nodes, :edges, only: %i[index create show update destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root 'home#index'
end
