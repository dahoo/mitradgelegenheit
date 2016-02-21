### globals L, CocoonHelper ###

class @TrackEditor
  constructor: (@map, track) ->
    @starts = []
    @ends = []
    @cocoon = new CocoonHelper()

    if track != undefined
      @drawTrack(track)
    else
      console.log @map
      @track = @map.editTools.startPolyline(null, {color: 'red'})

  addStart: (data, index) =>
    startMarker = L.AwesomeMarkers.icon({
      text: (if index != undefined then String(index + 1) else
        String(@getFieldsIndex('#starts', @starts)))
      markerColor: 'green'
    } )
    if data
      start = L.marker([data.latitude, data.longitude],
        icon: startMarker,
        title: data.description
      ).addTo(@map)
      start.enableEdit()
    else
      start = @map.editTools.startMarker(null, {icon: startMarker} )
    @starts.push start

    if @starts.length > 1 and not data
      @cocoon.addField($('#starts .add_fields'))
      field = $('#starts .nested-fields').last()
    else
      field = $('#starts .nested-fields')[index]
    $(field).data('leaflet_id', start._leaflet_id)

  addEnd: (data, index) =>
    endMarker = L.AwesomeMarkers.icon({
      text: (if index != undefined then String(index + 1) else
        String(@getFieldsIndex('#ends', @ends)))
      markerColor: 'red'
    } )
    if data
      end = L.marker([data.latitude, data.longitude],
        icon: endMarker,
        title: data.description
      ).addTo(@map)
      end.enableEdit()
    else
      end = @map.editTools.startMarker(null, {icon: endMarker} )
    @ends.push end

    if @ends.length > 1 and not data
      @cocoon.addField($('#ends .add_fields'))
      field = $('#ends .nested-fields').last()
    else
      field = $('#ends .nested-fields')[index]
    $(field).data('leaflet_id', end._leaflet_id)

  continueTrack: =>
    @track.editor.continueForward()

  getFieldsIndex: (id, markers) ->
    fields = $("#{id} .nested-fields")
    if fields.length > 1
      index = $(fields.get( - 1)).find('span#number i').text()
      if index == ""
        index = $(fields.get( - 2)).find('span#number i').text()
      index = parseInt(index) + 1
    else
      index = markers.length + 1
    index

  addButtons: =>
    L.easyButton('fa-road',
     @continueTrack,
     "Strecke bearbeiten",
     @map)
    L.easyButton('fa-flag-o',
     @addStart,
     "Start hinzufügen",
     @map)
    L.easyButton('fa-flag-checkered',
     @addEnd,
     "Ziel hinzufügen",
     @map)

  setCocoonCallbacks: =>
    $('#starts').on 'cocoon:after-insert', (e, insertedItem) =>
      index = @getFieldsIndex('#starts', @starts)
      $(insertedItem).find('span#number i').text(index)
      if index == 1
        $('.track_starts_time').hide()

    $('#starts').on 'cocoon:before-remove', (e, deletedItem) =>
      start = @starts.find (start) ->
        start._leaflet_id == deletedItem.data('leaflet_id')
      @map.removeLayer(start)
      @starts.splice(@starts.indexOf(start), 1)

    $('#ends').on 'cocoon:after-insert', (e, insertedItem) =>
      index = @getFieldsIndex('#ends', @ends)
      $(insertedItem).find('span#number i').text(index)

    $('#ends').on 'cocoon:before-remove', (e, deletedItem) =>
      end = @ends.find (end) ->
        end._leaflet_id == deletedItem.data('leaflet_id')
      @map.removeLayer(end)
      @ends.splice(@starts.indexOf(end), 1)

  drawTrack: (json) =>
    if json.points_list.length > 1
      @track = L.polyline(json.points_list, {color: 'red'}).addTo(@map)
      for start, index in json.starts
        @addStart(start, index)
      for end, index in json.ends
        @addEnd(end, index)
    @map.fitBounds(@track.getBounds())
    @track.enableEdit()

  getTrack: =>
    track_point_lat_lngs = @track.getLatLngs()
    track_points = (['' + p.lat + ',' + p.lng] for p in track_point_lat_lngs)

    start_lat_lngs = (start.getLatLng() for start in @starts)
    end_lat_lngs = (end.getLatLng() for end in @ends)

    if track_points
      start_lat_lngs.push track_point_lat_lngs[0] if @starts.length == 0
      if @ends.length == 0
        end_lat_lngs.push(
          track_point_lat_lngs[track_point_lat_lngs.length - 1])

      $('#track_points').val(track_points.join(';'))

    for p, i in start_lat_lngs
      $('#starts .track_starts_latitude input').eq(i).val(p.lat)
      $('#starts .track_starts_longitude input').eq(i).val(p.lng)

    for p, i in end_lat_lngs
      $('#ends .track_ends_latitude input').eq(i).val(p.lat)
      $('#ends .track_ends_longitude input').eq(i).val(p.lng)
