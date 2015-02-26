require './navbar.css'

ng = require 'angular'

mod = ng.module('eventreporter.navbar', ['ui.bootstrap', 'eventreporter.auth'])

mod.directive('navbar', ()->
  {
    restrict: 'A'
    template: require('./navbar.jade')()
    controller: 'navbarCtrl'
  }
)

mod.controller('navbarCtrl', ($scope, LoginService) ->
  $scope.isCollapsed = true
  $scope.LoginService = LoginService
)