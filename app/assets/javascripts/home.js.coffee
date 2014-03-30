class Map
    constructor: ->
        mapOptions =
            center: new google.maps.LatLng(37.78896440509159, -122.39936918518066),
            zoom: 14
        this.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
        this.TICK_LENGTH = 10
        this.TICK_DELAY = 5
        # this.loadStations()
        this.loadTrips()
        
    loadStations: ->
        $.getJSON '/stations.json', (data) =>
            for station in data.stations
                do(station) =>
                    position = new google.maps.LatLng(station.lat, station.lng)
                    markerOptions =
                        position: position
                        map: this.map
                        title: "#{station.id} - #{station.name}"
                    # marker = new google.maps.Marker(markerOptions)
                    
    loadTrips: ->
        $.getJSON '/trips.json', (data) =>
            this.start_tick = data.start_tick
            this.end_tick = data.end_tick
            this.trips = data.trips
            google.maps.event.addListenerOnce(this.map, 'tilesloaded', this.startSim)
            
    drawZipLine: (trip) =>
        if trip.zip_code
            lineCoordinates = [
                new google.maps.LatLng(trip.zip_code.lat, trip.zip_code.lng),
                new google.maps.LatLng(trip.start_pos[0], trip.start_pos[1]),
            ]
            line = new google.maps.Polyline
                path: lineCoordinates,
                strokeColor: '#FF0000',
                strokeOpacity: 0.1,
                strokeWeight: 2
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
                    map: this.map
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
#                    map: this.map
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
                map: this.map
            trip.circle = circle
            
    startSim: =>
        this.cur_tick = this.start_tick
        this.newTrips = []
        for trip in this.trips
            this.newTrips.push(trip)
        this.activeTrips = []
        window.setTimeout(this.tick, this.TICK_DELAY)

    # TODO: excursion trips
    # 
    tick: =>
        if this.cur_tick >= this.end_tick
            this.endSim()
            return

        window.setTimeout(this.tick, this.TICK_DELAY)

        cur_date = new Date(this.cur_tick * 1000)
        $('#infoholder').html(this.formatTime(cur_date))
        
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
         
    startTrip: (trip) =>
        trip.marker = new google.maps.Marker
            position: new google.maps.LatLng(trip.start_pos[0], trip.start_pos[1]),
            map: this.map
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
        this.activeTrips.splice(index, 1)

    endSim: =>
        idx = this.activeTrips.length
        while(idx--)
            this.endTrip(this.activeTrips[idx], idx)
        for trip in this.trips
            if trip.line?
                trip.line.setMap(null)
            if trip.circle?
                trip.circle.setMap(null)
        window.setTimeout(this.startSim, 1)
        
window.Map = Map
