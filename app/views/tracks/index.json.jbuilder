json.array!(@tracks) do |track|
  json.extract! track, :id, :name, :distance, :time, :points_list, :starts, :ends, :color
  json.url track_url(track, format: :json)
end
