Radium.FeedGroup = Ember.Object.extend({
  content: [],
  date: null,

  isToday: function() {
    var today = Ember.DateTime.create();
    return Ember.DateTime.compareDate(today, this.get('date')) === 0;
  }.property('date').cacheable(),

  isFuture: function() {
    var today = Ember.DateTime.create();
    return Ember.DateTime.compareDate(this.get('date'), today) === 1;
  }.property('date').cacheable(),

  isPast: function() {
    var today = Ember.DateTime.create();
    return Ember.DateTime.compareDate(this.get('date'), today) < 0;
  }.property('date').cacheable(),

  // Open Todos
  ongoingTodos: function() {
    var date = this.get('date');
    return Radium.Todo.filter(function(data) {
      var finishByDate = Ember.DateTime.parse(data.get('finish_by'))
                          .toTimezone(CONFIG.dates.timezone);
      return Ember.DateTime.compareDate(finishByDate, date) === 0;
    });
  }.property().cacheable(),

  sortedOngoingTodos: function() {
    return this.get('ongoingTodos').slice(0).sort(function(a, b) {
      var date1 = a.get('finishBy'),
          date2 = b.get('finishBy');

      if (date1 > date2) return 1;
      if (date1 < date2) return -1;
      return 0;
    });
  }.property('ongoingTodos.@each').cacheable(),

  historical: function() {
    var date = this.get('date');
    return Radium.Activity.filter(function(data) {
      var timestamp = Ember.DateTime.parse(data.get('timestamp'))
                          .toTimezone(CONFIG.dates.timezone);
      return Ember.DateTime.compareDate(timestamp, date) === 0 && data.get('scheduled') !== true;
    });
  }.property().cacheable(),

  sortedHistorical: function() {
    return this.get('historical').slice(0).sort(function(a, b) {
      return a.get('timestamp') - b.get('timestamp');
    });
  }.property('historical.@each').cacheable(),

  hasVisibleContentBinding: Ember.Binding.or(
    'historical.length',
    'ongoingTodos.length',
    'isToday'
  ),
});