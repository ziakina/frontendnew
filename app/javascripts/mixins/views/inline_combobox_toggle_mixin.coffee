Radium.InlineComboboxToggleMixin = Ember.Mixin.create
  classNames: 'field'
  setValue: ->
    @_super.apply this, arguments
    Ember.run.next =>
      @get('parentView').send 'toggleEditor'

  selectItem: ->
    @_super.apply this, arguments
    Ember.run.next =>
      @get('parentView').send 'toggleEditor'
