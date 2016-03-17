class ThingController
  constructor: ($scope, $element, Thing) ->
    'ngInject'
    @$scope = $scope
    @$element = $element
    @Thing = Thing

    @thingUrl = "/api/v1/things/:thing_id"
    @thingMeasurementsUrl = "/api/v1/things/:thing_id/measurements"

    @realtimeLastMinutes = 5 # min
    @realtimeRefreshRate = 1000 # ms
    @realtimePoints = 1000 / @realtimeRefreshRate * @realtimeLastMinutes * 60
    @realtimePeaks = false
    #@historicData = {}
    @realtimeData = {}
    @lastValues = {}

    @configureScope()
    @loadThingUI $scope.thing, $element

  configureScope: ->
    @$scope.realtimeLastMinutes = @realtimeLastMinutes
    @$scope.selectApiKey = @selectApiKey
    @$scope.resetApiKey = @resetApiKey
    @$scope.saveThing = @saveThing

  saveThing: =>
    thing = @$scope.thing
    thing.$update =>
      @$saveSuccess.stop(true,true).show().fadeOut(3000)

  selectApiKey: (e) =>
    e.target.select()

  resetApiKey: =>
    @$scope.thing.$resetApiKey()# { id: thing.id, api_key: thing.api_key }, (newThing) => thing.api_key = newThing.api_key

  loadThingUI: (thing, $element)  =>
    @$saveSuccess = @$element.find('.settings-save-success').hide()
    @loadUI $element, thing
    @loadHistoricChart thing.id, $element.find('.historic-chart')
    @loadRealtimeChart thing.id, $element.find('.realtime-chart')
    @loadPusher thing.id
    return

  loadUI: ($element, thing) =>
    new Clipboard($element.find('.btn.copy-api-key').get(0))

  loadHistoricChart: (thingId, $wrapper) ->
    url = @thingMeasurementsUrl.replace(':thing_id', thingId) + '.csv'
    @$scope.realtimeChart = new Dygraph $wrapper.get(0), url
    return

  loadRealtimeChart: (thingId, $wrapper) =>
    @realtimeData[thingId] = (0 for i in [0..@realtimePoints-1])

    generateFlotRealtimeData = =>
      points = []
      for i in [0..@realtimeData[thingId].length - 1]
        points.push [i, @realtimeData[thingId][i]]
      series = [{
        data: points
        lines:
          fill: true
      }]
      return series

    pollData = =>
      $.ajax
        url: @thingMeasurementsUrl.replace(':thing_id', thingId) + '.json'
        contentType: 'json'
        success: (data) =>
          #@historicData = data
          @lastValues[thingId] = _(data).last()?.value
          return

    pollData()    

    updateFlot = =>
      @realtimeData[thingId] = @realtimeData[thingId].slice(1)
      @realtimeData[thingId].push(@lastValues[thingId] or 0)
      @lastValues[thingId] = 0 if @realtimePeaks
      @$scope.historicChart = $.plot($wrapper, generateFlotRealtimeData(),
        grid:
          borderWidth: 1
          minBorderMargin: 20
          labelMargin: 10
          backgroundColor: colors: [
            '#fff'
            '#e4f4f4'
          ]
          margin:
            top: 20
            bottom: 20
            left: 20
          markings: (axes) ->
            markings = []
            xaxis = axes.xaxis
            x = Math.floor(xaxis.min)
            while x < xaxis.max
              markings.push
                xaxis:
                  from: x
                  to: x + xaxis.tickSize
                color: 'rgba(232, 232, 255, 0.2)'
              x += xaxis.tickSize * 2
            markings
        xaxis:
          tickFormatter: -> ''
        yaxis:
          # TODO: use this method or find a better way for min/max
          # min: _.min @realtimeData[thingId]
          # max: _.max @realtimeData[thingId]
          min: _.min(@realtimeData[thingId]) * 0.8
          max: _.max(@realtimeData[thingId]) * 1.25
        legend:
          show: true
      )

    setInterval updateFlot, @realtimeRefreshRate
    return

  loadPusher: (thingId) ->
    if window.undercontrol.development
      # Enable pusher logging - don't include this in production
      Pusher.log = (message) ->
        if window.console and window.console.log
          window.console.log message
        return

    pusher = new Pusher('b35a4fcab94f68f53468', encrypted: true)
    channel = pusher.subscribe("things-#{thingId}-measurements")
    channel.bind 'new', (point) =>
      @lastValues[thingId] = point.value
      #@historicData.push point
      return

    return

angular.module('App').controller 'ThingController', ThingController