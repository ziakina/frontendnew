Radium.FormController = Radium.ObjectController.extend Ember.Evented,
  justAdded: (->
    @get('content.justAdded') == true
  ).property('content.justAdded')

  showOptions: Ember.computed.alias('isNew')

  isPrimaryInputDisabled: (->
    return false if @get('isNew')
    return true unless @get('isExpanded')
    @get 'isDisabled'
  ).property('isDisabled', 'isExpanded', 'isNew')

  showComments: (->
    return false if @get('justAdded')
    return false if @get('isNew')
    true
  ).property('isNew', 'justAdded')

  showSuccess: Ember.computed.alias('justAdded')

  isEditable: (->
    return false if @get('isSubmitted')
    return false if @get('justAdded')
    return false if @get('isSaving')
    return true if @get('isNew')
    true
  ).property('content', 'content.isEditable', 'isSaving')

  isExpandable: (->
    return false if @get('justAdded')
    !@get('isNew') && !@get('isFinished')
  ).property('isNew', 'isFinished')

  isExpandableDidChange: (->
    if !@get('isExpandable') then @set('isExpanded', false)
  ).observes('isExpandable')

  isDisabled: (->
    return true if @get('justAdded')
    @get('content.isEditable') is false
  ).property('model', 'isEditable')

  toggleExpanded: ->
    @toggleProperty 'isExpanded'

  expand: ->
    return unless @get('isExpandable')
    @toggleProperty 'isExpanded'

  hasComments: Ember.computed.present('comments')
  showAddAction: Ember.computed.not('isNew')

  toggleFormBox: ->
    @toggleProperty 'showFormBox'

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
  ).property('todoForm', 'callForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')


