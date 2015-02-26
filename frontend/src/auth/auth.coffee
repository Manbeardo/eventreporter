ng = require 'angular'

mod = ng.module('eventreporter.auth', ['ui.bootstrap'])

mod.factory('Session', ()->
  {
    id: null
    userid: null
  }
)

mod.factory('AuthService', (Session)->
  {
    login: (credentials)->
      if credentials.password != 'foo'
        return false

      Session.id = 1
      Session.userid = credentials.username

      return true

    logout: ()->
      Session.id = null
      Session.userid = null

      return true

    isAuthenticated: ()-> Session.userid?
  }
)

mod.factory 'LoginService', ($modal, AuthService, Session)->
  {
    login: ()->
      $modal.open
        template: require('./loginForm.jade')()
        size: 'sm'
        controller: ($scope, $modalInstance, AuthService, Session)->
          $scope.invalidCredentials = false

          $scope.login = (credentials)->
            if AuthService.login(credentials)
              $modalInstance.close(Session)
              return true
            else
              $scope.invalidCredentials = true
              return false

          $scope.cancel = ()->
            $modalInstance.dismiss('cancel')

    logout: ()->
      Session.id = null
      Session.userid = null
      true

    session: Session
  }