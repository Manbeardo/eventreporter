sref = require '../../utils/sref.coffee'
ng = require 'angular'

mod = ng.module 'eventreporter.event.players', ['ui.router']

mod.config ($stateProvider)->
  $stateProvider.state('event.players'
    url: '/players'
    template: require('./players.jade')()
    breadcrumb: 'players'
  )