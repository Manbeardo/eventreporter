require './navbar.css'

ng = require 'angular'

mod = ng.module('eventreporter.navbar', [])

mod.directive('navbar', ()->
  {
    restrict: 'A'
    template: require('./navbar.jade')()
  }
)

mod.controller('navbarCtrl', ($scope) ->
  $scope.isCollapsed = true
)