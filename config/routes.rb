Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  # Authentication
  devise_for :users, only: []
  resources  :sessions, only: [:create, :destroy]


  # RESTful resources
  resources :airlines,    only: [:index, :show, :create, :update, :destroy]
  resources :airports,    only: [:index, :show, :create, :update, :destroy]
  resources :flights,     only: [:index, :show, :create, :update, :destroy]
  resources :instances,   only: [:index, :show, :create, :update, :destroy]
  resources :itineraries, only: [:index, :show, :create, :update, :destroy]
  resources :planes,      only: [:index, :show, :create, :update, :destroy]
  resources :seats,       only: [:index, :show, :create, :update, :destroy]
  resources :tickets,     only: [:index, :show, :create, :update, :destroy]
end
