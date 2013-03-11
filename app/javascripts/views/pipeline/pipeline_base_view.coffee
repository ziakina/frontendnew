Radium.PipelineViewBase = Ember.View.extend
  bulkLeader: ( ->
    form = @get('controller.activeForm')
    return unless form

    length = @get('controller.checkedContent.length')

    prefix =
      switch form
        when "assign" then "REASSIGN "
        when "todo" then "ADD A TODO ABOUT  "
        when "call" then "CREATE AND ASSIGN A CALL FROM  "
        else
          throw new Error("Unknown #{form} for bulkLeader")

    result = 
      if length == 1
        "#{prefix} THIS LEAD"
      else
        "#{prefix} THESE SELECTED #{@get('controller.checkedContent.length')} LEADS"

    return result unless form == "assign"

    result += " TO"
  ).property('controller.activeForm', 'controller.checkedContent.length')
