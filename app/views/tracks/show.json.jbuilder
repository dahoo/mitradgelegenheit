json.extract! @track, :id, :name, :distance, :time, :created_at, :updated_at, :points_list, :starts, :ends, :color, :description
json.occurences_7_days @track.next_occurences_in_days(7)
