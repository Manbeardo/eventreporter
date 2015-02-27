ng = require 'angular'

mod = ng.module('eventreporter.home', ['ui.router', 'eventreporter.auth'])

mod.config ($stateProvider)->
  $stateProvider.state('home'
    url: '/home'
    template: require('./home.jade')()
    controller: 'HomeController'
  )

mod.controller('HomeController', ($scope, Session, LoginService)->
  $scope.Session = Session
  $scope.openLoginModal = LoginService.openLoginModal
)