import Ember from 'ember';

const {
  Component,
  on
} = Ember;

export default Component.extend({
  actions: {
    close() {
      const el = this.$();

      if(!el) {
        return;
      }

      el.one($.support.transition.end, () => {
        this.flashMessenger.removeMessage(this.get('messagePart'));
      }).removeClass('in');
    }
  },

  classNames: ['alert', 'fade'],
  classNameBindings: 'messagePart.type',

  _setup: on('didInsertElement', function(){
    this._super(...arguments);

    this.$()[0].offsetWidth; // jshint ignore:line
    this.$().addClass('in');

    const timer = setTimeout(() => {
      this.send('close');
    }, 4000);

    this.set('timer', timer);
  }),

  _teardown: on('willDestroyMessage', function(){
    clearTimeout(this.get('timer'));
  })
});