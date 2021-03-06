Radium.ActivitiesContactController = Radium.ActivityBaseController.extend Radium.ActivityAssignMixin,
  Radium.SaveEmailMixin,
  actions:
    showReplyForm: ->
      if @get('showReplyForm')
        @set 'showReplyForm', false
        return false

      replyForm = Radium.ReplyForm.create
        currentUser: @get('currentUser')

      replyForm.set('repliedTo', @get('email'))

      @set 'replyEmail', replyForm

      @set 'showReplyForm', true

      false

    closeReplyForm: ->
      @set 'showReplyForm', false

      false

    saveEmail: (email) ->
      @_super email, dontTransition: true

      return unless email.get('isValid')

      @flashMessenger.success 'Email Sent!'

      Ember.run.next =>
        @set 'showReplyForm', false

      false

    deleteFromEditor: ->
      @set 'showReplyForm', false

      false

  showReplyForm: false

  replyEmail: null

  isCreate: Ember.computed.is 'event', 'create'
  isUpdate: Ember.computed.is 'event', 'update'
  isAssign: Ember.computed.is 'event', 'assign'
  isDelete: Ember.computed.is 'event', 'delete'
  isStatusChange: Ember.computed.is 'event', 'status_change'
  isPrimaryContact: Ember.computed.is 'event', 'primary_contact'
  isNewEmail: Ember.computed.is 'event', 'new_email'
  isSentEmail: Ember.computed.is 'event', 'sent_email'
  isInfoChange: Ember.computed.is 'event', 'contact_info_change'
  isOpen: Ember.computed.is 'event', 'open'
  isClick: Ember.computed.is 'event', 'click'
  isTodoCreated: Ember.computed.is 'event', 'todo_created'
  isCardReaderAdded: Ember.computed.is 'event', 'cardreader_add'

  contact: Ember.computed.alias 'reference'
  company: Ember.computed.alias 'meta.company'
  status: Ember.computed.alias 'meta.status'
  assignedTo: Ember.computed.alias 'meta.user'

  icon: Ember.computed 'event', ->
    switch @get('event')
      when 'todo_created' then 'check'
      when 'create' then 'star'
      when 'update' then 'write'
      when 'assign' then 'transfer'
      when 'delete' then 'delete'
      when 'status_change' then 'transfer'
      when 'contact_info_change' then 'write'
      when 'primary_contact' then 'buildings'
      when 'new_email' then 'mail'
      when 'sent_email' then 'mail'
      when 'open' then 'view'
