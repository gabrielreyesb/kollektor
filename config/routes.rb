Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root 'home#index'  # or whatever your root controller/action is
  resources :genres
  resources :authors
  resources :albums
  resources :countries

  namespace :api do
    get 'musicbrainz/search'
    get 'musicbrainz/release/:id', to: 'musicbrainz#release'
    get 'musicbrainz/cover/:id', to: 'musicbrainz#cover'
    get 'authors', to: 'authors#index'
    get 'recommendations/by_genre/random', to: 'recommendations#by_genre', defaults: { id: 'random' }
    get 'recommendations/by_genre/:id', to: 'recommendations#by_genre'
  end

  resources :albums do
    collection do
      get 'search_info'
    end
  end

  get 'statistics', to: 'statistics#index'
end
