json.array!(@snapshots) do |snapshot|
  json.extract! snapshot, :id, :URL, :like_count, :unlike_count, :flag_count, :user_id
  json.url snapshot_url(snapshot, format: :json)
end
