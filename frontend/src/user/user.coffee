ng = require 'angular'

mod = ng.module('eventreporter.user', ['ui.router'])

mod.config ($stateProvider)->
  $stateProvider.state('user'
    url: '/user/{userid}'
    template: require('./user.jade')()
  )

  $stateProvider.state('editProfile'
    url: '/editProfile'
    template: require('./editProfile.jade')()
  )

  $stateProvider.state('register'
    url: '/register'
    template: require('./register.jade')()
  )