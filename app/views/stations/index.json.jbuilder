json.array!(@stations) do |station|
  json.extract! station, :id, :name, :connection_id
  json.url station_url(station, format: :json)
end
