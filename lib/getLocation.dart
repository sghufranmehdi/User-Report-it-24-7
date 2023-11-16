import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

var firstLocation;
var cordinates;

getCurrentLocation() async {
  Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  cordinates = position;
  print(cordinates.latitude);
  print(cordinates.longitude);
  getAddressFormCordinates(
      Coordinates(cordinates.latitude, cordinates.longitude));
  // return firstLocation;
}

getAddressFormCordinates(Coordinates cords) async {
  var addresses = await Geocoder.local.findAddressesFromCoordinates(cords);
  firstLocation = addresses.first;
  print(" ${firstLocation.addressLine}");
}
