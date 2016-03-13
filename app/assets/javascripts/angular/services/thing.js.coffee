class Thing
  constructor: ($resource) ->
    'ngInject'
    return $resource '/', {},
      all:
        url: '/api/v1/things'
        method: "GET"
        isArray: true
      resetApiKey:
        url: '/api/v1/things/:thing_id/reset_api_key'
        method: "GET"

angular.module('App').factory 'Thing', Thing