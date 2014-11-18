json.array!(@followings) do |following|
  json.extract! following, :id
  json.url following_url(following, format: :json)
end
