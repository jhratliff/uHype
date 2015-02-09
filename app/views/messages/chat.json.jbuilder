json.array!(@messages) do |message|
  json.extract! message, :id, :user_id, :recipient_id, :detail, :flag_count, :timer_left, :created_at
  json.url message_url(message, format: :json)
  # json.media_url message.media.url
  json.media_url message.media.medium.url unless message.media.nil?

end
