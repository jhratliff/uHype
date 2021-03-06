@user = current_user
json.extract! @school, :id, :name, :address, :city, :state, :zip, :maplink, :stype, :grades, :website, :created_at, :updated_at
json.logo_large @school.logo.large.url
json.logo_medium @school.logo.medium.url
json.logo_thumb @school.logo.thumb.url
json.logo_small @school.logo.small.url
json.comments @school.comments.order(id: :desc) do |comment |

  json.id comment.id
  json.detail comment.detail
  json.flag_count comment.flag_count
  json.like_count comment.like_count
  json.unlike_count comment.unlike_count
  json.created_at comment.created_at

  json.liked comment.comment_likers.include?(@user)
  json.unliked comment.comment_unlikers.include?(@user)
  json.flagged comment.comment_flaggers.include?(@user)

  user = User.find(comment.user)

  json.user_id  user.id
  json.first_name user.first_name
  json.last_name user.last_name
  json.username user.username
  school = School.find(user.school)
  json.user_hs_name school.name
  json.user_school_logo school.logo.medium.url unless school.logo.nil?
  end