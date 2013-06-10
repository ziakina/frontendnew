Radium.EmailsNewRoute = Ember.Route.extend
  events: 
    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.one 'didCreate', =>
        Ember.run.next =>
          @transitionTo 'emails.sent', email

      email.one 'becameInvalid', =>
        Radium.Utils.generateErrorSummary email

      email.one 'becameError', =>
        Radium.Utils.notifyError 'An error has occurred and the eamil has not been sent'

      @store.commit()

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
