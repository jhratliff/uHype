json.extract! @snapshot, :id, :URL, :like_count, :unlike_count, :flag_count, :user_id, :created_at, :updated_at

json.liked @snapshot.snapshot_likers.include?(@user)
json.unliked @snapshot.snapshot_unlikers.include?(@user)
json.flagged @snapshot.snapshot_flaggers.include?(@user)

json.photo @snapshot.photo.url unless @snapshot.photo.nil?
json.photo_large @snapshot.photo.large.url unless @snapshot.photo.nil?
json.photo_medium @snapshot.photo.medium.url unless @snapshot.photo.nil?
json.photo_thumb @snapshot.photo.thumb.url unless @snapshot.photo.nil?
json.photo_small @snapshot.photo.small.url unless @snapshot.photo.nil?

json.video @snapshot.video.url unless @snapshot.video.nil?