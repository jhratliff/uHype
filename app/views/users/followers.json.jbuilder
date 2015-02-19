json.extract! @response[:user], :id, :first_name, :last_name, :class_of, :username, :created_at

json.avatar_large @response[:user].avatar.large.url
json.avatar_medium @response[:user].avatar.medium.url
json.avatar_thumb @response[:user].avatar.thumb.url
json.avatar_small @response[:user].avatar.small.url

json.followers @response[:user].followers.order(id: :desc) do | follower |

  json.id follower.id
  json.unseen_chats_count friend.unseen_chats_count(@response[:user].id)
  json.first_name follower.first_name
  json.last_name follower.last_name
  json.class_of follower.class_of
  json.username follower.username
  json.created_at follower.created_at
  json.followers follower.followers.count
  json.school_id follower.school_id
  json.is_private follower.is_private
  json.is_location_private follower.is_location_private
  json.latitude follower.latitude
  json.longitude follower.longitude
  school = School.find(follower.school)
  json.user_hs_name school.name

  following = follower.followings.where(:followed => @response[:current_user]).last

  # if I'm following this user, get the status (requested, approved, denied)
  following_status = following.status unless following.nil?
  json.following_status following_status

  json.avatar_large follower.avatar.large.url
  json.avatar_medium follower.avatar.medium.url
  json.avatar_thumb follower.avatar.thumb.url
  json.avatar_small follower.avatar.small.url

end