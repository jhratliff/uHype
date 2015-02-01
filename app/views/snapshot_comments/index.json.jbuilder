json.array!(@snapshot_comments) do |snapshot_comment|
  json.extract! snapshot_comment, :id
  json.url snapshot_comment_url(snapshot_comment, format: :json)
end
