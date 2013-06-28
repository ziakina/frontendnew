# Temp object created for new items, to avoid DS swallowing them
Radium.NewChecklist = Ember.Object.extend
  isValid: (->
    true if !Ember.isEmpty(@get('weight')) and !Ember.isEmpty(@get('description'))
  ).property('weight', 'description')

Radium.PipelineChecklist = Radium.Model.extend
  kind: DS.attr('string')
  description: DS.attr('string')
  weight: DS.attr('number')
  date: DS.attr('date')