Radium.OverdueItemsView = Ember.View.extend({
  followUpButton: Ember.Button.extend({
    classNames: 'btn pull-right inline-btn btn-warning',
    template: Ember.Handlebars.compile('Add followup')
  }),
  templateName: 'overdue_deals'
});