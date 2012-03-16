minispade.require('jquery');
minispade.require('jquery-ui');
minispade.require('ember');
minispade.require('ember-datetime');
minispade.require('ember-data');
minispade.require('davis');
minispade.require('date-utils');
minispade.require('highcharts');
minispade.require('bootstrap-tooltip');
minispade.require('radium/mixins/jqueryui');
minispade.require('radium/adapters/main');
minispade.require('radium/core/radium');
minispade.require('radium/helpers/main');

minispade.require('radium/models/main')
minispade.require('radium/controllers/main');
minispade.require('radium/views/main');
minispade.require('radium/core/routes');
minispade.require('radium/states/main');

$(document).ready(function() {
  Radium.Routes.start();
});

// FIXME: Temp fix until the datepicker registering clicks can be solved.
$('body').on('click', 'table.ui-datepicker-calendar', function(event) {
  return false;
});