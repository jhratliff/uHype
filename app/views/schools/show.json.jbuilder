json.extract! @school, :id, :name, :address, :city, :state, :zip, :maplink, :stype, :grades, :website, :created_at, :updated_at
json.logo_large @school.logo.large.url
json.logo_medium @school.logo.medium.url
json.logo_thumb @school.logo.thumb.url
json.logo_small @school.logo.small.url
json.comments @school.comments do |json, comment |

  json.(:id, :detail, :flag_count, :like_count, :unlike_count, :created_at)
  user = User.find(comment.user)

  json.user_id  user.id
  json.first_name user.first_name
  json.last_name user.last_name
  json.username :username
  school = School.find(user.school)
  json.user_hs_name school.name
  end