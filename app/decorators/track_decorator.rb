class TrackDecorator < Draper::Decorator
  decorates :track
  delegate_all

  def to_gpx
    gpx = GPX::GPXFile.new
    points = track_points.map do |track_point|
      GPX::Point.new(lat: track_point.latitude,
                     lon: track_point.longitude)
    end
    (starts + ends).each do |way_point|
      gpx.waypoints << GPX::Waypoint.new(name: way_point.description,
                                         lat: way_point.latitude,
                                         lon: way_point.longitude)
    end
    gpx.routes << GPX::Route.new(points: points, name: name)
    gpx.to_s
  end

  def to_geo_json
    track = {
      type: 'Feature',
      properties: {
        name: name,
        description: description,
        color: color,
        weight: 5,
        url: Rails.application.routes.url_helpers.track_url(self)
      },
      geometry: {
        type: 'LineString',
        coordinates: track_points.map do |track_point|
          [track_point.longitude, track_point.latitude]
        end
      }
    }
    way_points = (starts + ends).map do |way_point|
      {
        type: 'Feature',
        properties: {
          description: way_point.description,
          color: way_point.type == 'Start' ? '#72b026' : '#d63e2a'
        },
        geometry: {
          type: 'Point',
          coordinates: [way_point.longitude, way_point.latitude]
        }
      }
    end
    {
      type: 'FeatureCollection',
      features: [track] + way_points
    }
  end
end
