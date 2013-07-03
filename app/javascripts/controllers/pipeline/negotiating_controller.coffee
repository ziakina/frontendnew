require 'mixins/controllers/bulk_action_controller_mixin'

Radium.PipelineNegotiatingController = Radium.ObjectController.extend Radium.BulkActionControllerMixin,
  needs: ['pipelineNegotiatingGroup']
  filteredDeals: null

  selectedGroup: Ember.computed.alias 'controllers.pipelineNegotiatingGroup.selectedGroup'

  title: 'Negotiating'

  currentDeals: ( ->
    return unless @get('workflowDeals.length')

    @get('workflowDeals').filter (deal) =>
      deal.get('status') == @get('selectedGroup')
  ).property('selectedGroup', 'workflowDeals.[]')

  checkedContent: ( ->
    @get('workflowDeals').filterProperty 'isChecked'
  ).property('currentDeals.@each.isChecked')

  hasCheckedContent: Ember.computed.bool 'checkedContent.length'

  groups: ( ->
    return [] unless @get('workflowGroups.length')

    Ember.ArrayProxy.create
      content: @get('workflowGroups')
  ).property('workflowGroups')
