ng = require 'angular'

require 'angular-ui-router'
require 'angular-bootstrap'

require './navbar/navbar.coffee'
require './home/home.coffee'

deps = [
  'eventreporter.navbar'
  'eventreporter.home'
  'ui.bootstrap'
  'ui.router'
]

mod = ng.module('main', deps)

mod.config(($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise('/home')

  $stateProvider.state('state1',
    url: '/state1'
    template: require('./state1.jade')()
  )

  $stateProvider.state('state2',
    url: '/state2'
    template: require('./state2.jade')()
  )
)

mod.directive('main', ()->
  {
    restrict: 'A'
    template: require('./main.jade')()
  }
)
