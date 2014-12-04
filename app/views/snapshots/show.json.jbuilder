json.extract! @snapshot, :id, :URL, :like_count, :unlike_count, :flag_count, :user_id, :created_at, :updated_at

json.photo @snapshot.photo.url
json.photo_large @snapshot.photo.large.url
json.photo_medium @snapshot.photo.medium.url
json.photo_thumb @snapshot.photo.thumb.url
json.photo_small @snapshot.photo.small.url


