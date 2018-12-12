Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  ## Authentication
  devise_for :users, only: []
  get    '/users',     to: 'users#index'
  post   '/users',     to: 'users#create'
  post   '/sessions',  to: 'sessions#create'
  delete '/sessions',  to: 'sessions#destroy'
  match  '/passwords', to: 'passwords#update', via: [:put, :patch]


  ## RESTful resources
  resources :airlines,    only: [:index, :show, :create, :update, :destroy]
  resources :airports,    only: [:index, :show, :create, :update, :destroy]
  resources :flights,     only: [:index, :show, :create, :update, :destroy]
  resources :instances,   only: [:index, :show, :create, :update, :destroy]
  resources :itineraries, only: [:index, :show, :create, :update, :destroy]
  resources :planes,      only: [:index, :show, :create, :update, :destroy]
  resources :seats,       only: [:index, :show, :create, :update, :destroy]
  resources :tickets,     only: [:index, :show, :create, :update, :destroy]


  ## Nested resource routes
  #get '/instance/:id/prices', to: 'instances#price_index'
  #get '/instance/:id/seats',  to: 'instances#seat_index'


  ## Clear data route
  delete '/data',             to: 'databases#destroy'

  delete '/data/airlines',    to: 'databases#destroy_airlines'
  delete '/data/airports',    to: 'databases#destroy_airports'
  delete '/data/flights',     to: 'databases#destroy_flights'
  delete '/data/instances',   to: 'databases#destroy_instances'
  delete '/data/itineraries', to: 'databases#destroy_itineraries'
  delete '/data/planes',      to: 'databases#destroy_planes'
  delete '/data/seats',       to: 'databases#destroy_seats'
  delete '/data/tickets',     to: 'databases#destroy_tickets'


  ## Bulk seed route
  post 'data/seed', to: 'seeds#create'


  ## Ember wildcard route
  get '/client/*a', to: redirect('/client')
end
