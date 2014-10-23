json.array!(@comments) do |comment|
  json.extract! comment, :id, :user_id, :school_id, :detail, :flag_count, :like_count, :unlike_count
  json.url comment_url(comment, format: :json)
end
