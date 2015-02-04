json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :username, :class_of, :is_private, :is_location_private, :latitude, :longitude

  json.avatar user.avatar.medium.url unless user.avatar.nil?
  json.followers user.followers.count

  school = School.find(user.school)
  json.school_name school.name

end
