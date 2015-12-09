json.array!(@tracks) do |track|
  json.extract! track, :id, :name, :distance, :time, :category, :points_list, :starts, :ends, :color, :description
  json.occurences_7_days track.next_occurences_in_days(7)
  json.url track_url(track, format: :json)
end
