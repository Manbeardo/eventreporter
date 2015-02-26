ng = require 'angular'

require 'angular-ui-router'
require 'angular-bootstrap'

require './navbar/navbar.coffee'
require './home/home.coffee'
require './auth/auth.coffee'

deps = [
  'eventreporter.navbar'
  'eventreporter.home'
  'eventreporter.auth'
  'ui.bootstrap'
  'ui.router'
]

mod = ng.module('main', deps)

mod.config( ($urlRouterProvider)->
  $urlRouterProvider.otherwise('/home') 
)

mod.directive('main', ()->
  {
    restrict: 'A'
    template: require('./main.jade')()
  }
)
