defaultTimeout = 2000

window.wait = (timeout, callback) ->
  timeout ?= 2000
  stop()
  setTimeout( (->
    start()
    callback()
  ), timeout)


window.waitFor = (condition, callback, messageOrCallback) ->
  messageOrCallback ?= 'waitFor timed out'

  startedAt = new Date().getTime()

  stop()

  checkCondition = ->
    delta = new Date().getTime() - startedAt
    if delta > defaultTimeout
      start()
      if messageOrCallback.call
        messageOrCallback()
      else
        throw messageOrCallback
    else
      if condition()
        start()
        callback()
      else
        setTimeout(checkCondition, 20)

  checkCondition()

window.waitForSelector = (selector, callback, message) ->
  selector = [selector] unless $.isArray(selector)
  condition = -> $.apply($, selector).length
  message ?= "Waiting for '#{selector}' timed out"

  callbackWithElement = ->
    # don't ask me why, but such additional short timeout fixes some
    # of the tests cases where there are problems with callbacks,
    # it may be related to animations or Ember.bindings
    wait 10, ->
      callback($.apply($, selector))

  waitFor condition, callbackWithElement, message

window.waitForResource = (resource, callback, message) ->
  id = resource.get('id')
  type = resource.constructor
  domClass = resource.get('domClass')
  selector = ".#{domClass}"
  message ?= "Could not find #{type} with id #{id} on the page"


  waitForSelector selector, callback, message

window.elementFor = (resource) ->
  id = resource.get('id')
  type = resource.constructor
  domClass = resource.get('domClass')
  $(".#{domClass}")

contains = (element, text) ->
  if typeof element == 'string'
    text = element
    element = $('body')

  throw "Element undefined" unless element
  throw "text is missing" unless text

  r = new RegExp(text)
  elementText = element.text().replace(/[\n\s]+/g, ' ')
  {
    result: r.test elementText
    text: elementText
    queryText: text
  }

window.assertContains = (element, text) ->
  match = null
  waitFor (->
    match = contains(element, text)
    match.result
  ), (-> ok true ), (->
    ok match.result, "Could not find '#{match.queryText}' inside #{match.text}"
  )

window.assertNotContains = (element, text) ->
  match = null
  waitFor (->
    match = contains(element, text)
    !match.result
  ), (-> ok true ), (->
    ok !match.result, "Found '#{match.queryText}' inside #{match.text}"
  )

window.fillIn = (selector, text) ->
  # keyup with any char to trigger bindings sync
  event = jQuery.Event("keyup")
  event.keyCode = 46
  $(selector).val(text).trigger(event)

window.enterNewLine = (selector) ->
  event = jQuery.Event("keypress")
  event.keyCode = 13
  $(selector).trigger(event)

window.assertResource = (resource) ->
  waitForResource resource, (-> )

window.reset = ->
  Em.run ->
    if Radium.app
      if Radium.store
        Radium.store.destroy()
      Radium.app.destroy()
  $('#application').remove()
  $('body').append( $('<div id="application"></div>') )

window.app = (url) ->
  reset()
  Em.run ->
    Radium.createApp()
    Radium.app.initialize()
    Radium.get('router').route(url)
