moment = require 'moment'
sprintf = require('sprintf-js').sprintf

module.exports = ($scope, $location, $state)->
  $scope.eventDetails = {}
  $scope.eventDetails.format = {}

  updateEventName = ()->
    if not $scope.createEventForm? or $scope.createEventForm.name.$pristine
      pieces = []
      pieces.push moment($scope.eventDetails.date).format('YYYY-MM-DD HH:mmZZ')
      if $scope.eventDetails.sanctioned
        pieces.push $scope.eventDetails.location?.name ? ''
      if $scope.supportsBracketing() && $scope.eventDetails.bracketed
        pieces.push 'Bracketed'
      pieces.push $scope.eventDetails.pairingMethod?.name
      if $scope.eventDetails.playerType?.name != 'Individual'
        pieces.push $scope.eventDetails.playerType?.name
      pieces.push $scope.eventDetails.format.name

      shortPieces = []
      shortPieces.push moment($scope.eventDetails.date).format('MMMM Do')
      switch $scope.eventDetails.playerType?.name
        when 'Two-Headed Giant' then shortPieces.push '2HG'
        when 'Trios' then shortPieces.push 'Trios'
      shortPieces.push $scope.eventDetails.format.name

      $scope.eventDetails.name = pieces.join(' ')
      $scope.eventDetails.shortName = shortPieces.join(' ')

  $scope.supportsBracketing = ()->
    return ($scope.eventDetails.format.bracketed &&
      $scope.eventDetails.pairingMethod?.name != 'Swiss')

  $scope.createEvent = ()->
    # TODO: actually call the backend
    $state.go('event.home', {eventID: 'foobar'})

  # Populate dynamic options
  # TODO: actually call the backend
  $scope.sanctioningBodies = [
    {name: 'Foo Kingdom LLC'}
  ]
  $scope.locations = [
    {name: 'Foo Kingdom'}
    {name: 'Cafe Bar'}
    {name: 'Baz Boarding House'}
  ]

  # Bind the format select
  $scope.$watch 'eventDetails.format', (format)->
    playerType = $scope.eventDetails.playerType
    if !format.giant && playerType?.name == "Two-Headed Giant"
      $scope.eventDetails.playerType = null
    else if !format.trios && playerType?.name == "Trios"
      $scope.eventDetails.playerType = null

  # Set watches
  $scope.$watch(condition, updateEventName) for condition in [
    'eventDetails.date'
    'eventDetails.location'
    'eventDetails.format'
    'eventDetails.playerType'
    'eventDetails.pairingMethod'
    'eventDetails.bracketed'
  ]

  updateEventName()