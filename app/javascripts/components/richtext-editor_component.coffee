Radium.RichtextEditorComponent = Ember.Component.extend Radium.UploadingMixin,
  Radium.AutocompleteMixin,
  classNameBindings: [':richtext-editor', 'isInvalid']
  btnSize: 'bth-xs'
  height: 120

  files: Ember.computed.alias 'targetObject.files'

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    textarea = @$('textarea')

    textarea.summernote
      height: @get('height')
      toolbar: [
        ['style', ['bold', 'italic', 'underline', 'clear']]
        ['fontsize', ['fontsize']]
        ['color', ['color']]
        ['para', ['ul', 'ol', 'paragraph']]
        ['height', ['height']]
        ['insert', ['link', 'picture']]
        ['table', ['table']]
        ['help', ['help']]
        ['misc', ['codeview', 'undo', 'redo']]
      ]

    textarea.code @get('content')

    @$('.btn').addClass @get('btnSize')

    Ember.run.scheduleOnce 'afterRender', this, 'addOverrides'

    return unless parent = @get('parent')

    parent.on "placeholderInsered", this, "onPlaceholderInserted"

  removePlaceHolder: ->
    editable = @$('.note-editable')
    editable.removeClass('placeholder')
    editable.html('')
    @set 'placeholderShown', true

  addOverrides: ->
    editable = @$('.note-editable')

    if tabindex = @get('tabindex')
      editable.attr('tabindex', tabindex)

    editable.addClass('placeholder').one 'focus', @removePlaceHolder.bind(this)

    dropdowns = $('[data-toggle=dropdown]')

    dropdowns.dropdown()

    dropzone = @$(".note-dropzone")

    self = this

    drop = @richTextAreaDrop.bind this

    dropzone.off("drop").on "drop", drop

  richTextAreaDrop: (e) ->
    files = e.dataTransfer.files

    return unless files.length

    @uploadFiles files

    $(document).trigger('drop')

    e.preventDefault()
    false

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    @$('.note-editable').off 'focus'
    @$('textarea').destroy()
    @$(".note-dropzone").off('drop')

  input: ->
    @doUpdate()

  click: (e) ->
    @doUpdate()
    $('[data-toggle=dropdown]').each ->
      $(this).parents('.btn-group.open').removeClass 'open'

  doUpdate: ->
    content = @$('.note-editable').html()
    @set('content', content)

  onPlaceholderInserted: (key) ->
    @removePlaceHolder() unless @get('placeholderShown')

    text = Radium.TemplatePlaceholderMap[key]

    text = "{#{text}|\"fallback\"}"

    editable = @$('.note-editable')

    content = editable.html() + text
    editable.html(content)

    editable.setEndOfContentEditble()
    @doUpdate()

  placeholderShown: false

  autocompleteElement: ->
    @$('.note-editable')