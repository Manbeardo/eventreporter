ng = require 'angular'

mod = ng.module('eventreporter.auth', ['ui.bootstrap', 'LocalStorageModule'])

mod.config (localStorageServiceProvider)->
  localStorageServiceProvider.setPrefix('eventreporter')
  localStorageServiceProvider.setStorageType('sessionStorage')

mod.factory 'Session', (localStorageService)->
  storage = localStorageService

  {
    id: storage.get('sessionID') ? null
    userid: storage.get('sessionUserID') ? null

    setID: (id)->
      @id = id
      storage.set('sessionID', id)

    setUserID: (userid)->
      @userid = userid
      storage.set('sessionUserID', userid)
  }


mod.factory('AuthService', (Session)->
  {
    login: (credentials)->
      if credentials.password != 'foo'
        return false

      Session.setID 1
      Session.setUserID credentials.username

      return true

    isAuthenticated: ()-> Session.userid?
  }
)

mod.factory 'LoginService', ($modal, AuthService, Session)->
  {
    login: ()->
      $modal.open
        template: require('./loginForm.jade')()
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
      Session.setID null
      Session.setUserID null
      true

    session: Session
  }