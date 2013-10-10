Radium.InitialImportPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 1000

  onPoll: ->
    currentUser = @get('currentUser')
    Ember.assert "You need to pass set currentUser on the InitialImportPoller", currentUser

    Radium.User.find({user_id: currentUser.get('id')}).then (users) =>
      @stop() if users.get('firstObject.initialMailImported')