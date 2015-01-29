json.extract! @response.user, :id, :first_name, :last_name, :class_of, :username, :created_at

json.avatar_large @response.user.avatar.large.url
json.avatar_medium @response.user.avatar.medium.url
json.avatar_thumb @response.user.avatar.thumb.url
json.avatar_small @response.user.avatar.small.url

json.friends @response.user.friends.order(id: :desc) do | friend |

  json.id friend.id
  json.first_name friend.first_name
  json.last_name friend.last_name
  json.class_of friend.class_of
  json.username friend.username
  json.created_at friend.created_at
  json.followers friend.followers.count
  json.school_id friend.school_id
  json.is_private friend.is_private
  json.is_location_private friend.is_location_private
  json.latitude friend.latitude
  json.longitude friend.longitude
  school = School.find(friend.school)
  json.user_hs_name school.name
  followed = friend.followeds.where(:user => @response.current_user).last

  following_status = followed.status unless followed.nil?
  json.following_status following_status

  json.avatar_large friend.avatar.large.url
  json.avatar_medium friend.avatar.medium.url
  json.avatar_thumb friend.avatar.thumb.url
  json.avatar_small friend.avatar.small.url

end