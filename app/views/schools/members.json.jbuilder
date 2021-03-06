@user = current_user
json.extract! @school, :id, :name, :address, :city, :state, :zip, :maplink, :stype, :grades, :website, :created_at, :updated_at
json.logo_large @school.logo.large.url
json.logo_medium @school.logo.medium.url
json.logo_thumb @school.logo.thumb.url
json.logo_small @school.logo.small.url
json.users @school.users.order(id: :desc) do |user |

  json.id user.id
  json.first_name user.first_name
  json.last_name user.last_name
  json.username user.username
  json.created_at user.created_at
  json.follower_count user.followers.count
  json.class_of user.class_of
  json.is_private user.is_private

  json.following user.followers.include?(@user)

  json.avatar_large user.avatar.large.url
  json.avatar_medium user.avatar.medium.url
  json.avatar_thumb user.avatar.thumb.url
  json.avatar_small user.avatar.small.url

  followed = user.followeds.where(:user => @user).last

  following_status = followed.status unless followed.nil?

  json.following_status following_status
end