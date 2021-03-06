require 'mixins/user_combobox_props'
require "mixins/common_modals"

Radium.LeadsNewComponent = Ember.Component.extend Radium.UserComboboxProps,
  Radium.CommonModals,

  actions:
    addList: (list) ->
      model = @get('model')

      unless list.constructor is Radium.List
        Ember.assert "You must include the Radium.CommonModals mixin to create a new list", @_actions['createList']

        return @send 'createList', list, model

      if model.get('isNew')
        model.get('lists').pushObject(list)
        return false

      @sendAction "addList", model, list

      false

    removeList: (list) ->
      model = @get('model')

      if model.get('isNew')
        model.get('lists').removeObject(list)
        return false

      @sendAction "removeList", model, list

      false

    modelChanged: (model) ->
      @sendAction 'modelChanged', model

    clearExisting: ->
      @sendAction 'clearExisting'

    saveModel: (skipValidation) ->
      @sendAction 'saveModel', skipValidation

    toggleMore: ->
      @$('.more').slideToggle "medium", =>
        @toggleProperty("showMore")

    queryProfile: (email) ->
      return unless @get('model.isNew')
      @ProfileService.queryProfile email

    cancelSubmit: ->
      @$('.modal').modal 'hide'

      @$('.company input[type=text]').focus()

  classNameBindings: [':form', ':new-lead-form']

  setup: Ember.on 'didInsertElement', ->
    Ember.run.scheduleOnce 'afterRender', this, 'initialise'
    Ember.run.next =>
      @$('.contact-name .name-field')

  initialise: ->
    @$('.contact-name input[type=text]')?.focus()

  modelDidChange: Ember.observer 'model', ->
    Ember.run.next =>
      @initialise()

  form: null

  showMore: false

  titleQueryParameters: (query) ->
    term: query

  startup: Ember.on 'init', ->
    @ProfileService.on 'profileQueried', this, 'onProfileQueried'

  onProfileQueried: (contact) ->
    addSocialMedia = (key) =>
      return unless social = contact.get(key)

      @get('model').set(key, {url: social.get('url')})

    ['twitter', 'facebook', 'linkedin'].forEach (s) ->
      addSocialMedia s

  nameValidations: ['required']
  emailValidations: ['email']
