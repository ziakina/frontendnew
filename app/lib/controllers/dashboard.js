Radium.dashboardController = Radium.feedController.create({
  content: [],
  // Filter the feed by type
  categoryFilter: 'everything',
  filterTypes: [
    Ember.Object.create({
      title: 'Everything', 
      shortname: 'everything', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Todos', 
      shortname: 'todos', 
      formViewClass: 'Todo',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Meetings', 
      shortname: 'meetings', 
      formViewClass: 'Meeting',
      isMain: false
    }), 
    Ember.Object.create({
      title: 'Phone Calls', 
      shortname: 'phonecalls', 
      formViewClass: 'CallList',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Deals', 
      shortname: 'deals', 
      formViewClass: 'Deal',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Messages', 
      shortname: 'messages',
      formViewClass: 'Message', 
      isMain: false
    }),
    Ember.Object.create({
      title: 'Discussions', 
      shortname: 'discussions', 
      formViewClass: 'Discussion',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Pipeline', 
      shortname: 'Pipeline', 
      isMain: true
    })
  ],

  statsTitle: "Statistics",
  // allStats: [
  //       ['Leads', 10.0],
  //       ['Prospects', 10],
  //       ['Meetings', 10],
  //       ['Call List', 10],
  //       ['Pending Deals', 20],
  //       ['Closed Deals', 4],
  //       ['Paid Deals', 6],
  //       ['Rejected Deals', 1]
  //     ],
  /**
    Collect these stats for the dashboard chart:
    - Leads {Radium.Contact}
    - Prospects {Radium.Contact}
    - Meetings {Radium.Meeting}
    - Call List {Radium.CallList}
    - Pending Deals {Radium.Deal}
    - Closed Deals {Radium.Deal}
    - Paid Deals {Radium.Deal}
    - Rejected Deals {Radium.Deal}

    @binding {Radium.contactsController}
    @binding {Radium.dealsController}
    @return {Array}
  */
  stats: function() {
    var leads = Radium.contactsController.get('leads'),
        prospects = Radium.contactsController.get('prospects'),

        pendingDeals = Radium.dealsController.get('content').filterProperty('state', 'pending').get('length'),
        closedDeals = Radium.dealsController.get('content').filterProperty('state', 'closed').get('length'),
        paidDeals = Radium.dealsController.get('content').filterProperty('state', 'paid').get('length'),
        rejectedDeals = Radium.dealsController.get('content').filterProperty('state', 'rejected').get('length'),
        meetings = Radium.meetingsController.getPath('content.length'),
        callLists = Radium.callListsController.getPath('content.length');
    return [
        ['Leads', leads.get('length')],
        ['Prospects', prospects.get('length')],
        ['Meetings', meetings],
        ['Call List', callLists],
        ['Pending Deals', pendingDeals],
        ['Closed Deals', closedDeals],
        ['Paid Deals', paidDeals],
        ['Rejected Deals', rejectedDeals]
      ];
  }.property(
    'Radium.contactsController.content',
    'Radium.dealsController.content'
  ).cacheable(),
  arrayDidChange: function(content, idx, removedCnt, addedCnt) {
    var self = this,
        // Grab only new array items
        newActivities = content.slice(idx);

    var createDateGroup = function(day, type, activityType, item) {
      var dayGroup = Ember.Object.create({
        date: day,
        datetime: item.get('date'),
        type: type,
        todos: Ember.A([]),
        deals: Ember.A([]),
        meetings: Ember.A([]),
        campaigns: Ember.A([]),
        calls: Ember.A([])
      });
      dayGroup.get(activityType).pushObject(item);
      return dayGroup;
    };
        
    // Goes through only newly added array items
    newActivities.forEach(function(item) {
      var day = item.get('day'),
          week = item.get('week'),
          month = item.get('month'),
          quarter = item.get('quarter'),
          year = item.get('year'),
          activityType =  item.get('activityType') + 's',
          // Cache `Radium.activityDateGroupsController`
          cache = Radium.activityDateGroupsController.get('content');
      
      // Map and check if the date group has already been stored in memory.
      var map = cache.mapProperty('date'),
          dayIdx = map.indexOf(day),
          weekIdx = map.indexOf(week),
          monthIdx = map.indexOf(month),
          quarterIdx = map.indexOf(quarter),
          yearIdx = map.indexOf(year);
      
      // FIXME: This can probably reduced to a simpler loop
      // Day
      if (dayIdx < 0) {
        cache.pushObject(createDateGroup(day, 'day', activityType, item));
      } else {
        cache.objectAt(dayIdx).get(activityType).pushObject(item);
      }
      // Week
      if (weekIdx < 0) {
        cache.pushObject(createDateGroup(week, 'week', activityType, item));
      } else {
        cache.objectAt(weekIdx).get(activityType).pushObject(item);
      }

      // Month
      if (monthIdx < 0) {
        cache.pushObject(createDateGroup(month, 'month', activityType, item));
      } else {
        cache.objectAt(monthIdx).get(activityType).pushObject(item);
      }

      // Quarter
      if (quarterIdx < 0) {
        cache.pushObject(createDateGroup(quarter, 'quarter', activityType, item));
      } else {
        cache.objectAt(quarterIdx).get(activityType).pushObject(item);
      }

      // Year
      if (yearIdx < 0) {
        cache.pushObject(createDateGroup(year, 'year', activityType, item));
      } else {
        cache.objectAt(yearIdx).get(activityType).pushObject(item);
      }
    });

    // Made our calculations, carry on then.
    this._super(content, idx, removedCnt, addedCnt);

  }
});