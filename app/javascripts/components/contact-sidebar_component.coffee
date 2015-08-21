require "mixins/lists_persistence_mixin"

Radium.ContactSidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  Radium.ListsPersistenceMixin,
  actions:
    addList: (list) ->
      @_super @get('contact'), list

      false

    removeList: (list) ->
      @_super @get('contact'), list

      false

    switchShared: ->
      Ember.run.next =>
        contact = @get('contact')
        contact.toggleProperty('isPublic')

        unless contact.get('isPublic')
          contact.set "potentialShare", true

        contact.save().then =>
          @get('peopleController')?.send 'updateTotals'

          @sendAction("startPolling") if contact.get('isUpdating')

      false

    confirmDeletion: ->
      @set "showDeleteConfirmation", true

      false

  classNameBindings: [':form']

  # UPGRADE: replace with inject
  contactStatuses: Ember.computed ->
    @container.lookup('controller:contactStatuses')

  companies: Ember.computed ->
    @container.lookup('controller:companies')

  users: Ember.computed ->
    @container.lookup('controller:users')

  leadSources: Ember.computed ->
    @container.lookup('controller:accountSettings').get('leadSources')

  peopleController: Ember.computed ->
    @container.lookup('controller:peopleIndex')

  shared: false
  isSaving: false
  condense: false

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'shared', @get('contact.isLoaded')
