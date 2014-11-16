map = undefined
starts = []
ends = []

L.NewStartControl = L.Control.extend(
  options:
    position: "topleft"

  onAdd: (map) ->
    container = L.DomUtil.create("div", "leaflet-control leaflet-bar")
    link = L.DomUtil.create("a", "", container)
    link.href = "#"
    link.title = 'Neuen Startpunkt hinzufügen'
    link.innerHTML = 'S'
    L.DomEvent.on(link, "click", L.DomEvent.stop).on link, "click", ->
      addStart()
      return

    container
)

L.NewEndControl = L.Control.extend(
  options:
    position: "topleft"

  onAdd: (map) ->
    container = L.DomUtil.create("div", "leaflet-control leaflet-bar")
    link = L.DomUtil.create("a", "", container)
    link.href = "#"
    link.title = 'Neuen Endpunkt hinzufügen'
    link.innerHTML = 'E'
    L.DomEvent.on(link, "click", L.DomEvent.stop).on link, "click", ->
      addEnd()
      return

    container
)

addStart = ->
  startMarker = L.AwesomeMarkers.icon({
    icon: 'bicycle',
    markerColor: 'green'
  })
  starts.push map.editTools.startMarker(null, {icon: startMarker});
  console.log starts

addEnd = ->
  endMarker = L.AwesomeMarkers.icon({
    icon: 'flag-checkered',
    markerColor: 'red'
  })
  ends.push map.editTools.startMarker(null, {icon: endMarker});
  console.log ends

getTrack = (evt) ->
  track_latLngs = map.editTools.featuresLayer.getLayers()[0].getLatLngs()
  track_points = (['' + p.lat + ',' + p.lng] for p in track_latLngs)

  start_points = (['' + p.lat + ',' + p.lng] for p in (start.getLatLng() for start in starts))
  end_points = (['' + p.lat + ',' + p.lng] for p in (end.getLatLng() for end in ends))

  if track_points
    start_points = track_points[0] if starts.length == 0
    end_points = track_points[track_points.length - 1] if ends.length == 0

    $('#track_track').val(track_points.join(';'))
    $('#track_starts').val(start_points.join(';'))
    $('#track_ends').val(end_points.join(';'))

$(document).ready ->
  if($('#map-create-track').length > 0)
    map = L.map('map-create-track', {editable: true}).setView([52.517, 13.364], 12)
    L.tileLayer('http://{s}.tiles.mapbox.com/v3/dahoo.k3dh2bke/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18
    }).addTo(map)
    map.editTools.startPolyline(null, {color: 'red'});
    map.addControl(new L.NewStartControl());
    map.addControl(new L.NewEndControl());

    $('#new_track').on 'submit', {map: map}, getTrack