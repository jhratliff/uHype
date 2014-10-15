Rails.application.routes.draw do
  resources :schools

  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users, :controllers => {sessions: 'sessions'}
  resources :users
end
