json.array!(@snapshots) do |snapshot|
  json.extract! snapshot, :id, :URL, :like_count, :unlike_count, :flag_count, :user_id

  json.photo_large snapshot.photo.large.url
  json.photo_medium snapshot.photo.medium.url
  json.photo_thumb snapshot.photo.thumb.url
  json.photo_small snapshot.photo.small.url

  json.video_url snapshot.video.url

  json.url snapshot_url(snapshot, format: :json)
end
