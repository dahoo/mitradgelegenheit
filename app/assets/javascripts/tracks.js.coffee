window.addLocateTo = (map) ->
  L.control.locate(
    strings:
      title: 'Zeig mir, wo ich bin'
      popup: 'Du bist im Umkreis von {distance} Metern von diesem Punkt'
    locateOptions: maxZoom: 14).addTo map

window.bind_wday_date_switch = (el) ->
  el.find('.date_select').hide()
  el.find('input.switch_wday_date').on 'switchChange.bootstrapSwitch', (event, state) ->
    parent = $(this).closest '.track_start_times_start_time'
    parent.find('.wday_select').toggle()
    parent.find('.date_select').toggle()
