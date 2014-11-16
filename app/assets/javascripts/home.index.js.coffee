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
  global_layer = L.featureGroup()
  for track in json
    len = track.points_list.length
    layer_arr = []
    if len > 1
      layer_arr.push L.polyline(track.points_list, {color: 'red'})
      for start in track.starts
        layer_arr.push L.marker([start.latitude, start.longitude], {icon: startMarker, title: start.description})
      for end in track.ends
        layer_arr.push L.marker([end.latitude, end.longitude], {icon: endMarker, title: end.description})

    link = $("<div data-url='tracks/#{track.id}'>").html("#{track.name}</br><a hfref='tracks/#{track.id}'>Details >></a>").click(->
      location.href = $(this).data('url')
      )[0]
    global_layer.addLayer (L.featureGroup(layer_arr)
      .bindPopup(link)
      #.on('click', ->
      #  alert('Clicked on a group!'))
      .addTo(map))

  map.fitBounds(global_layer.getBounds(), {padding: [0, 20]})

$(document).ready ->
  if($('#map-all-tracks').length > 0)
    map = L.map('map-all-tracks').setView([52.517, 13.364], 12)
    L.tileLayer('http://{s}.tiles.mapbox.com/v3/dahoo.k3dh2bke/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18
    }).addTo(map)

    $.get('/tracks.json?with_points=true').done (json) ->
      drawTracks(map, json)