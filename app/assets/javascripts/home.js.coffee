class Map
    constructor: ->
        mapOptions =
            center: new google.maps.LatLng(37.78896440509159, -122.39936918518066),
            zoom: 14
        $('#msg-holder').html("Loading Map...")
        this.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
        google.maps.event.addListenerOnce(this.map, 'tilesloaded', this.loadStations)
        this.TICK_LENGTH = 10
        this.TICK_DELAY = 5
        this.simStopped = true
        this.trips = []
        this.newTrips = []
        this.started = false
        $('#gogogo').click =>
            if !this.started
                this.started = true
                this.selectDate( "02/18/2014" )
            $('#overlay').slideUp()
            return false
        $('#overlay-hidden').click =>
            $('#overlay').slideDown()
            return false
    
    loadStations: =>
        $.getJSON '/stations.json', (data) =>
            this.stations = data.stations
            this.stationsById = {}
            for station in this.stations
                this.stationsById[station.id] = station
                this.drawStationCircle(station)
            $('#msg-holder').html("Pick a Day - It's a Bike Ballet")
            $( "#datepicker" ).datepicker
                minDate: "08/29/2013"
                maxDate: "02/28/2014"
                onSelect: this.selectDate
            $( "#datepicker" ).datepicker("setDate", "02/18/2014")
            
    selectDate: (date) =>
        this.date = date
        this.simStopped = true
        this.loadTrips()
        return false

    resetSim: =>
        this.simStopped = true
        if this.countdownTimeout
            window.clearTimeout(this.countdownTimeout)
        if this.tickTimeout
            window.clearTimeout(this.tickTimeout)
        if this.restartTimeout
            window.clearTimeout(this.restartTimeout)
        for station in this.stations
            this.drawStationCircle(station)
        for trip in this.trips
            trip.line.setMap(null) if trip.line?
            trip.marker.setMap(null) if trip.marker?
        
    loadTrips: =>
        this.resetSim()
        $('#date-holder').html("Loading Today's Trips...")
        $('#time-holder').html("")
        dateToLoad = this.date
        $.getJSON "/trips.json?date=#{dateToLoad}", (data) =>
            this.resetSim()
            this.start_tick = data.start_tick
            this.end_tick = data.end_tick
            this.trips = data.trips
            $('#date-holder').html(dateToLoad)
            this.startSim()
                
    startSim: =>
        this.cur_tick = this.start_tick
        for station in this.stations
            this.drawStationCircle(station)

        this.newTrips = []
        for trip in this.trips
            this.newTrips.push(trip)
            trip.line.setMap(null) if trip.line?
            trip.marker.setMap(null) if trip.marker?
            this.drawTripLine(trip)
            trip.line.setMap(this.map)
            station = this.stationsById[trip.start_station_id]
            station.circle.setRadius(station.circle.getRadius() + 1)
            station = this.stationsById[trip.end_station_id]
            station.circle.setRadius(station.circle.getRadius() + 1)
    
        this.activeTrips = []
        this.simStopped = false
        this.count = 6
        this.countdown()

    countdown: =>
        this.count -= 1
        $('#time-holder').html("Wait for it... #{this.count}")
        if this.count <= 0
            for station in this.stations
                this.drawStationCircle(station)
            this.startTicks()
        else
            this.countdownTimeout = window.setTimeout(this.countdown, 1000)

    drawStationCircle: (station) =>
        if station.circle
            station.circle.setMap(null)
            
        station.circle = new google.maps.Circle
            center: new google.maps.LatLng(station.lat, station.lng)
            radius: 25
            strokeColor: '#333333'
            strokeOpacity: 0.5
            strokeWeight: 1
            fillColor: '#FF0000'
            fillOpacity: 0.5
            zIndex: 10
            map: this.map

    drawTripLine: (trip) =>
        if trip.start_pos[0] != trip.end_pos[0] or trip.start_pos[1] != trip.end_pos[1]
            if false and trip.overview_polyline
                lineCoordinates = google.maps.geometry.encoding.decodePath(trip.overview_polyline)
                line = new google.maps.Polyline
                    path: lineCoordinates,
                    strokeColor: '#0000FF',
                    strokeOpacity: 0.04,
                    strokeWeight: 2
            else
                lineCoordinates = [
                    new google.maps.LatLng(trip.start_pos[0], trip.start_pos[1]),
#                    new google.maps.LatLng(trip.start_pos[0], trip.start_pos[1]),
                    new google.maps.LatLng(trip.end_pos[0], trip.end_pos[1]),
                ]
                line = new google.maps.Polyline
                    path: lineCoordinates,
                    strokeColor: '#0000FF',
                    strokeOpacity: 0.1,
                    strokeWeight: 2
                trip.step_lat = ((trip.end_pos[0] - trip.start_pos[0]) / ( trip.duration/this.TICK_LENGTH ))
                trip.step_lng = ((trip.end_pos[1] - trip.start_pos[1]) / ( trip.duration/this.TICK_LENGTH ))
                trip.line = line
        else
            circle = new google.maps.Circle
                center: new google.maps.LatLng(trip.start_pos[0], trip.start_pos[1]),
                radius: 100,
                strokeColor: '#0000FF',
                strokeOpacity: 0.1,
                strokeWeight: 2,
                fillOpacity: 0.0
            trip.line = circle

    startTicks: =>
        for trip in this.trips
            trip.line.setMap(null)
        this.tickTimeout = window.setTimeout(this.tick, this.TICK_DELAY)

    # TODO: excursion trips
    # TODO: pause
    # TODO: show timeline of activity during the day
    # TODO: timeline annotation like soundcloud
    # TODO: show occupancy of stations

    tick: =>
        if this.cur_tick >= this.end_tick
            this.endSim()
            return

        if this.simStopped
            this.endSim()
            return
            
        this.tickTimeout = window.setTimeout(this.tick, this.TICK_DELAY)

        cur_date = new Date(this.cur_tick * 1000)
        $('#time-holder').html(this.formatTime(cur_date))
        
        while true
            if this.newTrips[0]
                if this.cur_tick >= this.newTrips[0].start_tick
                    trip = this.newTrips.shift()
                    this.startTrip(trip)
                else
                    break
            else
                break
                
        index = 0

        idx = this.activeTrips.length
        while(idx--)
            this.updateTrip(this.activeTrips[idx], idx)
            
        this.cur_tick += this.TICK_LENGTH
         
    startTrip: (trip) =>
        trip.marker = new google.maps.Marker
            position: new google.maps.LatLng(trip.start_pos[0], trip.start_pos[1]),
            map: this.map
        station = this.stationsById[trip.start_station_id]
        station.circle.setRadius(station.circle.getRadius() + 1)
        this.drawTripLine(trip)
        this.activeTrips.push(trip)

    updateTrip: (trip, index) =>
        return if not trip?
        if this.cur_tick >= trip.end_tick
            this.endTrip(trip, index)
        else
            center = trip.marker.getPosition()
            position = new google.maps.LatLng( center.lat() + trip.step_lat, center.lng() + trip.step_lng )
            trip.marker.setPosition( position )

            # if trip.line?
            #     path = trip.line.getPath()
            #     path.setAt(1, position)
                
    endTrip: (trip, index) =>
        trip.marker.setMap(null)
        if trip.line?
            trip.line.setMap(this.map)
        station = this.stationsById[trip.end_station_id]
        station.circle.setRadius(station.circle.getRadius() + 1)
        this.activeTrips.splice(index, 1)

    endSim: =>
        idx = this.activeTrips.length
        while(idx--)
            this.endTrip(this.activeTrips[idx], idx)
        if !this.simStopped
            $('#time-holder').html("And the day is done.")
            this.restartTimeout = window.setTimeout(this.startSim, 5000)

    formatTime: (date) ->
        hh = date.getUTCHours()
        mm = date.getUTCMinutes()
        tm = "am"
        if (hh > 11)
             tm = "pm"
        if (hh == 0)
            hh = 12
        if (hh > 12)
            hh = hh - 12
        if (mm < 10)
            mm = "0"+mm
        return "#{hh}:#{mm} #{tm}"
        
window.Map = Map
