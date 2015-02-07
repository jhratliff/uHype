json.extract! @user, :id, :authentication_token, :email, :first_name, :last_name, :username, :dob, :class_of, :school_id, :created_at, :followed_schools, :updated_at, :is_private, :is_location_private, :longitude, :latitude, :push_token, :status_code

json.avatar_large @user.avatar.large.url unless @user.avatar.nil?
json.avatar_medium @user.avatar.medium.url unless @user.avatar.nil?
json.avatar_thumb @user.avatar.thumb.url unless @user.avatar.nil?
json.avatar_small @user.avatar.small.url unless @user.avatar.nil?
json.follower_count @user.followers.count

school = School.find(@user.school)

json.high_school_name school.name
