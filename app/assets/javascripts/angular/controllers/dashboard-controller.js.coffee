class DashboardController
  constructor: ($scope, $q, Thing) ->
    'ngInject'
    window.things = $scope.things = Thing.all()

angular.module('App').controller 'DashboardController', DashboardController