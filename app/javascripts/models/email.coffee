Radium.Email = DS.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  subject: DS.attr('string')
  message: DS.attr('string')
  read: DS.attr('boolean')
  isPublic: DS.attr('boolean')
  sentAt: DS.attr('datetime')

  sender: DS.attr('object')
