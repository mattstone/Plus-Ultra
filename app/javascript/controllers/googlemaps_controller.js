import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader"

export default class extends Controller {
  static targets = [ "searchLocation", "google_maps_api_key", "latitude", "longitude" ]

  connect() {
    window.initMap = this.initMap;
    this.initMap()
  }
  
  initMap() {
    
    const loader = new Loader({
      apiKey: this.google_maps_api_keyTarget.innerHTML,
      version: "quarterly",
      libraries: ["maps", "geocoding", "places", "marker", "elevation"]
    })   
    
    const draw_map = this.draw_map 
    
    loader
      .load()
      .then((google) => {
        
        var options = {
          types: ["geocode"],
          fields: ["address_components", "geometry", "icon", "name"],          
          componentRestrictions: { country: "au" },
        };
        
        let input = document.getElementById('event_location');
        if (input) {
          var autocomplete = new google.maps.places.Autocomplete(input, options);
        
          autocomplete.addListener("place_changed", function() {
            var place = autocomplete.getPlace();
            draw_map(place.geometry.location.lat(), place.geometry.location.lng())
          })
          
          if (input.value) {
            const latitude  = parseFloat(this.latitudeTarget.innerHTML)
            const longitude = parseFloat(this.longitudeTarget.innerHTML)
            if (latitude && longitude) { this.draw_map(latitude, longitude) }
          }
        }
      })
      .catch((e) => {
        console.log(`error loading gmaps: ${e}`)
      })
  }
  
  draw_map(latitude, longitude) {
    const mapOptions = {
          center: { lat: latitude, lng: longitude },
          zoom: 17,
        }
    
    const map    = new google.maps.Map(document.getElementById("map"), mapOptions)
    const marker = new google.maps.Marker({
          position: {
            lat: latitude,
            lng: longitude
          },
          map: map                 
    })     
  }
  
}
