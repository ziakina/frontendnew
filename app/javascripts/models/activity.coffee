Radium.Activity = Radium.Model.extend Radium.CommentsMixin,
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')
  companies: DS.hasMany('Radium.Company')
  # FIXME: remove when ED supports has many through
  tags: DS.hasMany('Radium.Tag')

  user: DS.belongsTo('Radium.User')

  tag: DS.attr('string')
  event: DS.attr('string')
  meta: DS.attr('object')
  time: DS.attr('datetime')

  reference: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceAttachment') ||
        @get('_referenceCall') ||
        @get('_referenceCompany') ||
        @get('_referenceContact') ||
        @get('_referenceDeal') ||
        @get('_referenceDiscussion') ||
        @get('_referenceEmail') ||
        @get('_referenceMeeting') ||
        @get('_referencePhoneCall') ||
        @get('_referenceTodo') ||
        @get('_referenceVoiceMail')
  ).property('_referenceAttachment',
    '_referenceCall',
    '_referenceCompany',
    '_referenceContact',
    '_referenceDeal',
    '_referenceDiscussion',
    '_referenceEmail',
    '_referenceMeeting',
    '_referencePhoneCall',
    '_referenceTodo',
    '_referenceVoiceMail')
  _referenceAttachment: DS.belongsTo('Radium.Attachment')
  _referenceCall: DS.belongsTo('Radium.Call')
  _referenceCompany: DS.belongsTo('Radium.Company')
  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceDiscussion: DS.belongsTo('Radium.Discussion')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceMeeting: DS.belongsTo('Radium.Meeting')
  _referencePhoneCall: DS.belongsTo('Radium.PhoneCall')
  _referenceTodo: DS.belongsTo('Radium.Todo')
  _referenceVoiceMail: DS.belongsTo('Radium.VoiceMail')
