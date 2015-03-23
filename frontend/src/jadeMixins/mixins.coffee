ng = require 'angular'
sprintf = require('sprintf-js').sprintf

mod = ng.module('eventreporter.mixins', ['eventreporter.user'])

mod.controller 'LoginWallController', ($scope, LoginService)->
  $scope.loggedIn = ()-> LoginService.loggedIn()
  $scope.login = ()-> LoginService.login()

mod.controller 'FormConfigController', ($rootScope, $scope, $attrs)->
  if not $rootScope.formConfig then $rootScope.formConfig = {}
  cfg = JSON.parse($attrs.formConfig)
  $rootScope.formConfig[cfg.name] = cfg
  $scope.localFormConfig = cfg
  $rootScope[cfg.model] = {}

mod.controller 'FormFieldConfigController', ($scope, $attrs)->
  fieldName = $attrs.fieldName
  fieldConfig = $scope.localFormConfig.fields[fieldName]

  resolvedDefault = undefined
  switch fieldConfig.type
    when 'date'
      if fieldConfig.default == 'now' then resolvedDefault = new Date()
    when 'radio-bool-buttons'
      resolvedDefault = fieldConfig.default
    else
      if fieldConfig.default?
        defaultVal = fieldConfig.default
        fieldConfig = $scope.localFormConfig.fields[fieldName]

        resolvedDefault = switch
          when fieldConfig.options? then fieldConfig.options[defaultVal]
          else defaultVal

  if resolvedDefault?
    $scope[$scope.localFormConfig.model][fieldName] = resolvedDefault