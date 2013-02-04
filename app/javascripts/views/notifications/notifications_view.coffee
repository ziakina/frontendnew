require 'views/drawer_view'

Radium.NotificationsView = Radium.DrawerView.extend
  contentBinding: 'controller'

  remindersBinding: 'controller.reminders'
  notificationGroupsBinding: 'controller.notificationGroups'

  remindersListView: Ember.CollectionView.extend
    contentBinding: 'parentView.reminders'
    classNames: ['unstyled']
    tagName: 'ul'
    itemViewClass: Em.View.extend
      attributeBindings: ['dataReminderId:data-reminder-id']
      templateName: 'notifications/reminder'
      layoutName: 'layouts/notification_panel_item'
      referenceBinding: 'content.reference'

      dataReminderId: (->
        @get('content.id')
      ).property('content')

      description: (->
        @get('reference.topic') || @get('reference.description')
      ).property('reference.topic', 'reference.description')

  notificationsListView: Ember.CollectionView.extend
    tagName: 'ul'
    classNames: ['unstyled']
    itemViewClass: Ember.View.extend
      layoutName: 'layouts/notification_panel_item'
      attributeBindings: ['dataNotificationId:data-notification-id']
      referenceBinding: 'content.reference'

      dataNotificationId: (->
        @get('content.id')
      ).property('content')

      templateName: (->
        tag = @get 'content.tag'
        "notifications/#{tag.replace('.', '_')}"
      ).property('content.tag')
