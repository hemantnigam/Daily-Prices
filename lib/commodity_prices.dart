import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';

class CommodityPrices {
  Map result = {};

  Future<void> getData() async {
    var datetime = new DateTime.now().millisecondsSinceEpoch;
    Response response = await get(
        "https://toibnews.timesofindia.indiatimes.com/marketing/homepagedatanew.json?callback=marketlivedata&_=$datetime");
    var responseBody = response.body.toString();
    Map decodeData = json.decode(responseBody.substring(
        responseBody.indexOf('[') + 1, responseBody.lastIndexOf(']')));
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        position.latitude, position.longitude);
    Placemark place = p[0];
    String locality = place.locality;

    List cities = [
      "MUMBAI",
      "DELHI",
      "BANGALORE",
      "HYDERABAD",
      "KOLKATA",
      "CHENNAI",
      "AGARTALA",
      "AGRA",
      "AJMER",
      "AMARAVATI",
      "AHMEDABAD",
      "ALLAHABAD",
      "AMRITSAR",
      "AURANGABAD",
      "BAREILLY",
      "BHOPAL",
      "BHUBANESWAR",
      "CHANDIGARH",
      "COIMBATORE",
      "CUTTACK",
      "DEHRADUN",
      "ERODE",
      "FARIDABAD",
      "GHAZIABAD",
      "GOA",
      "GURGAON",
      "GUWAHATI",
      "HUBBALLI",
      "IMPHAL",
      "INDORE",
      "ITANAGAR",
      "JAIPUR",
      "JAMMU",
      "JAMSHEDPUR",
      "JODHPUR",
      "KANPUR",
      "KOCHI",
      "KOHIMA",
      "KOLHAPUR",
      "KOZHIKODE",
      "LUCKNOW",
      "LUDHIANA",
      "MADURAI",
      "MANGALORE",
      "MEERUT",
      "MYSORE",
      "NAGPUR",
      "NASHIK",
      "NAVI MUMBAI",
      "NOIDA",
      "PATNA",
      "PUDUCHERRY",
      "PUNE",
      "RAIPUR",
      "RAJKOT",
      "RANCHI",
      "SRINAGAR",
      "SALEM",
      "SHILLONG",
      "SHIMLA",
      "SURAT",
      "THANE",
      "TRICHY",
      "THIRUVANANTHAPURAM",
      "UDAIPUR",
      "VADODARA",
      "VARANASI",
      "VIJAYAWADA",
      "VISAKHAPATNAM"
    ];

    if (!cities.contains(locality)) {
      locality = "Delhi";
    }
    
    Response weatherResponse = await get(
        "http://api.weatherapi.com/v1/current.json?key=89ff3b7718a94d7590e65932200707&q=${position.latitude},${position.longitude}");
    Map data = jsonDecode(weatherResponse.body);
    Map weatherData = {
      "country": "",
      "region": "",
      "temperature": "",
      "weather_icons": "",
      "weather_descriptions": ""
    };
    weatherData['country'] = data['location']['country'];
    weatherData['region'] = data['location']['region'];
    weatherData['temperature'] = data['current']['temp_c'];
    weatherData['weather_icons'] = data['current']['condition']['icon'];
    weatherData['weather_descriptions'] = data['current']['condition']['text'];

    Response fuelPriceResponse = await get(
        "https://toibnews.timesofindia.indiatimes.com/fuelprice/${locality.toString().toLowerCase()}-fuelprice");
    Map fuelPrice = jsonDecode(fuelPriceResponse.body)[0];

    result = {
      "decodedData": decodeData,
      "weatherData": weatherData,
      "fuelPrice": fuelPrice
    };
  }
}
