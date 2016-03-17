class DashboardController
  constructor: ($scope, $q, Thing) ->
    'ngInject'
    @Thing = Thing
    @$scope = $scope
    
    window.things = $scope.things = Thing.all()
    $scope.addThing = @addThing

  addThing: =>
    @Thing.create (thing) => @$scope.things.push thing

angular.module('App').controller 'DashboardController', DashboardController