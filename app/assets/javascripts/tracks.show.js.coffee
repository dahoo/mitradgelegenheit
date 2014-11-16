# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

drawTrack = (map, json) ->
  startMarker = L.AwesomeMarkers.icon({
    icon: 'bicycle',
    markerColor: 'green'
  })
  endMarker = L.AwesomeMarkers.icon({
    icon: 'flag-checkered',
    markerColor: 'red'
  })
  #map.setView(json.center, 12)
  len = json.points_list.length
  if len > 1
    line = L.polyline(json.points_list, {color: 'red'}).addTo(map)
    for start in json.starts
      L.marker([start.latitude, start.longitude], {icon: startMarker, title: start.description}).addTo(map)
    for end in json.ends
      L.marker([end.latitude, end.longitude], {icon: endMarker, title: end.description}).addTo(map)
  map.fitBounds(line.getBounds())

$(document).ready ->
  if($('#map-show-track').length > 0)
    map = L.map('map-show-track').setView([52.517, 13.364], 12)
    L.tileLayer('http://{s}.tiles.mapbox.com/v3/dahoo.k3dh2bke/{z}/{x}/{y}.png',->
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18
    ).addTo(map)

    id = $('#track-id').text()

    $.get("/tracks/#{id}.json").done (json) ->
      drawTrack(map, json)