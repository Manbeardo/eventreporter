require './players/players.coffee'

sref = require '../utils/sref.coffee'
ng = require 'angular'

mod = ng.module 'eventreporter.event', [
  'ui.bootstrap'
  'ui.router'
  'eventreporter.event.players'
]

mod.config ($stateProvider)->
  $stateProvider.state('event'
    url: '/event/{eventID}'
    abstract: true
    template: '<div ui-view></div>'
    breadcrumb:
      name: ($stateParams)-> $stateParams.eventID
      state: 'event.home'
  )

  $stateProvider.state('event.home'
    url: ''
    template: require('./event.jade')()
  )