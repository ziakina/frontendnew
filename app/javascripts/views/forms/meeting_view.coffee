require 'lib/radium/time_picker_view'
require 'lib/radium/location_picker'
require 'lib/radium/autocomplete_list_view'

Radium.FormsMeetingView = Radium.FormView.extend
  classNames: ['meeting-form-container']

  onFormReset: ->
    @$('form')[0].reset()

  readableStartsAt: ( ->
    @get('controller.startsAt').toHumanFormatWithTime()
  ).property('startsAt')

  didInsertElement: ->
    @_super.apply this, arguments

  willDestroyElement: ->
    $('html').off 'click.cancel-meeting'

  showCancelMeetingDialogue: ->
    return if @get('controller.isNew')

    dialogue =  @$('.cancel-meeting')

    dialogue.show()

    event.stopPropagation()

    $('html').on 'click.cancel-meeting', ->
      $('html').off 'click.cancel-meeting'
      dialogue.hide()

    false

  cancelMeetingDialogue: Radium.View.extend
    classNames: ['cancel-meeting']
    template: Ember.Handlebars.compile """
      <div class="content">
        <div>Are you sure you want to cancel meeting</div>
        <div>{{controller.cancellationText}}</div>
        <div>
          <div>
            <button {{action cancel target="view" bubbles=false}} class="btn btn-no">No</button>
            <button {{action cancelMeeting target="view" bubbles=false}} class="btn btn-danger">YES, CANCEL</button>
          </div>
        </div>
        <div>Notifications will be sent to attendees</div>
      </div>
    """
    cancel: ->
      @$().hide()

    cancelMeeting: ->
      @$().hide()

  topicField: Radium.MentionFieldView.extend
    classNameBindings: ['isInvalid', ':meeting']
    disabledBinding: 'controller.isPrimaryInputDisabled'
    placeholder: 'Add meeting topic'
    valueBinding: 'controller.topic'

    isSubmitted: Ember.computed.alias('controller.isSubmitted')

    click: (evt) ->
      evt.stopPropagation()

    keyDown: (evt) ->
      @set('controller.isExpanded', true) unless @get('controller.isExpanded')

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

  datePicker: Radium.DatePicker.extend
    classNames: ['starts-at']
    dateBinding: 'controller.startsAt'
    leader: 'When:'
    isInvalid: (->
      return false unless @get('isSubmitted')
      return false if Ember.isEmpty(@get('text'))
      return false unless @get('date')

      @get('date').isBeforeToday()
    ).property('isSubmitted', 'controller.startsAt')

  startsAt: Radium.TimePickerView.extend
    leader: 'Starts:'
    dateBinding: 'controller.startsAt'
    isInvalid: ( ->
      return false unless @get('isSubmitted')
      @get('controller.startsAtIsInvalid')
    ).property('isSubmitted', 'controller.startsAt', 'controller.endsAt', 'date')

  endsAt: Radium.TimePickerView.extend
    dateBinding: 'controller.endsAt'
    leader: 'Ends:'
    isInvalid: ( ->
      return false unless @get('isSubmitted')
      @get('controller.endsAtIsInvalid')
    ).property('isSubmitted', 'controller.startsAt', 'controller.endsAt', 'date')

  location: Radium.LocationPicker.extend
    valueBinding: 'controller.location'
    isInvalid: false

  attendees: Radium.AutocompleteView.extend
    sourceBinding: 'controller.attendees'
    addSelection: (item) ->
      @get('controller').addSelection item
    removeSelection: (item) ->
      @get('controller').removeSelection item

  cancelMeetingDisabled: ( ->
    @get('controller.isDisabled') || @get('controller.isNew')
  ).property('controller.isDisabled', 'controller.isNew')
