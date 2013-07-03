Radium.PipelineController = Radium.ObjectController.extend
  needs: ['accountSettings']
  workflowStates: Ember.computed.alias 'controllers.accountSettings.workflowStates'
  workflowGroups: Ember.computed.alias 'content.workflowGroups'
  leads: Ember.computed.alias 'content.leads'
  closed: Ember.computed.alias 'content.closed'
  unpublished: Ember.computed.alias 'content.unpublished'
  lost: Ember.computed.alias 'content.lost'
