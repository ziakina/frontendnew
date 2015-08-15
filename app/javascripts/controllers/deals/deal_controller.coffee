require 'lib/radium/buffered_proxy'
require 'forms/todo_form'
require 'controllers/deals/checklist_mixin'
require 'mixins/controllers/change_deal_status_mixin'

Radium.DealStatusItemController = Radium.ObjectController.extend
  classStatus: Ember.computed 'model', ->
    @get('model').dasherize()

Radium.DealController = Radium.DealBaseController.extend Radium.ChecklistMixin, BufferedProxy,
  Radium.ChangeDealStatusMixin, Radium.AttachedFilesMixin,

  actions:
    confirmDeletion: ->
      @set "showDeleteConfirmation", true

      false

    save: ->
      @get('store').commit()
      false

    togglePublished: ->
      status = if @get('isPublic')
                 "unpublished"
               else
                 @get('firstState')

      @set 'model.status', status

      @get('store').commit()
      false

    setPrimaryContact: (contact) ->
      unless contact
        @send 'flashError', 'You have not selected a contact'
        return false

      @set('model.contact', contact)

      @set('form.contact', contact)

      @get('model').save().then (result) =>
        @send 'flashSuccess', "#{contact.get('displayName')} is now the primary contact."

      false

  needs: ['accountSettings', 'users', 'contacts', 'pipeline']
  statuses: Ember.computed.alias('controllers.pipeline.dealStates')

  showDeleteConfirmation: false

  users: Ember.computed.oneWay 'controllers.users'

  firstState: Ember.computed.alias('controllers.accountSettings.firstState')
  loadedPages: [1]

  isPublic: Ember.computed.not 'isUnpublished'
  statusDisabled: Ember.computed.not('isPublic')

  contacts: Ember.computed 'controllers.contacts.[]', ->
    @get('controllers.contacts').filter (contact) ->
      contact.get('isPublic')

  contact: Ember.computed.alias('model.contact')

  formBox: Ember.computed 'todoForm', 'noteForm', 'meetingForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      noteForm: @get('noteForm')
      meetingForm: @get('meetingForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    description: null
    reference: @get('model')
    finishBy: null
    user: @get('currentUser')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    topic: null
    location: ""
    isNew: true
    reference: @get('model')
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now').advance(hour: 1)
    endsAt: @get('now').advance(hour: 2)
    invitations: Ember.A()

  noteForm: Radium.computed.newForm 'note'

  noteFormDefaults: Ember.computed 'model', ->
    reference: @get('model')
    user: @get('currentUser')

  dealProgressClass: Ember.computed 'status', ->
    "status-#{@get('status')}"
