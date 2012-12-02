Radium.Comment = Radium.Core.extend
  dateToISO8601: (->
    return this.get('createdAt').toISO8601()
  ).property('createdAt')
  text: DS.attr('string')

  commentable: Radium.polymorphicAttribute()

  todo: DS.belongsTo('Radium.Todo', polymorphicFor: 'commentable')
  meeting: DS.belongsTo('Radium.Meeting', polymorphicFor: 'commentable')
  user: DS.belongsTo('Radium.User', polymorphicFor: 'commentable')
  campaign: DS.belongsTo('Radium.Campaign', polymorphicFor: 'commentable')
  group: DS.belongsTo('Radium.Group', polymorphicFor: 'commentable')
  contact: DS.belongsTo('Radium.Contact', polymorphicFor: 'commentable')
  callList: DS.belongsTo('Radium.CallList', polymorphicFor: 'commentable')
  deal: DS.belongsTo('Radium.Deal', polymorphicFor: 'commentable')
  phone_call: DS.belongsTo('Radium.PhoneCall', polymorphicFor: 'commentable')
