define(function(require) {

  var RadiumAdapter = require('adapter'),
    Radium = require('radium');
  
  require('controllers/feed');

  describe("Radium#feedController", function() {
    var adapter, store, server, spy;

    beforeEach(function() {
      adapter = RadiumAdapter.create();
      store = DS.Store.create({adapter: adapter});
      server = sinon.fakeServer.create();
      spy = sinon.spy(jQuery, 'ajax');
      
      store.loadMany(Radium.Activity, [
        {id: 200, timestamp: "2012-09-12T14:26:27Z"},
        {id: 201, timestamp: "2012-09-25T14:26:27Z"},
        {id: 202, timestamp: "2012-10-08T14:26:27Z"},
        {id: 203, timestamp: "2012-11-30T14:26:27Z"},
        {id: 204, timestamp: "2012-12-17T14:26:27Z"},
        {id: 205, timestamp: "2011-12-24T14:26:27Z"}
      ]);
      Radium.feedController.set('content', store.findAll(Radium.Activity));

    });

    afterEach(function() {
      adapter.destroy();
      store.destroy();
      server.restore();
      jQuery.ajax.restore();
      Radium.feedController.set('content', []);
      Radium.feedController.set('sorted', []);
    });

    it("loads activities", function() {
      console.log(Radium.feedController.get('sorted'));
    });

    // it("maps days", function() {
    //   expect(Radium.feedController.get('days'))
    //     .toEqual(['12-2012', '25-2012', '08-2012', '30-2012', '17-2012', '04-2011']);
    // });

    // it("maps months", function() {
    //   expect(Radium.feedController.get('months'))
    //     .toEqual(['01-2012', '05-2012', '07-2012', '08-2012', '12-2011']);
    // });

    // it("maps years", function() {
    //   expect(Radium.feedController.get('years')).toEqual(['2012', '2011']);
    // });
  });
  
});