Radium.List = Radium.Model.extend
  name: DS.attr('string')
  itemName: DS.attr('string')
  type: DS.attr('string')

  listStatuses: DS.hasMany('Radium.ListStatus')
