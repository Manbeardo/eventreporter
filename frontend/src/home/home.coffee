ng = require 'angular'

mod = ng.module('eventreporter.home', ['ui.router'])

mod.config(($stateProvider)->
  $stateProvider.state('home'
    url: '/home'
    template: require('./home.jade')()
  )
)