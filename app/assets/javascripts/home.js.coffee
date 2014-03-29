class Map
    constructor: ->
        mapOptions =
            center: new google.maps.LatLng(37.795001, -122.39997),
            zoom: 14
        this.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
        this.loadStations()
        this.loadTrips()
        
    loadStations: ->
        $.getJSON '/stations.json', (data) =>
            for station in data.stations
                do(station) =>
                    position = new google.maps.LatLng(station.lat, station.lng)
                    markerOptions =
                        position: position
                        map: this.map
                        title: station.name
                    marker = new google.maps.Marker(markerOptions)
                    
    loadTrips: ->
        $.getJSON '/trips.json', (data) =>
            for trip in data.trips
                do(trip) =>
                    lineCoordinates = [
                        new google.maps.LatLng(trip.start_pos[0], trip.start_pos[1]),
                        new google.maps.LatLng(trip.end_pos[0], trip.end_pos[1]),
                    ]
                    line = new google.maps.Polyline
                        path: lineCoordinates,
                        strokeColor: '#0000FF',
                        strokeOpacity: 0.5,
                        strokeWeight: 2
                    line.setMap( this.map )
            
window.Map = Map
