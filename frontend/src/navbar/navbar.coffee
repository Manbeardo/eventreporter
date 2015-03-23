require './navbar.css'

sprintf = require('sprintf-js').sprintf
ng = require 'angular'

mod = ng.module 'eventreporter.navbar', [
  'ui.bootstrap'
  'ui.router'
  'eventreporter.auth'
]

mod.config ($stateProvider)->
  $stateProvider.decorator 'onEnter', (state, parent)->
    return ()->
      console.log('Stuff happened!')
      if parent != undefined
        parent()

recurseStates = ($state, state, worker)->
  if state.name == '' || state.name== '^'
    return true

  worker(state)

  recurseStates($state, $state.get('^', state), worker)

mod.factory 'NavbarLinks', ($rootScope, $state)->
  true

mod.factory 'Breadcrumbs', ($rootScope, $state, $stateParams)->
  Breadcrumbs = {
    elements: []
  }

  fillElements = (state)->
    toState = state.name
    name = undefined
    switch typeof state.breadcrumb
      when 'function' then name = state.breadcrumb($stateParams)
      when 'string' then name = state.breadcrumb
      when 'object'
        crumb = state.breadcrumb
        switch typeof crumb?.name
          when 'function' then name = crumb.name($stateParams)
          when 'string' then name = crumb.name
        toState = crumb.state
      when 'undefined'
      else
        console.error(
          sprintf('Invald breadcrumb type: %s', typeof state.breadcrumb)
        )

    if name? and toState?
      Breadcrumbs.elements.unshift {
        name: name
        sref: sprintf('%s(%s)', toState, JSON.stringify($stateParams))
      }

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams)->
    Breadcrumbs.elements = []
    recurseStates($state, toState, fillElements)

  return Breadcrumbs
mod.directive 'navbar', ()->
  {
    restrict: 'A'
    template: require('./navbar.jade')()
    controller: 'navbarCtrl'
  }

mod.controller 'navbarCtrl', ($scope, $rootScope, LoginService, Breadcrumbs)->
  $scope.isCollapsed = true
  $scope.session = LoginService.session
  $scope.Breadcrumbs = Breadcrumbs

  $scope.login = ()->
    LoginService.login()
    $scope.isCollapsed = true

  $scope.logout = ()->
    LoginService.logout()
    $scope.isCollapsed = true

  $rootScope.$on '$stateChangeStart', ()->
    $scope.isCollapsed = true
