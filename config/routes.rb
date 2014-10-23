Rails.application.routes.draw do
  resources :comments

  resources :schools

  mount Upmin::Engine => '/admin'

  root to: 'visitors#index'

  get "/users/me" => "users#me"
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}

  resources :users



end
