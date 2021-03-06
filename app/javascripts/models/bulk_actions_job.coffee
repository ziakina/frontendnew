Radium.BulkActionsJob = Radium.Model.extend Radium.BulkActionProperties,
  action: DS.attr('string')
  assignedTo: DS.belongsTo('Radium.User')
  status: DS.belongsTo('Radium.ContactStatus')

  exportToCsvJob: Ember.computed.equal 'action', 'export_to_csv'
