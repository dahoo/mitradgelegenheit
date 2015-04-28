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
    parent.find('.date_select').toggle()

window.addField = ($this) ->
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

window.check_to_hide_or_show_remove_link = ->
  if $('#start_times .nested-fields').length < 2
    $('#start_times .remove_fields').hide()
  else
    $('#start_times .remove_fields').show()