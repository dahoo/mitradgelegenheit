# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

drawTracks = (map, json) ->
  startMarker = L.AwesomeMarkers.icon({
    icon: 'bicycle',
    markerColor: 'green'
  })
  endMarker = L.AwesomeMarkers.icon({
    icon: 'flag-checkered',
    markerColor: 'red'
  })
  for track in json
    len = track.points_list.length
    if len > 1
      L.polyline(track.points_list, {color: 'red'}).addTo(map)
      for start in track.starts
        L.marker([start.latitude, start.longitude], {icon: startMarker, title: start.description}).addTo(map)
      for end in track.ends
        L.marker([end.latitude, end.longitude], {icon: endMarker, title: end.description}).addTo(map)

$(document).ready ->
  if($('#map-all-tracks').length > 0)
    map = L.map('map-all-tracks').setView([52.517, 13.364], 12)
    L.tileLayer('http://{s}.tiles.mapbox.com/v3/dahoo.k3dh2bke/{z}/{x}/{y}.png',->
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18
    ).addTo(map)

    $.get('/tracks.json?with_points=true').done (json) ->
      drawTracks(map, json)