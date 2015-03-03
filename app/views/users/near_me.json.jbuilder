json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :username, :class_of, :year_text, :is_private, :is_location_private, :latitude, :longitude

  json.avatar user.avatar.medium.url unless user.avatar.nil?
  json.followers user.followers.count

  if user.school_id
    school = School.find(user.school_id)
    json.school_name school.name
  else
    json.school_name "Not Selected"
  end
end
