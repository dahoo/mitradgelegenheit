window.addLocateTo = (map) ->
  L.control.locate(
    strings:
      title: 'Zeig mir, wo ich bin'
      popup: 'Du bist im Umkreis von {distance} Metern von diesem Punkt'
    locateOptions: maxZoom: 14).addTo map

window.bind_start_time_events = (el, hide = false) ->
  el.find('.date_select').hide() if hide
  el.find('input.switch_wday_date').on 'switchChange.bootstrapSwitch', (event, state) ->
    parent = $(this).closest '.track_start_times_start_time'
    parent.find('.wday_select').toggle()
    parent.find('.every_select').toggle()
    parent.find('.date_select').toggle()
  el.find('.track_start_times_day_of_week select')
    .on('change', (event) ->
      window.selectDayOfWeek(el))

window.check_to_hide_or_show_remove_link = ->
  if $('#start_times .nested-fields').length < 2
    $('#start_times .remove_fields').hide()
  else
    $('#start_times .remove_fields').show()

window.selectDayOfWeek = (el) ->
  day = el.find('.track_start_times_day_of_week select').val()
  disabled = day >= 10
  el.find('.track_start_times_every select').prop('disabled', disabled)
