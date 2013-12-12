Radium.activityassignmixin = Ember.Mixin.create
  oldUser: ( ->
    Radium.User.all().find (user) => user.get('id') == (@get('meta.oldUserId') + "")
  ).property('meta.oldUserId')

  newUser: ( ->
    Radium.User.all().find (user) => user.get('id') == (@get('meta.newUserId') + "")
  ).property('meta.newUserId')
