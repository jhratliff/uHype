json.extract! @user, :id, :first_name, :last_name, :class_of, :username, :created_at

json.avatar_large @user.avatar.large.url
json.avatar_medium @user.avatar.medium.url
json.avatar_thumb @user.avatar.thumb.url
json.avatar_small @user.avatar.small.url

json.friends @user.friends.order(id: :desc) do | friend |

  json.id friend.id
  json.first_name friend.first_name
  json.last_name friend.last_name
  json.class_of friend.class_of
  json.username friend.username
  json.created_at friend.created_at
  json.followers friend.followers.count
  json.school_id friend.school_id
  school = School.find(friend.school)
  json.user_hs_name school.name
end