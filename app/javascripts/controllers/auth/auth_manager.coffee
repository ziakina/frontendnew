Radium.AuthManager = Ember.Object.extend
  _token: null
  init: ->
    @_super.apply this, arguments
    @set('token', $.cookie('token'))

  token: Ember.computed((key, value) ->
    if arguments.length == 2
      @set '_token', value
      return

    @get('_token')
  )["volatile"]()

  setAjaxHeaders: Ember.observer('_token', ->
    if token = @get('_token')
      Ember.$.ajaxSetup
        headers:
          "X-Ember-Compat": "true",
          "X-User-Token": token
  ).on('init')

  tokenDidChange: Ember.observer('token', ->
    token = @get('_token')

    return unless Ember.isEmpty(token)

    location.replace(window.API_HOST + '/sessions/new')
  ).on('init')

  logOut: (apiUrl, destination = 'http://www.radiumcrm.com/') ->
    Ember.$.ajax
      url: "#{apiUrl}/sessions/destroy"
      dataType: 'jsonp',
      success:  ->
        location.replace destination
