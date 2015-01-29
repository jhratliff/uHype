Rails.application.routes.draw do

  mount Upmin::Engine => '/admin'

  root to: 'visitors#index'

  get "/users/me" => "users#me"
  get "/users/feed" => "users#feed"
  get "/users/friends" => "users#friends"
  get "/users/followers" => "users#followers"
  get "/users/media" => "users#media"
  get "/users/:user_id/media" => "users#media"
  get "/friend/:friend_id" => "users#friend"
  post "/users/:user_id/follow" => "users#follow"
  post "/users/:user_id/unfollow" => "users#unfollow"
  post "/followings/approve/:user_id" => "followings#approve"
  post "/followings/decline/:user_id" => "followings#decline"

  get "/schools/:school_id/members" => "schools#members"

  post "/schools/:school_id/follow" => "schools#follow"
  post "/schools/:school_id/unfollow" => "schools#unfollow"

  post "/comments/:comment_id/flag" => "comments#flag"
  post "/comments/:comment_id/unflag" => "comments#unflag"

  post "/comments/:comment_id/like" => "comments#like"
  post "/comments/:comment_id/unlike" => "comments#unlike"

  post "/comments/:comment_id/dislike" => "comments#dislike"
  post "/comments/:comment_id/undislike" => "comments#undislike"

  get "/messages/:recipient_id/chat" => "messages#chat"


  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}

  resources :users
  resources :snapshots
  resources :comments
  resources :schools
  resources :messages
  resources :followings


end
