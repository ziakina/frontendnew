Radium.StaticLineItem = Ember.Object.extend({
  name: null,
  quantity: null,
  price: null,
  currency: null
});

Radium.DealForm = Radium.FormView.extend({
  init: function() {
    this._super();
    // TODO: Remove this once remote queries for contacts autocomplete is set up
    Radium.contactsController.set('content', Radium.store.findAll(Radium.Contact));
  },
  templateName: 'deal_form',

  // Form properties
  closeDateValue: Ember.DateTime.create(),
  closeTimeValue: null,
  descriptionValue: null,
  contactId: null,

  isValid: function() {
    return (this.getPath('invalidFields.length')) ? false : true;
  }.property('invalidFields.@each').cacheable(),

  dealDescriptionField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextArea.extend(Radium.FieldValidation, {
      classNames: ['span8'],
      elementId: 'topic',
      nameBinding: 'parentView.fieldAttributes',
      rules: ['required'],
      valueBinding: 'parentView.parentView.descriptionValue'
    })
  }),

  contactField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Radium.AutocompleteTextField.extend(Radium.FieldValidation, {
      elementId: "deal-contact",
      viewName: 'contactField',
      classNames: ['input-xlarge'],
      rules: ['required'],
      sourceBinding: 'Radium.contactsController.contactNames',
      contactIdBinding: 'parentView.parentView.contactId',
      placeholder: function() {
        return this.getPath('source.length') ? "" : "Loading...";
      }.property('source'),
      disabled: function() {
        return this.getPath('source.length') ? false : true;
      }.property('source'),
      select: function(event, ui) {
        var label = (ui.hasOwnProperty('item')) ? ui.item.label : "";
        this.set('value', label);
        this.set('contactId', ui.item.value);
        event.stopPropagation();
        event.preventDefault();
        return false;
      }
    })
  }),

  closeDateField: Radium.DatePickerField.extend({
    elementId: 'close-date',
    name: 'close-date',
    viewName: 'closeDate',
    classNames: ['input-small'],
    valueBinding: Ember.Binding.dateTime('%Y-%m-%d').from('parentView.closeDateValue')

  }),

  closeTimeField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextField.extend(Radium.FieldValidation, Radium.TimePicker, {
      classNames: ['input-small'],
      elementId: 'close-time',
      nameBinding: 'parentView.fieldAttributes',
      placeholder: 'eg 1:00',
      rules: ['required'],
      formValueBinding: 'parentView.parentView.closeTimeValue'
    })
  }),

  lineItemsContainer: Ember.CollectionView.extend({
    viewName: 'lineItems',
    itemViewClass: Radium.DealLineItemView,
    isMultipleLineItems: function() {
      return (this.getPath('content.length') > 1) ? true : false;
    }.property('content.length'),
    addLineItem: function(event) {
      this.lineItem();
      return false;
    },
    removeLineItem: function(event) {
      this.get('content').removeObject(event.context);
      return false;
    },
    init: function() {
      this._super();
      this.set('content', Ember.A([]));
      this.lineItem();
    },
    lineItem: function() {
      var lineItem = {
        name: null,
        quantity: null,
        price: null,
        currency: null
      };
      this.get('content').pushObject(lineItem);
    }
  }),

  submitForm: function() {
    var self = this;
    var deal,
        contact = this.get('contactId'),
        description = this.get('descriptionValue'),
        closeByValue = this.getPath('closeDate.value'),
        closeByDate = Ember.DateTime.parse(closeByValue, '%Y-%m-%d'),
        closeByTime = this.get('closeTimeValue'),
        userId = Radium.usersController.getPath('loggedInUser.id'),
        lineItems = this.getPath('lineItems.content'),
        data = {
          description: description,
          close_by: closeByDate.adjust({
            hour: closeByTime.getHours(),
            minute: closeByTime.getMinutes()
          }),
          user_id: userId,
          contact_id: contact,
          state: 'pending',
          line_item_attributes: lineItems
        };

    deal = Radium.store.createRecord(Radium.Deal, data);

    Radium.Deal.reopenClass({
      url: '/deals'
    });

    Radium.store.commit();

    this.get('parentView').close();
    return false;
  }
});