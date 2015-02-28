map = undefined
track = undefined
starts = []
ends = []

L.EditTrackControl = L.Control.extend(
  options:
    position: "topleft"

  onAdd: (map) ->
    container = L.DomUtil.create("div", "leaflet-control leaflet-bar")
    link = L.DomUtil.create("a", "text-control", container)
    link.href = "#"
    link.title = 'Strecke bearbeiten'
    link.innerHTML = 'Strecke'
    L.DomEvent.on(link, "click", L.DomEvent.stop).on link, "click", ->
      track.editor.continueForward()
      return

    container
)

L.NewStartControl = L.Control.extend(
  options:
    position: "topleft"

  onAdd: (map) ->
    container = L.DomUtil.create("div", "leaflet-control leaflet-bar")
    link = L.DomUtil.create("a", "", container)
    link.href = "#"
    link.title = 'Neuen Startpunkt hinzufügen'
    link.innerHTML = 'Start'
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
    link.innerHTML = 'Ende'
    L.DomEvent.on(link, "click", L.DomEvent.stop).on link, "click", ->
      addEnd()
      return

    container
)

addField = ($this) ->
  assoc = $this.data('association')
  assocs = $this.data('associations')
  content = $this.data('association-insertion-template')
  insertionMethod = $this.data('association-insertion-method') or $this.data('association-insertion-position') or 'before'
  insertionNode = $this.data('association-insertion-node')
  insertionTraversal = $this.data('association-insertion-traversal')
  count = parseInt($this.data('count'), 10)
  regexp_braced = new RegExp('\\[new_' + assoc + '\\](.*?\\s)', 'g')
  regexp_underscord = new RegExp('_new_' + assoc + '_(\\w*)', 'g')
  new_id = create_new_id()
  new_content = content.replace(regexp_braced, newcontent_braced(new_id))
  new_contents = []
  if new_content == content
    regexp_braced = new RegExp('\\[new_' + assocs + '\\](.*?\\s)', 'g')
    regexp_underscord = new RegExp('_new_' + assocs + '_(\\w*)', 'g')
    new_content = content.replace(regexp_braced, newcontent_braced(new_id))
  new_content = new_content.replace(regexp_underscord, newcontent_underscord(new_id))
  new_contents = [ new_content ]
  count = if isNaN(count) then 1 else Math.max(count, 1)
  count -= 1
  while count
    new_id = create_new_id()
    new_content = content.replace(regexp_braced, newcontent_braced(new_id))
    new_content = new_content.replace(regexp_underscord, newcontent_underscord(new_id))
    new_contents.push new_content
    count -= 1
  if insertionNode
    if insertionTraversal
      insertionNode = $this[insertionTraversal](insertionNode)
    else
      insertionNode = if insertionNode == 'this' then $this else $(insertionNode)
  else
    insertionNode = $this.parent()
  $.each new_contents, (i, node) ->
    contentNode = $(node)
    insertionNode.trigger 'cocoon:before-insert', [ contentNode ]
    # allow any of the jquery dom manipulation methods (after, before, append, prepend, etc)
    # to be called on the node.  allows the insertion node to be the parent of the inserted
    # code and doesn't force it to be a sibling like after/before does. default: 'before'
    addedContent = insertionNode[insertionMethod](contentNode)
    insertionNode.trigger 'cocoon:after-insert', [ contentNode ]
    return

cocoon_element_counter = 0

create_new_id = ->
  (new Date).getTime() + cocoon_element_counter++

newcontent_braced = (id) ->
  '[' + id + ']$1'

newcontent_underscord = (id) ->
  '_' + id + '_$1'

continueTrack = ->
  track.editor.continueForward()

addStart = ->
  startMarker = L.AwesomeMarkers.icon({
    text: String(starts.length + 1)
    markerColor: 'green'
  })
  starts.push map.editTools.startMarker(null, {icon: startMarker});
  if starts.length > 1
    addField($('#starts .add_fields'))

addEnd = ->
  endMarker = L.AwesomeMarkers.icon({
    text: String(ends.length + 1)
    markerColor: 'red'
  })
  ends.push map.editTools.startMarker(null, {icon: endMarker});
  if ends.length > 1
    addField($('#ends .add_fields'))

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

check_to_hide_or_show_remove_link = ->
    if $('#start_times .nested-fields').length < 2
      $('#start_times .remove_fields').hide()
    else
      $('#start_times .remove_fields').show()

$(document).ready ->
  if($('#map-create-track').length > 0)
    map = L.map('map-create-track', {editable: true}).setView([52.517, 13.364], 12)
    L.tileLayer('http://{s}.tiles.mapbox.com/v3/dahoo.k3dh2bke/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18
    }).addTo(map)
    track = map.editTools.startPolyline(null, {color: 'red'});

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


    $('#new_track').on 'submit', {map: map}, getTrack

    $('#start_times').on 'cocoon:after-insert', check_to_hide_or_show_remove_link
    $('#start_times').on 'cocoon:after-remove', check_to_hide_or_show_remove_link

    $('#starts').on 'cocoon:after-insert', (e, insertedItem) ->
      index = $('#starts .nested-fields').index(insertedItem) + 1
      $(insertedItem).find('span#number i').text(index)

    $('#ends').on 'cocoon:after-insert', (e, insertedItem) ->
      index = $('#ends .nested-fields').index(insertedItem) + 1
      $(insertedItem).find('span#number i').text(index)

    for fields in ['starts', 'ends', 'start_times']
      addField($("##{fields} .add_fields"))
