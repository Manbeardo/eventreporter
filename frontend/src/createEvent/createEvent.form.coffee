ng = require 'angular'

form = ng.copy(require('../config/event.form.base.coffee'))

form.name = 'createEventForm'
form.model = 'eventDetails'
form.submit = 'createEvent'
form.fields.date.default = 'now'
form.fields.sanctioned.default = false
form.fields.format.default = 'standard'
form.fields.playerType.default = 'solo'
form.fields.pairingMethod.default = 'swiss'
form.fields.bracketed.default = false
form.fields.rounds.default = 3

module.exports = form