angular.module('App').controller 'ThingController', ($scope, $element) ->
    'ngInject'
    new class ThingController
      constructor: ->
        @thingUrl = "/api/v1/things/:thing_id"
        @thingMeasurementsUrl = "/api/v1/things/:thing_id/measurements"

        @realtimeTimerId = 0
        @realtimeLastMinutes = 5 # min
        @realtimeRefreshRate = 1000 # ms
        @realtimePoints = 1000 / @realtimeRefreshRate * @realtimeLastMinutes * 60
        @realtimePeaks = false
        #@historicData = {}
        @realtimeData = {}
        # TODO: FIXME: potential bug, we shouldn't store lastValues for all things here, this is a shared variable
        @lastValues = {}

        @configureScope()
        @loadThingUI $scope.thing, $element

      configureScope: ->
        $scope.realtimeLastMinutes = @realtimeLastMinutes
        $scope.selectApiKey = @selectApiKey
        $scope.resetApiKey = @resetApiKey
        $scope.saveThing = @saveThing
        $scope.deleteThing = @deleteThing
        $scope.showApiUrlTextbox = @showApiUrlTextbox
        $scope.hideApiUrlTextbox = @hideApiUrlTextbox
        $scope.thing.randomValue = Math.round Math.random() * 100

        $scope.historicChartintervals =
          hour: '1 hour'
          day: '1 day'
          week: '1 week'
          month: '1 month'
          year: '1 year'
        $scope.historicChartInterval = 'day'
        $scope.changeHistoricChartInterval = @changeHistoricChartInterval

      saveThing: =>
        $scope.thing.$update =>
          @$saveSuccess.stop(true,true).show().fadeOut(3000)
        return

      deleteThing: ($index) =>
        if confirm "Are you sure you want to delete this?"
          $scope.thing.$delete =>
            $scope.things.splice($index, 1)
            @unloadThing()
        return

      changeHistoricChartInterval: =>
        @loadHistoricChart $scope.thing.id
        return

      showApiUrlTextbox: (e) ->
        $element = $(e.currentTarget) # TODO: check cross compatibility, or maybe use e.delegateTarget (safari? firefox? ie?)
        $textDiv = $element.find('.api-url-text')
        $inputDiv = $element.find('.api-url-input')
        $textDiv.hide()
        $inputDiv.show()
        url = $textDiv.text().replace(/[\n\s]+/g, "")
        $inputDiv.find('input').val(url).get(0).select()
        return

      hideApiUrlTextbox: (e) ->

      selectApiKey: (e) ->
        e.target.select()
        return

      resetApiKey: ->
        $scope.thing.$resetApiKey()
        return

      loadThingUI: (thing, $element) =>
        debugger
        @$saveSuccess = $element.find('.settings-save-success').hide()
        @loadUI $element, thing
        @loadHistoricChart thing.id
        @loadRealtimeChart thing.id
        @loadPusher thing.id
        return

      loadUI: ($element, thing) ->
        new Clipboard($element.find('.btn.copy-api-key').get(0))

      loadHistoricChart: (thingId) ->
        $wrapper = $element.find('.historic-chart')
        url = @thingMeasurementsUrl.replace(':thing_id', thingId) + '.csv' + '?interval=' + $scope.historicChartInterval
        dychart = new Dygraph $wrapper.get(0), url
        $scope.historicChart = dychart
        width = dychart.width_
        height = dychart.height_
        $(window).on 'visibilitychange', (e) =>
          dychart.resize 1,1
          dychart.resize width,height
        return

      loadRealtimeChart: (thingId) ->
        $wrapper = $element.find('.realtime-chart')
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
          $scope.realtimeChart = $.plot($wrapper, generateFlotRealtimeData(),
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

        @realtimeTimerId = setInterval updateFlot, @realtimeRefreshRate
        return

      loadPusher: (thingId) ->
        return console.warn 'Unable to load realtime socket (Pusher)' unless Pusher?

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

      unloadThing: ->
        clearInterval @realtimeTimerId
