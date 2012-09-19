test 'feed should allow changing ranges', ->
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    waitForResource section, ->
      $('#sidebar .weekly').click()

      # this secectors may change, but it's ok for now
      waitForSelector '.grouped_feed_section_2012-08-13-week', ->
        assertContains '10 todos'
        assertNotContains 'Big contract'

        $('#sidebar .monthly').click()
        waitForSelector '.grouped_feed_section_2012-08-01-month', ->
          assertContains 'Big contract'
