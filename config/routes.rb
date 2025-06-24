Rails.application.routes.draw do
  get 'actors/index'
  get 'actors/new'
  get 'actors/create'
  get 'actors/edit'
  get 'actors/update'
  get 'actors/destroy'
  get 'series_collection/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root to: redirect('/music')  # Redirect root to music collection
  get 'music', to: 'music#index'  # Music collection home
  get 'series_collection', to: 'series_collection#index' # Series collection home
  get 'tv_shows', to: redirect('/series_collection')
  resources :series do
    member do
      patch :snooze
      patch :unsnooze
    end
  end
  resources :actors
  
  resources :genres
  resources :authors
  resources :albums
  resources :countries

  # Get Lucky functionality - direct access to random recommendations
  get 'get_lucky', to: 'home#get_lucky'

  namespace :api do
    get 'musicbrainz/search'
    get 'musicbrainz/release/:id', to: 'musicbrainz#release'
    get 'musicbrainz/cover/:id', to: 'musicbrainz#cover'
    get 'imdb/search'
    get 'imdb/details/:id', to: 'imdb#details'
    get 'imdb/poster/:id', to: 'imdb#poster'
    get 'imdb/poster_proxy', to: 'imdb#poster_proxy'
    get 'authors', to: 'authors#index'
    get 'recommendations/by_genre/random', to: 'recommendations#by_genre', defaults: { id: 'random' }
    get 'recommendations/by_genre/:id', to: 'recommendations#by_genre'
    resources :albums, only: [] do
      post 'rate', to: 'ratings#create'
    end
  end

  resources :albums do
    collection do
      get 'search_info'
    end
  end

  get 'statistics', to: 'statistics#index'
end
