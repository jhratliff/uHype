json.array!(@schools) do |school|
  json.extract! school, :id, :name, :address, :city, :state, :zip, :maplink, :stype, :grades, :website
  json.url school_url(school, format: :json)
  json.logo_large school.logo.large.url
  json.logo_medium school.logo.medium.url
  json.logo_thumb school.logo.thumb.url
  json.logo_small school.logo.small.url
end
