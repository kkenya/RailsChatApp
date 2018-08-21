Rails.application.routes.draw do
  root 'rooms#index'
  get 'chat_messages/index'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, only: [:index, :show, :update, :edit, :destroy]
  resources :rooms
end
