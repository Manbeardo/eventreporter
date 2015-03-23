ng = require 'angular'

mod = ng.module('eventreporter.createEvent', ['ui.router'])

mod.config ($stateProvider)->
  $stateProvider.state('createEvent'
    url: '/createEvent'
    template: require('./createEvent.jade')()
    controller: require('./CreateEventController.coffee')
  )