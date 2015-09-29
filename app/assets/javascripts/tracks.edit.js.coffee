$(document).ready ->
  if($('#map-edit-track').length > 0)
    map = undefined
    starts = []
    ends = []
    line = undefined

    drawTrack = (map, json) ->
      startMarker = L.AwesomeMarkers.icon({
        icon: 'bicycle',
        markerColor: 'green'
      })
      endMarker = L.AwesomeMarkers.icon({
        icon: 'flag-checkered',
        markerColor: 'red'
      })

      len = json.points_list.length
      if len > 1
        line = L.polyline(json.points_list, {color: 'red'}).addTo(map)
        for start in json.starts
          marker = L.marker([start.latitude, start.longitude], {icon: startMarker, title: start.description}).addTo(map)
          starts.push marker
          marker.enableEdit()
        for end in json.ends
          marker = L.marker([end.latitude, end.longitude], {icon: endMarker, title: end.description}).addTo(map)
          ends.push marker
          marker.enableEdit()
      map.fitBounds(line.getBounds())
      line.enableEdit()

    getTrack = (evt) ->
      track_point_lat_lngs = line.getLatLngs()
      track_points = (['' + p.lat + ',' + p.lng] for p in track_point_lat_lngs)

      start_lat_lngs = (start.getLatLng() for start in starts)
      end_lat_lngs = (end.getLatLng() for end in ends)

      if track_points
        start_lat_lngs.push track_point_lat_lngs[0] if starts.length == 0
        end_lat_lngs.push track_point_lat_lngs[track_point_lat_lngs.length - 1] if ends.length == 0

        $('#track_points').val(track_points.join(';'))

      for p, i in start_lat_lngs
        $('#starts .track_starts_latitude input').eq(i).val(p.lat)
        $('#starts .track_starts_longitude input').eq(i).val(p.lng)

      for p, i in end_lat_lngs
        $('#ends .track_ends_latitude input').eq(i).val(p.lat)
        $('#ends .track_ends_longitude input').eq(i).val(p.lng)

    addStart = ->
      startMarker = L.AwesomeMarkers.icon({
        icon: 'bicycle',
        markerColor: 'green'
      })
      starts.push map.editTools.startMarker(null, {icon: startMarker})
      addField($('#starts .add_fields'))

    addEnd = ->
      endMarker = L.AwesomeMarkers.icon({
        icon: 'flag-checkered',
        markerColor: 'red'
      })
      ends.push map.editTools.startMarker(null, {icon: endMarker})
      addField($('#ends .add_fields'))

    continueTrack = ->
      track.editor.continueForward()

    map = L.map('map-edit-track', {editable: true}).setView([52.517, 13.364], 12)
    L.tileLayer('https://api.tiles.mapbox.com/v4/dahoo.k3dh2bke/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZGFob28iLCJhIjoiMjktOC1BRSJ9.p1-4SJAU0qBT4jYZHF3sHQ', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18
    }).addTo(map)

    id = $('#track-id').text()

    $.get("/tracks/#{id}.json").done (json) ->
      drawTrack(map, json)

    $("\#edit_track_#{id}").on 'submit', {map: map}, getTrack

    L.easyButton('fa-road',
     continueTrack,
     "Strecke bearbeiten",
     map)
    L.easyButton('fa-flag-o',
     addStart,
     "Start hinzufügen",
     map)
    L.easyButton('fa-flag-checkered',
     addEnd,
     "Ziel hinzufügen",
     map)

    $('#start_times').on 'cocoon:after-insert', (e, insertedItem) ->
      console.log insertedItem
      bind_wday_date_switch(insertedItem)
      $(':checkbox').bootstrapSwitch()
      check_to_hide_or_show_remove_link
    $('#start_times').on 'cocoon:after-remove', check_to_hide_or_show_remove_link

    $('#starts').on 'cocoon:after-insert', (e, insertedItem) ->
      index = $('#starts .nested-fields').index(insertedItem) + 1
      $(insertedItem).find('span#number i').text(index)
      if index == 1
        $('.track_starts_time').hide()

    $('#starts').find('.track_starts_time').first().hide()

    $('#ends').on 'cocoon:after-insert', (e, insertedItem) ->
      index = $('#ends .nested-fields').index(insertedItem) + 1
      $(insertedItem).find('span#number i').text(index)

    for insertedItem in $('#start_times .nested-fields')
      insertedItem = $(insertedItem)
      console.log insertedItem
      bind_wday_date_switch(insertedItem, false)
      $(':checkbox').bootstrapSwitch()
      check_to_hide_or_show_remove_link