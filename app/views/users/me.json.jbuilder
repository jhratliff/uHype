json.extract! @user, :id, :authentication_token, :email, :first_name, :last_name, :username, :dob, :class_of, :school_id, :created_at, :updated_at

school = School.find(@user.school)

json.high_school_name school.name

