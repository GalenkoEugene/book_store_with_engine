# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'home#index'
  resources :books, only: [:show, :index]
  match '/catalog', to: 'books#index', via: 'get'
  match '/home', to: 'home#index', via: 'get'
  devise_for :users,  controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
   }
  resources :users, only: %i[update destroy]
  resources :reviews, only: :create

  match 'settings/privacy', to: 'users#index', via: 'get'
  match 'settings/privacy', to: 'users#update', via: 'put'
end
