window.addLocateTo = (map) ->
  L.control.locate({
    strings: {
      title: "Zeig mir, wo ich bin",
      popup: "Du bist im Umkreis von {distance} Metern von diesem Punkt"
    },
    locateOptions: {maxZoom: 14}
  }).addTo(map);
