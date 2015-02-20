json.extract! @snapshot, :id, :URL, :like_count, :unlike_count, :flag_count, :user_id, :created_at, :updated_at


json.liked @snapshot.snapshot_likers.include?(@user)
json.unliked @snapshot.snapshot_unlikers.include?(@user)
json.flagged @snapshot.snapshot_flaggers.include?(@user)




json.photo @snapshot.photo.url
json.photo_large @snapshot.photo.large.url
json.photo_medium @snapshot.photo.medium.url
json.photo_thumb @snapshot.photo.thumb.url
json.photo_small @snapshot.photo.small.url

json.video @snapshot.video.url