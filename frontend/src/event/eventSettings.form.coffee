ng = require 'angular'

form = ng.copy require('../config/event.form.base.coffee')

form.name = 'eventSettingsForm'
form.model = 'eventSettings'
form.submit = 'updateEvent'

module.exports = form