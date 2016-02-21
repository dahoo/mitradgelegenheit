window.addLocateTo = (map) ->
  L.control.locate(
    strings:
      title: 'Zeig mir, wo ich bin'
      popup: 'Du bist im Umkreis von {distance} Metern von diesem Punkt'
    locateOptions: maxZoom: 14).addTo map

window.bind_wday_date_switch = (el, hide = false) ->
  el.find('.date_select').hide() if hide
  el.find('input.switch_wday_date').on 'switchChange.bootstrapSwitch', (event, state) ->
    parent = $(this).closest '.track_start_times_start_time'
    parent.find('.wday_select').toggle()
    parent.find('.every_select').toggle()
    parent.find('.date_select').toggle()

window.check_to_hide_or_show_remove_link = ->
  if $('#start_times .nested-fields').length < 2
    $('#start_times .remove_fields').hide()
  else
    $('#start_times .remove_fields').show()
