Radium.AppController = Ember.Object.extend({
  sideBarView: null,
  feedView: null,
  // During development set to true
  isLoggedIn: true,
  // Store the routes intercepted by Davis
  _statePathCache: {},
  currentPage: null,
  selectedForm: null,
  params: null,
  account: null,
  
  bootstrap: function(data){
    Radium.store.load(Radium.Account, data.account);
    var account = Radium.store.find(Radium.Account, data.account.id);

    //kick off observers
    this.set('account', account);
    this.set('users', data.users);
    this.set('current_user', data.current_user);
    this.set('overdue_feed', data.overdue_feed);
    this.set('feed', data.feed);
  },

  today: Ember.DateTime.create({hour: 17, minute: 0, second: 0}),
  todayString: function() {
    return this.get('today').toFormattedString("%Y-%m-%d");
  }.property('today').cacheable()
});
