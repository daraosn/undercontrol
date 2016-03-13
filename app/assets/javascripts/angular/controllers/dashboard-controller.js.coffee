class DashboardController
  constructor: ($scope, $q, Thing) ->
    'ngInject'
    $scope.things = Thing.all()

angular.module('App').controller 'DashboardController', DashboardController