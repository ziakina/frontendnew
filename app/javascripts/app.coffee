# First off, require all the custom additions and code
# we need to be available globally
require /lib\/patches/

require 'lib/ember/arrangable_mixin'
require 'lib/ember/filterable_mixin'
require 'lib/ember/datetime'
require 'lib/ember/computed'

require 'lib/string/inflector'

Radium = Em.Application.createWithMixins
  rootElement: '#application'
  customEvents:
    blur: 'blur'
  timezone: Ember.DateTime.create().get('timezone')
  title: 'Radium'
  notifyCount: 0

  LOG_STACKTRACE_ON_DEPRECATION : true
  LOG_BINDINGS                  : true
  LOG_TRANSITIONS               : true
  LOG_TRANSITIONS_INTERNAL      : true
  LOG_VIEW_LOOKUPS              : true
  LOG_ACTIVE_GENERATION         : true

  titleChanged: ( ->
    title = @get('title')
    notifyCount = @get('notifyCount')

    if notifyCount
      title = "(#{notifyCount}) #{title}"

    window.setTimeout ->
      document.title = "."
      document.title = title
    , 200
  ).observes('notifyCount')

window.Radium = Radium

Radium.deferReadiness()

Ember.RSVP.configure 'onerror', (e) ->
  return if e.message == "TransitionAborted"

  console.log e.message
  console.log e.stack

require /lib\/radium\/base/

require 'lib/radium/computed'

require 'lib/radium/run_when_loaded_mixin'

require 'store'

require 'routes'
requireAll /routes/

require 'models'

require /^forms/

require 'views'

requireAll /components/

require 'lib/radium/checkable_mixin'
require 'lib/radium/selectable_mixin'

require 'controllers'

require /helpers/

require 'debug'
