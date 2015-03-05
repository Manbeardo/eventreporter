ng = require 'angular'

require './ui-bootstrap-fix.css'

require 'angular-ui-router'
require 'angular-bootstrap'
require 'angular-local-storage'

require './navbar/navbar.coffee'
require './home/home.coffee'
require './auth/auth.coffee'
require './user/user.coffee'
require './event/event.coffee'

deps = [
  'eventreporter.navbar'
  'eventreporter.home'
  'eventreporter.auth'
  'eventreporter.user'
  'eventreporter.event'
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
