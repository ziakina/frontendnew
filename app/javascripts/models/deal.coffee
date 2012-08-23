Radium.Deal = Radium.Core.extend
  isEditable: true
  name: DS.attr('string')
  description: DS.attr('string')
  closeBy: DS.attr('date', key: 'close_by')

  # Can be `pending`, `closed`, `paid`, `rejected`
  state: DS.attr('dealState')
  isPublic: DS.attr('boolean', key: 'public')
  user: DS.belongsTo('Radium.User', key: 'user_id')
  isPending: (->
    @get('state') is 'pending'
  ).property('state')
  isClosed: (->
    @get('state') is 'closed'
  ).property('state')
  isPaid: (->
    @get('state') is 'paid'
  ).property('state')
  isRejected: (->
    @get('state') is 'rejected'
  ).property('state')

  ###
  Checks to see if the Deal has passed it's close by date.
  @return {Boolean}
  ###
  isOverdue: (->
    d = new Date().getTime()
    closeBy = new Date(@get('closeBy')).getTime()
    (if (closeBy <= d) then true else false)
  ).property('closeBy')
