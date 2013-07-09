Radium.PipelineResourceDealsRoute = Radium.Route.extend
  serialize: (model) ->
    key = Radium.Model.keyFromValue(model.constructor)

    unless key
      throw new Error("no entry in Radium.Model.mappings for #{model.constructor}")

    resource_type: key
    resource_id: model.get('id')

  model: (params) ->
    type = Radium.Model.mappings[params.resource_type]
    type.find(params.resource_id)

  setupController: (controller, resource) ->
    property = resource.constructor.toString().humanize()

    model = Radium.Deal.all().filter (deal) -> deal.get(property) == resource
    controller.set('model', model)

  renderTemplate: ->
    @render 'pipeline.opendeals',
      controller: 'pipelineResourceDeals'
