import { Controller } from "@hotwired/stimulus"
// const MapboxDirections = require('@mapbox/mapbox-gl-directions')

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    console.log(`I'm connected`)
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({ container: this.element,
    style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.#addGeolocation()
    // this.#addDirections()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window)

      new mapboxgl.Marker({
        color: "#D47AE8",
      })
      .setLngLat([marker.lng, marker.lat])
      .setPopup(popup)
      .addTo(this.map)
    })

  }

  #fitMapToMarkers(){
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([
      marker.lng, marker.lat]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0})
  }

  #addGeolocation(){
    this.map.addControl(
      new mapboxgl.GeolocateControl({
      positionOptions: {
      enableHighAccuracy: true
      },
      // When active the map will receive updates to the device's location as it changes.
      trackUserLocation: true,
      // Draw an arrow next to the location dot to indicate which direction the device is heading.
      showUserHeading: true
      })
      );
      console.log('Added geolocation to map');
      console.log(GeolocationPosition.coords)
  }
}
