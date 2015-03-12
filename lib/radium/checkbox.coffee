Radium.Checkbox = Radium.View.extend
  classNameBindings: ['checked:checked:unchecked', ':checker']

  click: (event) ->
    event.stopPropagation()

  init: ->
    @_super.apply this, arguments
    @on "change", this, this._updateElementValue

  _updateElementValue: ->
    @set 'checked', this.$('input').prop('checked')

  checkBoxId: Ember.computed ->
    "checker-#{@get('elementId')}"

  template: Ember.Handlebars.compile """
    <input type="checkbox" id="{{unbound view.checkBoxId}}" {{bind-attr disabled=view.disabled}}/>
    <label for="{{unbound view.checkBoxId}}" class="ss-standard ss-check inline-form-icon"></label>
  """
