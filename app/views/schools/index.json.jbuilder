json.array!(@schools) do |school|
  json.extract! school, :id, :name, :address, :city, :state, :zip, :maplink, :stype, :grades, :website
  json.url school_url(school, format: :json)
end
