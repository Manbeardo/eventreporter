ng = require 'angular'

mod = ng.module('eventreporter.event', ['ui.bootstrap', 'ui.router'])

mod.config ($stateProvider)->
  $stateProvider.state('createEvent'
    url: '/createEvent'
    template: require('./createEvent.jade')()
    controller: ($scope)->
      updateName = ()->
        if not $scope.createEventForm? or $scope.createEventForm.name.$pristine
          dateString = $scope.eventDetails.date.toISOString()
          location = $scope.eventDetails.location ? {name: ''}
          playerType = $scope.eventDetails.playerType
          format = $scope.eventDetails.format.name
          pairingMethod = $scope.eventDetails.pairingMethod
          bracketed = if $scope.eventDetails.bracketed then 'Bracketed' else ''
          $scope.eventDetails.name = "#{dateString} #{location.name}
          #{bracketed} #{pairingMethod} #{playerType} #{format}"

      $scope.supportsBracketing = ()->
        if $scope.eventDetails.pairingMethod == 'Swiss'
          return false
        return true

      $scope.eventDetails = {}

      # Populate dropdowns
      $scope.locations = [
        {name: 'Foo Kingdom'}
        {name: 'Channel Bar'}
        {name: 'Baz Boarding House'}
      ]
      $scope.formats = require './formats.coffee'
      $scope.playerTypes = [
        {name: 'Single'}
        {name: '2HG'}
        {name: 'Trios'}
      ]
      $scope.pairingMethods = [
        {name: 'Swiss'}
        {name: 'Single Elimination'}
        {name: 'Double Elimination'}
      ]

      # Set default values
      $scope.eventDetails.date = new Date()
      $scope.eventDetails.format = $scope.formats[0]
      $scope.eventDetails.playerType = 'Single'
      $scope.eventDetails.pairingMethod = 'Swiss'

      # Set watches
      $scope.$watch(condition, updateName) for condition in [
        'eventDetails.date'
        'eventDetails.location'
        'eventDetails.format'
        'eventDetails.playerType'
        'eventDetails.pairingMethod'
        'eventDetails.bracketed'
      ]

      updateName()
  )
