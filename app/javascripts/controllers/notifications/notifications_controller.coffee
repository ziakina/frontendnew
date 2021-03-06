Radium.NotificationsController = Radium.ArrayController.extend Radium.ShowMetalessMoreMixin, Radium.PollerMixin,

  sortProperties: ['time']
  sortAscending: false
  needs: ['messagesSidebar']

  applicationController: Ember.computed.oneWay 'controllers.application'
  isDeleting: false
  actions:
    deleteAllNotifications: ->
      return unless @get('model.length')

      @set 'isDeleting', true

      @send 'toggleNotifications'

      @stop()

      self = this

      complete = ->
        Ember.run.next ->
          return if self.isDestroyed || self.isDestroying
          self.set('isDeleting', false)
          self.start()

      setTimeout ->
        Radium.Notification.all().compact().forEach (notification) ->
          notification.unloadRecord()
      , 0

      currentUser = @get("currentUser")

      job = Radium.DestroyNotificationsJob.createRecord
        user: currentUser

      job.save().then =>
        @send 'flashSuccess', "All Notifications Deleted"
        complete()

    showEmail: (email) ->
      @get('controllers.messagesSidebar').send 'reset'
      @transitionToRoute 'emails.show', "inbox", email

  itemController: 'notificationsItem'

  page: 1
  allPagesLoaded: false
  modelQuery: (page, pageSize) ->
    Radium.Notification.find(page: page, page_size: pageSize, shallow: true)

  onPoll: ->
    existing = Radium.Notification.all().slice()
    applicationController = @get('applicationController')

    Radium.Notification.find({page:1, page_size: 20, shallow: true}).then (records) ->
      return unless records.get('length')

      delta = records.toArray().reject (record) ->
                existing.contains(record) || record.get('read')

      return unless delta?.length

      console.log "#{delta.length} new notifications"

      Radium.NotificationsTotal.find({}).then (result) ->
        total = result.get('firstObject.total')

        applicationController.set('notificationCount', total)
