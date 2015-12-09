drawTracks = (json, fit) ->
  fit = if typeof fit != 'undefined' then fit else true

  startMarker = L.AwesomeMarkers.icon({
    icon: 'bicycle',
    markerColor: 'green'
  })
  endMarker = L.AwesomeMarkers.icon({
    icon: 'flag-checkered',
    markerColor: 'red'
  })

  window.global_layer = L.featureGroup() if not window.global_layer
  for track in json
    len = track.points_list.length
    layer_arr = []
    if len > 1
      layer_arr.push L.polyline(track.points_list, {color: track.color})
      for start in track.starts
        layer_arr.push L.marker([start.latitude, start.longitude], {icon: startMarker, title: start.description})
      for end in track.ends
        layer_arr.push L.marker([end.latitude, end.longitude], {icon: endMarker, title: end.description})

    link = $("<div data-url='tracks/#{track.id}'>").html(
      "<div class='lead'>#{track.name}</div><p>#{shorten(track.description, 150)}</p><a class='btn btn-primary btn-xs btn-block' href='tracks/#{track.id}'>Details</a>").click(->
      location.href = $(this).data('url')
      )[0]

    window.global_layer.addLayer (L.featureGroup(layer_arr)
      .bindPopup(link)
      )

    L.featureGroup(layer_arr).on
      mouseover: highlightTrack,
      mouseout: resetHighlight,

  window.global_layer.addTo(window.map)
  window.map.fitBounds(global_layer.getBounds(), {padding: [0, 20]}) if fit

shorten = (text, maxLength) ->
  ret = text
  if ret.length > maxLength
    ret = ret.substr(0, maxLength - 3) + '&hellip;'
  ret

highlightTrack = (e) ->
  layer = e.target

  layer.setStyle
    opacity: 1,
    weight: 7

resetHighlight = (e) ->
  layer = e.target

  layer.setStyle
    opacity: 0.5,
    weight: 5

filterTracks = (name, category, date_field) ->
  if date_field
    date = moment().startOf('day')
    range = false
    switch date_field
      when 'tomorrow'
        date.add(1, 'd')
      when 'day_after_tomorrow'
        date.add(2, 'd')
      when 'next_week'
        range = true
        date.add(6, 'd')

  tracks = window.json.filter (entry) ->
    date_matched = true
    if date
      date_matched = !!(entry.occurences_7_days.filter (occurence) ->
        if range
          date.isAfter(moment(occurence), 'day')
        else
          date.isSame(moment(occurence), 'day')
        ).length
    (name == '' or entry.name.toLowerCase().indexOf(name.toLowerCase()) > -1) and
    (category == '' or entry.category == category) and
    date_matched

  window.global_layer.clearLayers()
  drawTracks(tracks, false)

resetFilter = ->
  $('#search_query_field').val('')
  $('#category_field').val('')
  $('#date_field').val('')
  window.global_layer.clearLayers()
  drawTracks(window.json)

$(document).ready ->
  if($('#map-all-tracks').length > 0)
    window.map = L.map('map-all-tracks').setView([52.517, 13.364], 12)
    L.tileLayer('https://api.tiles.mapbox.com/v4/dahoo.k3dh2bke/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZGFob28iLCJhIjoiMjktOC1BRSJ9.p1-4SJAU0qBT4jYZHF3sHQ', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18
    }).addTo(window.map)
    window.addLocateTo(window.map)

    new (L.Control.GeoSearch)(
      provider: new (L.GeoSearch.Provider.OpenStreetMap)(viewbox: '13.0882097323,52.3418234221,13.7606105539,52.6697240587')
      enableAutocomplete: true
      autocompleteMinQueryLen: 5
      searchLabel: 'Nach Adresse suchen'
      notFoundMessage: 'Diese Adresse konnte nicht gefunden werden.').addTo window.map

    $.get('/tracks.json?with_points=true').done (json) ->
      window.json = json
      drawTracks(json)

    if Cookies.get 'hideWelcome'
      $('#explanation').hide()
    else
      $('#explanation .close').click ->
        Cookies.set 'hideWelcome', true

    div = L.DomUtil.get('filter')
    if !L.Browser.touch
      L.DomEvent.disableClickPropagation div
      L.DomEvent.on div, 'mousewheel', L.DomEvent.stopPropagation
    else
      L.DomEvent.disableClickPropagation div

    $('#filter_btn').click ->
      filterTracks($('#search_query_field').val(), $('#category_field  ').val(), $('#date_field  ').val())

    $('#filter_reset_btn').click ->
      resetFilter()

    $('#filter-collapse').on 'show.bs.collapse', ->
      $('#filter').find('.panel-heading i').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up')

    $('#filter-collapse').on 'hide.bs.collapse', ->
      $('#filter').find('.panel-heading i').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down')
