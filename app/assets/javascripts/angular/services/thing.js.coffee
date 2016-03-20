class Thing
  constructor: ($resource) ->
    'ngInject'

    ###
    # Handy methods to make service work with Rails
    ###
    unpackThings = (data) =>
      data = angular.fromJson(data) if _.isString data
      data.forEach unpackThing
      return data

    unpackThing = (data) =>
      data = angular.fromJson(data) if _.isString data
      ['range_min', 'range_max', 'alarm_min', 'alarm_max'].forEach (field) ->
        data[field] = Number data[field]
      return data

    packThing = (data) =>
      return angular.toJson(thing: data)

    return $resource '/', {id: '@id', api_key: '@api_key'},
      all:
        url: '/api/v1/things'
        method: "GET"
        isArray: true
        transformResponse: unpackThings
      create:
        url: '/api/v1/things'
        method: "POST"
        transformResponse: unpackThing
      update:
        url: '/api/v1/things/:id'
        method: "PUT"
        transformRequest: packThing
        transformResponse: unpackThing
      resetApiKey:
        url: '/api/v1/things/reset_api_key/:api_key'
        method: "GET"
        transformResponse: unpackThing
      deleteThing:
        url: '/api/v1/things/:id'
        method: "DELETE"

angular.module('App').factory 'Thing', Thing