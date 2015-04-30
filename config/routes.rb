Rails.application.routes.draw do
  get 'dashboard' => 'dashboards#index', as: :dashboard
  get 'home' => 'dashboards#home', as: :home

  get 'login' => 'sessions#new', as: :login
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy', as: :logout

  # oauth
  get 'auth/twitter/callback', to: 'sessions#twitter', as: :twitter_auth
  get 'auth/failure', to: 'sessions#failure'

  resources :users, only: [:new, :create]
  get '/settings' => 'settings#index', as: :settings
  post '/settings' => 'settings#update'
  put '/settings/regenkey' => 'settings#regen_key', as: :regen_key

  resources :links, only: [:create, :show, :redirection, :destroy]

  get '/:id' => 'links#redirection', as: :redirect_url

  # api
  namespace :api do
    namespace :v1 do
      get 'links/create'
      get 'links/:id' => 'links#show'
      get 'users/:id' => 'users#show'
    end
  end

  root 'sessions#direct'
end
