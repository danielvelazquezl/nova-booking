//= require jquery3
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-datepicker/core
//= require jquery.easy-autocomplete

$(function () {
    let options_easy = {

      url: "/welcome/resources.json",
    
      getValue: "name",
      
      list: {
        match: {
          enabled: true
        }
      },
    
      theme: "blue-light"
    };
      $("#with_search_results").easyAutocomplete(options_easy);
  });

addEventListener("direct-upload:initialize", event => {
    const { target, detail } = event
    const { id, file } = detail
    target.insertAdjacentHTML("beforebegin", `
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
      <span class="direct-upload__filename"></span>
    </div>
  `)
    target.previousElementSibling.querySelector(`.direct-upload__filename`).textContent = file.name
})

addEventListener("direct-upload:start", event => {
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.remove("direct-upload--pending")
})

addEventListener("direct-upload:progress", event => {
    const { id, progress } = event.detail
    const progressElement = document.getElementById(`direct-upload-progress-${id}`)
    progressElement.style.width = `${progress}%`
})

addEventListener("direct-upload:error", event => {
    event.preventDefault()
    const { id, error } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add("direct-upload--error")
    element.setAttribute("title", error)
})

addEventListener("direct-upload:end", event => {
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add("direct-upload--complete")
})

function initMap2() {
    let lat = document.getElementById('latitude').value;
    let lng = document.getElementById('longitude').value;
    //if not defined create default position
    if (!lat || !lng){
        let geoSuccess = function(position) {
            lat = position.coords.latitude;
            lng = position.coords.longitude;
            document.getElementById('tem_latitude').value = position.coords.latitude;
            document.getElementById('tem_longitude').value = position.coords.longitude;
            load(lat,lng)
        };
        navigator.geolocation.getCurrentPosition(geoSuccess);
    }else{
        load(lat,lng)
    }

    function load(lat, lng) {
        let myCoords = new google.maps.LatLng(lat, lng);
        let mapOptions = {
            center: myCoords,
            zoom: 14
        };
        let map = new google.maps.Map(document.getElementById('map2'), mapOptions);

        let marker = new google.maps.Marker({
            position: myCoords,
            animation: google.maps.Animation.DROP,
            map: map,
            draggable: true
        });

        // refresh marker position and recenter map on marker
        function refreshMarker(){
            let lat = document.getElementById('tem_latitude').value;
            let lng = document.getElementById('tem_longitude').value;
            let myCoords = new google.maps.LatLng(lat, lng);
            marker.setPosition(myCoords);
            map.setCenter(marker.getPosition());
        }
        //when input values change call refreshMarker
        document.getElementById('tem_latitude').onchange = refreshMarker;
        document.getElementById('tem_longitude').onchange = refreshMarker;

        //when marker is dragged update input values
        marker.addListener('drag', function() {
            let latlng = marker.getPosition();
            let newlat=(Math.round(latlng.lat()*1000000))/1000000;
            let newlng=(Math.round(latlng.lng()*1000000))/1000000;
            document.getElementById('tem_latitude').value = newlat;
            document.getElementById('tem_longitude').value = newlng;
        });

        //When drag ends, center (pan) the map on the marker position
        marker.addListener('dragend', function() {
            map.panTo(marker.getPosition());
        });
    }
}
window.onload=function(){
    document.getElementById('btn-modal').addEventListener("click", save_location);
    function save_location() {
        let newlat= document.getElementById('tem_latitude').value;
        let newlng = document.getElementById('tem_longitude').value;
        document.getElementById('latitude').value = newlat;
        document.getElementById('longitude').value = newlng;
    }
}

