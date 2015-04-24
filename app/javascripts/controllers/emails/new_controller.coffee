Radium.EmailsNewController = Radium.Controller.extend Ember.Evented,
  Radium.SaveEmailMixin,
  actions:
    addSignature: (signature) ->
      @set 'settings.signature', signature

      @get('settings').save(this).then =>
        @send 'flashSuccess', 'Signature updated'

    changeViewMode: (mode) ->
      @transitionToRoute "emails.new", queryParams: mode: mode, from_people: false

      false

  queryParams: ['mode', 'from_people']

  mode: 'single'
  from_people: false

  isBulkEmail: Ember.computed.equal 'mode', "bulk"

  needs: ['tags', 'contacts', 'users', 'userSettings', 'deals', 'peopleIndex', 'messages', 'messagesSidebar']

  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'
