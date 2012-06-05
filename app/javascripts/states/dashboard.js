Radium.DashboardPage = Ember.State.extend({
  enter: function(manager) {
    rootView = manager.get('rootView')

    rootView.get('childViews').removeObject(rootView.get('loading'));

    Radium.get('appController').set('sideBarView', Ember.View.create({
      templateName: 'dashboard_sidebar'
    }));
    
    // var user = Radium.usersController.get('loggedInUser'),
    //     userId = user.get('id'),
    //     dashboardFeedController = Radium.feedController.create({
    //     init: function() {
    //       var pastDates = this.createDateRange({limit: 100}),
    //           futureDates = this.createDateRange({limit: 60, direction: 1});

    //       this.set('futureDates', futureDates);
    //       this.set('pastDates', pastDates);
    //     },
    //     content: [],
    //     _pastDateHash: {},
    //     oldestDateLoaded: null,
    //     newestDateLoaded: null,
    //     oldestHistoricalDate: user.get('createdAt'),
    //     // Set up for loading feed
    //     feedUrl: 'users/%@/feed/'.fmt(userId),

    //     addTodo: function() {
    //       Radium.get('formManager').send('showForm', {
    //         form: 'Todo'
    //       });
    //       return false;
    //     }
    //   });

    // this.set('view', Radium.DashboardView.create({
    //   controller: dashboardFeedController
    // }));

    this._super(manager);
  },

  index: Ember.State.create({
    enter: function(manager) {
      Radium.get('appController').set('feedView', Ember.View.create({
        templateName: 'dashboard_feed',
        contentBinding: 'Radium.activityFeedController.content',
        controller: Radium.get('Radium.activityFeedController')
      }));
    }
  })
});
