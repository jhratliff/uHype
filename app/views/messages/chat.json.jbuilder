json.array!(@messages) do |message|
  json.extract! message, :id, :user_id, :recipient_id, :detail, :flag_count, :created_at
  json.url message_url(message, format: :json)
  json.media_url message.media.url

end
