map = undefined

getTrack = (evt) ->
  console.log(map.editTools.featuresLayer.getLayers()[0].getLatLngs())
  latLngs = map.editTools.featuresLayer.getLayers()[0].getLatLngs()
  points = (['' + p.lat + ',' + p.lng] for p in latLngs)
  console.log(points)
  $('#track_track').val(points.join(';'))
  $('#track_starts').val(points[0])
  $('#track_ends').val(points[points.length - 1])
  console.log(points)

$(document).ready ->
  map = L.map('map', {editable: true}).setView([52.517, 13.364], 12)
  L.tileLayer('http://{s}.tiles.mapbox.com/v3/dahoo.k3dh2bke/{z}/{x}/{y}.png',->
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18
  ).addTo(map)
  map.editTools.startPolyline();

  $('#new_track').on 'submit', {map: map}, getTrack