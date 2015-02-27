require './navbar.css'

ng = require 'angular'

mod = ng.module 'eventreporter.navbar', [
  'ui.bootstrap'
  'ui.router'
  'eventreporter.auth'
]

mod.directive('navbar', ()->
  {
    restrict: 'A'
    template: require('./navbar.jade')()
    controller: 'navbarCtrl'
  }
)

mod.controller 'navbarCtrl', ($scope, $rootScope, LoginService)->
  $scope.isCollapsed = true
  $scope.session = LoginService.session

  $scope.login = ()->
    LoginService.login()
    $scope.isCollapsed = true

  $scope.logout = ()->
    LoginService.logout()
    $scope.isCollapsed = true

  $rootScope.$on '$stateChangeStart', ()->
    $scope.isCollapsed = true
