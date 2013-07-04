require 'lib/radium/groupable'
require 'lib/radium/groupable_with_defaults'

WorkflowGroup = Ember.ArrayProxy.extend
  title: (->
    @get('firstObject.status')
  ).property('firstObject.status')

# FIXME: this should be an Ember.Object. The PipelineController
# has to each into content since properties on an array proxy
# don't work. Also there's never a case where the content is
# not going to be Deal.all
Radium.Pipeline = Ember.ArrayProxy.extend Radium.GroupableWithDefaults,
  content: []
  settings: null
  workflowStates: ( ->
    statuses = @get('settings.workflowStates')

    statuses.forEach (state) =>
      unless @get(state)
        Ember.defineProperty this, state, Ember.computed( ->
          Radium.Deal.filter (deal) ->
            deal.get('status') == state
        ).property("#{state}.[]")

    statuses.pushObjects ['closed', 'lost'] unless statuses.contains 'closed'
    statuses
  ).property('settings.model', 'settings.workflowStates.[]')

  workflowDeals: (->
    statuses = @get 'workflowStates'

    return unless statuses

    Radium.Deal.filter (deal) ->
      statuses.indexOf(deal.get('status')) != -1
  ).property('workflowStates.[]', 'workflowDeals.[]', 'workflowDeals.@each.status')

  workflowGroups: (->
    deals = @get 'workflowDeals'
    return unless deals

    states = @get('settings.workflowStates')

    @group deals, states
  ).property('workflowDeals.[]')

  groupType: WorkflowGroup

  groupBy: (deal) ->
    deal.get('status').replace(/\W+/, "_")

  workflowTotal: (->
    @get 'workflowDeals.length'
  ).property('workflowDeals.length')

  closed: (->
    Radium.Deal.filter (deal) ->
      deal.get('status') == 'closed'
  ).property('closed.[]')

  lost: (->
    Radium.Deal.filter (deal) ->
      deal.get('status') == 'lost'
  ).property('lost.[]')

  unpublished: (->
    Radium.Deal.filter (deal) ->
      deal.get('status') == 'unpublished'
  ).property('unpublished.[]')
