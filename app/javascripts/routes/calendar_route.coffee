require 'routes/drawer_support_mixin'

Radium.CalendarRoute = Ember.Route.extend Radium.DrawerSupportMixin,
  events: 
    toggleCalendarDrawer: ->
      @toggleDrawer 'calendar/select_user'

    selectUser: (user) ->
      @controllerFor('calendar').set 'user', user
      @closeDrawer()

  serialize: (model) ->
    {
      year: model.get('year')
      month: model.get('month')
      day: model.get('day')
    }

  model: (params) ->
    string = "#{params.year}-#{params.month}-#{params.day}"
    Ember.DateTime.parse string, "%Y-%m-%d"

  renderTemplate: ->
    @render()

    @render 'calendar/sidebar',
      outlet: 'sidebar',
      into: 'calendar'

    @render 'calendar/drawer_buttons',
      outlet: 'buttons'
      into: 'drawer_panel'
