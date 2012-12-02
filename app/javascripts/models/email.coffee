Radium.Email = Radium.Message.extend
  to: DS.attr('array')
  from: DS.attr('array')
  subject: DS.attr('string')
  html: DS.attr('string')
  sender: Radium.polymorphicAttribute()

  associatedContacts: Radium.defineFeedAssociation(Radium.Contact, 'sender')

  user: DS.belongsTo('Radium.User', polymorphicFor: 'sender')
