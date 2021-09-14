let map;
let markers = [];
const labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
let labelIndex = 0;

if (document.readyState === "complete" || (document.readyState !== "loading" && !document.documentElement.doScroll)) {
	callback();
}else{
	document.addEventListener("DOMContentLoaded", callback);
}

function callback(){
	let apiBtn = document.querySelector("#btn");
	apiBtn.addEventListener("click", geocode);
	window.addEventListener("keydown", submitInput);
	initMap();
};

function initMap() {
	map = new google.maps.Map(document.getElementById("map"), {
		center: { lat: 37.8283, lng: -98.5795 },
		zoom: 4.5,
		disableDefaultUI: true,
	});
}

function submitInput(event) {
    if (event.code !== "Enter") return;
	deleteMarkers();
    geocode();
}

function geocode() {
    let input = document.querySelector("input[type=text]");
    let searchQuery = input.value.toLowerCase();
    if (!input.value) return;
    input.value = "";

    const ajaxRequest = new XMLHttpRequest();
    
    ajaxRequest.addEventListener("readystatechange", function () {
        if (this.readyState == 4 && this.status == 200){
            let response = this.responseText;       
            response = JSON.parse(response);
            populate(response);
            console.log(this.responseText);
        }
    });
    
    ajaxRequest.open("GET", "https://google-maps-geocoding.p.rapidapi.com/geocode/json?address=" + searchQuery + "&language=en");
    ajaxRequest.setRequestHeader("x-rapidapi-host", "google-maps-geocoding.p.rapidapi.com");
    ajaxRequest.setRequestHeader("x-rapidapi-key", "dfc44dc3f6msh2108a8ca0b7dcc8p1d6123jsn769e856fad88");
    ajaxRequest.send();
}

function populate(requestData){
 	let lat = parseFloat(requestData.results[0].geometry.location.lat);
    let lng = parseFloat(requestData.results[0].geometry.location.lng);
	var center = {lat: +lat, lng: +lng};
	
	map.setCenter(center);
	
	for(let i = 0; i < lats.length; i++) {
		if((lats[i] >= SWLat && lats[i] <= NELat) && (lngs[i] >= SWLng && lngs[i] <= NELng)) {
			const contentString =
				'<div id="content">' +
				'<div id="siteNotice">' +
				"</div>" +
				'<h1 id="firstHeading" class="firstHeading">Restaurant ' + i + '</h1>' +
				'<div id="bodyContent">' + '<img src="madonal storefront.jpg"/>' +
				"</div>" +
				"</div>";
			drawMarkers(lats[i], lngs[i], contentString);
		}
	}
	map.setZoom(13);
}

function drawMarkers(lat, lng, contentString){
	var markerPoint = {lat: +lat, lng: +lng};
	
	const infowindow = new google.maps.InfoWindow({content: contentString,});
	const marker = new google.maps.Marker({
		position: markerPoint,
		map,
		label: labels[labelIndex++ % labels.length],
	});
	
	marker.addListener("click", () => {infowindow.open({anchor: marker, map, shouldFocus: false,});});
	
	markers.push(marker);
}

function hideMarkers() {
	for (let i = 0; i < markers.length; i++) {
		markers[i].setMap(null);
	}
}

function deleteMarkers() {
	hideMarkers();
	markers = [];
}