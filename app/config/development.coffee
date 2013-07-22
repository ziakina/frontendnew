Ember.Application.initializer
  name: 'adapterUrl'
  after: 'store'
  initialize: (container, application) ->
    store = container.lookup('store:main')

    Ember.assert 'store found in adapterUrl initializer', store

    store.get('_adapter').reopen
      url: 'http://localhost:9292'

Ember.Application.initializer
  name: 'developmentCookie'
  after: 'store'
  initialize: (container, application) ->
    Ember.$.cookie 'token', 'development'
