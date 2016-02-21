### globals L, CocoonHelper, TrackEditor ###

$(document).ready ->
  if($('#map-create-track').length > 0)
    map = L.map('map-create-track', {editable: true} ).setView([52.517, 13.364], 12)
    L.tileLayer('https://api.tiles.mapbox.com/v4/dahoo.k3dh2bke/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZGFob28iLCJhIjoiMjktOC1BRSJ9.p1-4SJAU0qBT4jYZHF3sHQ', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18
    } ).addTo(map)
    window.addLocateTo(map)

    cocoon = new CocoonHelper()

    trackEditor = new TrackEditor(map)
    trackEditor.addButtons()

    $('#new_track').on 'submit', {map: map} , trackEditor.getTrack

    $('#start_times').on 'cocoon:after-insert', (e, insertedItem) ->
      window.bind_wday_date_switch(insertedItem)
      $(':checkbox').bootstrapSwitch()
      window.check_to_hide_or_show_remove_link
    $('#start_times').on(
      'cocoon:after-remove', window.check_to_hide_or_show_remove_link
    )

    trackEditor.setCocoonCallbacks()

    for fields in ['starts', 'ends', 'start_times']
      cocoon.addField($("##{fields} .add_fields"))

    $('#starts').find('.remove_fields').first().hide()
    $('#ends').find('.remove_fields').first().hide()
