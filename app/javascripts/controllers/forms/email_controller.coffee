Radium.FormsEmailController = Radium.ObjectController.extend Ember.Evented,
  actions:
    toggleReminderForm: ->
      @toggleProperty 'includeReminder'
      return false

    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return false

    createSignature: ->
      @set 'signatureSubmited', true

      return unless @get('signature.length')

      @set 'signatureSubmited', false

      @get('settings').one 'didUpdate', =>
        @send 'flashSuccess', 'Signature updated'

      @get('store').commit()

      @trigger 'signatureAdded'

    saveAsDraft: (form) ->
      @set 'isDraft', true
      @send 'saveEmail', form

    scheduleDelivery: (form, date) ->
      if typeof date is "string"
        if date == 'tomorrow'
          date = Ember.DateTime.create().advance(day: 1)
        else
          date = Ember.DateTime.create().atEndOfWeek()

      form.set 'sendTime', date
      @send 'saveAsDraft', form
      #Hack to close menu
      $('#sendMenu').removeClass('open')
      $(document).trigger('click.date-send-menu')

    setCheckForResponse: (form, date) ->
      form.set 'checkForResponse', date
      @send 'toggleReminderForm'
      @send('saveEmail', form) if @get('isDraft')

    cancelCheckForResponse: (form) ->
      form.set 'checkForResponse', null
      @send('saveEmail', form) if @get('isDraft')

    cancelDelivery: (form) ->
      form.set 'sendTime', null
      @send 'saveAsDraft', form

    submit: (form) ->
      @set 'isDraft', false
      @send 'saveEmail', form
      false

  needs: ['tags','contacts','users','userSettings']
  users: Ember.computed.alias 'controllers.users'
  contacts: Ember.computed.alias 'controllers.contacts'
  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'
  user: Ember.computed.alias 'controllers.currentUser'
  isEditable: true

  disableSave: false

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

  callForm: Radium.computed.newForm('call')

  callFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    contact: @get('contact')
  ).property('model', 'tomorrow', 'contact')

  expandList: (section) ->
    @set("show#{section.capitalize()}", true)
