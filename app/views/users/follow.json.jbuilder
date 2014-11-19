json.extract! @user, :id, :authentication_token, :email, :first_name, :last_name, :username, :dob, :class_of, :school_id, :created_at, :followed_schools, :updated_at, :is_private

school = School.find(@user.school)

json.high_school_name school.name
json.following_status @following.status