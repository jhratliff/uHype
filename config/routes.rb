Rails.application.routes.draw do
  resources :snapshots

  resources :comments

  resources :schools

  mount Upmin::Engine => '/admin'

  root to: 'visitors#index'

  get "/users/me" => "users#me"

  get "/schools/:school_id/members" => "schools#members"

  post "/schools/:school_id/follow" => "schools#follow"
  post "/schools/:school_id/unfollow" => "schools#unfollow"

  post "/comments/:comment_id/flag" => "comments#flag"
  post "/comments/:comment_id/unflag" => "comments#unflag"

  post "/comments/:comment_id/like" => "comments#like"
  post "/comments/:comment_id/unlike" => "comments#unlike"

  post "/comments/:comment_id/dislike" => "comments#dislike"
  post "/comments/:comment_id/undislike" => "comments#undislike"

  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}

  resources :users



end
