json.array!(@tracks) do |track|
  if @geo_json
      json.merge! track.decorate.to_geo_json
  else
    json.extract! track, :id, :name, :distance, :time, :category, :points_list, :starts, :ends, :color, :description
    json.occurences_7_days track.next_occurences_in_days(7)
    json.url track_url(track, format: :json)
  end
end
