Radium.InlineForm = Ember.Mixin.create({
  close: function(event) {
    var self = this,
        form = event.context || event;

    $.when(form.$().slideUp('fast'))
      .then(function() {
        self.set('currentView', null);
      });
    return false;
  }
});