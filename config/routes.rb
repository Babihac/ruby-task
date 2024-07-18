# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get 'up' => 'rails/health#show', as: :rails_health_check
    root 'projects#index'

    resources :projects, only: %i[index create new destroy]
    resources :tags, only: %i[index create new destroy]
    # Defines the root path route ("/")
    # root "posts#index"
  end
end
