Radium.EmailsSentController = Radium.ObjectController.extend
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: null
    user: @get('currentUser')

  to: Ember.computed 'toList.[]', 'toList.@each.isLoaded', ->
    return @get('toList')
