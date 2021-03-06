json.array!(@comments) do |comment|
  json.extract! comment, :id, :user_id, :school_id, :detail, :flag_count, :like_count, :unlike_count, :created_at

  json.liked comment.comment_likers.include?(@user)
  json.unliked comment.comment_unlikers.include?(@user)
  json.flagged comment.comment_flaggers.include?(@user)

  user = User.find(comment.user)
  json.user_id user.id
  json.user_first_name user.first_name
  json.user_last_name user.last_name
  json.user_username user.username
  json.user_text_year user.year_text
  json.user_avatar user.avatar.medium.url unless user.avatar.nil?

  school = School.find(comment.school)

  json.school_name school.name
  json.school_logo school.logo.medium.url unless school.logo.nil?

  json.url comment_url(comment, format: :json)
end
