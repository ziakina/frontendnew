Radium.ActivitiesController = Radium.ArrayController.extend
  sortProperties: ['created_at']
  sortAscending: false

  lookupItemController: (activity) ->
    "activities.#{activity.get('tag')}"
