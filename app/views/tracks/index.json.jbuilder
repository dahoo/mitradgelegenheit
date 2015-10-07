json.array!(@tracks) do |track|
  json.extract! track, :id, :name, :distance, :time, :category, :points_list, :starts, :ends, :color, :description
  json.url track_url(track, format: :json)
end
