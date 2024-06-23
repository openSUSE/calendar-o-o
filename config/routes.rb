# frozen_string_literal: true

Rails.application.routes.draw do
  resources :teams, param: :slug do
    resources :teams_users, only: %i[show create edit update destroy]

    resources :events, only: %i[show new create edit update destroy], param: :slug do
      resources :event_occurrences, only: %i[destroy]
      resources :schedule_recurrences, only: %i[create]
      resources :schedule_occurrences, only: %i[create]
      resources :alarms, only: %i[index new create edit update destroy]
    end
  end

  resources :main, only: %i[index]
  resources :users, only: %i[index update], param: :username

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'main#index'
end
