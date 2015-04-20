Rails.application.routes.draw do

  resources :snapshot_comments

  mount Upmin::Engine => '/admin'

  root to: 'visitors#index'

  post "/users/me" => "users#me"
  get "/users/feed" => "users#feed"
  get "/users/:user_id/friends" => "users#friends"
  get "/users/friends" => "users#friends"
  get "/users/:user_id/followers" => "users#followers"
  get "/users/followers" => "users#followers"
  get "/users/media" => "users#media"
  get "/users/:user_id/media" => "users#media"
  get "/friend/:friend_id" => "users#friend"
  post "/users/:user_id/follow" => "users#follow"
  post "/users/:user_id/unfollow" => "users#unfollow"
  post "/users/near_me" => "users#near_me"
  post "/users/register_notifications" => "users#register_notifications"
  post "/users/unregister_notifications" => "users#unregister_notifications"
  post "/users/reset_password" => "users#reset_password"


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

  post "/snapshots/:snapshot_id/flag" => "snapshots#flag"
  post "/snapshots/:snapshot_id/unflag" => "snapshots#unflag"

  post "/snapshots/:snapshot_id/like" => "snapshots#like"
  post "/snapshots/:snapshot_id/unlike" => "snapshots#unlike"

  post "/snapshots/:snapshot_id/dislike" => "snapshots#dislike"
  post "/snapshots/:snapshot_id/undislike" => "snapshots#undislike"

  get "/snapshots/:snapshot_id/feed" => "snapshots#feed"

  get "/messages/:recipient_id/chat" => "messages#chat"
  post "/messages/:id/time" => "messages#viewed_time"


  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}

  resources :users
  resources :snapshots
  resources :comments
  resources :schools
  resources :messages
  resources :followings


end
