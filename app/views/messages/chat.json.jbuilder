json.array!(@messages) do |message|
  json.extract! message, :id, :user_id, :recipient_id, :detail, :flagged_count, :created_at
  json.url message_url(message, format: :json)
end
