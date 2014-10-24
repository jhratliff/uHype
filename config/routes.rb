Rails.application.routes.draw do
  resources :snapshots

  resources :comments

  resources :schools

  mount Upmin::Engine => '/admin'

  root to: 'visitors#index'

  get "/users/me" => "users#me"

  post "/schools/:school_id/follow" => "schools#follow"
  post "/schools/:school_id/unfollow" => "schools#unfollow"

  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}

  resources :users



end
