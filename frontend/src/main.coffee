ng = require 'angular'

require './ui-bootstrap-fix.css'
require '../node_modules/ng-table-release/dist/ng-table.css'

require 'angular-ui-router'
require 'angular-bootstrap'
require 'angular-local-storage'
require 'ng-table-release'

require './navbar/navbar.coffee'
require './home/home.coffee'
require './auth/auth.coffee'
require './user/user.coffee'
require './event/event.coffee'
require './createEvent/createEvent.coffee'

require './jadeMixins/mixins.coffee'

deps = [
  'eventreporter.navbar'
  'eventreporter.home'
  'eventreporter.auth'
  'eventreporter.user'
  'eventreporter.event'
  'eventreporter.mixins'
  'eventreporter.createEvent'
  'ui.bootstrap'
  'ui.router'
]

mod = ng.module('main', deps)

mod.config ($urlRouterProvider, $stateProvider)->
  $urlRouterProvider.when('', '/home')
  $urlRouterProvider.otherwise('/404')

  $stateProvider.state '404', {
    url: '/404'
    template: require('./404.jade')()
  }

mod.directive 'main', ()->
  {
    restrict: 'A'
    template: require('./main.jade')()
    controller: ($scope, $stateParams)->
      $scope.stateParams = $stateParams
  }
