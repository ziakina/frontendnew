require 'mixins/customfield_inputmixin'
require 'components/regex-input_component'

Radium.CustomfieldUrlinputComponent = Radium.RegexInputComponent.extend Radium.CustomFieldInputMixin,
  classNameBindings: [':customfield-textinput']
  type: 'text'
  regex: Radium.URL_REGEX

  input: (e) ->
    @_super.apply this, arguments

    Ember.run.next =>
      @set 'customFieldValue.value', @$().val()