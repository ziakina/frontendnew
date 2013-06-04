Radium.DealsNewController = Radium.ObjectController.extend Radium.ChecklistMixin,
  needs: ['contacts','users', 'accountSettings']
  statuses: Ember.computed.alias('controllers.accountSettings.negotiatingStates')
  newItemDescription: ''
  newItemWeight: null
  newItemFinished: true
  hasContact: Ember.computed.bool 'contact'

  contacts: ( ->
    @get('controllers.contacts').filter (contact) ->
      contact.get('status') != 'personal'
  ).property('controllers.contacts.[]')

  statusesDidChange: ( ->
    return unless @get('statuses.length')
    return if @get('status')

    @set('status', @get('statuses.firstObject'))
  ).observes('statuses.[]')

  saveAsDraft: ->
    @set 'status', 'unpublished'
    @set 'isPublished', false
    @submit()

  publish: ->
    @set 'isPublished', true
    @submit()

  submit: ->
    @set 'isSubmitted', true
    return unless @get('isValid')

    deal = @get('model').create()

    deal.one 'didCreate', =>
      Ember.run.next =>
        @transitionToRoute 'deal', deal

    deal.one 'becameInvalid', (result) =>
      console.log deal.get('errors')

    deal.one 'becameError', (result)  ->
      console.log deal.get('errors')

    @get('store').commit()
