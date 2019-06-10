import 'package:worksent_sesfikile/models/location_model.dart';
import 'dart:math' as math;

class Utils{
  static bool emailIsValid(String email) {
    return RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(email);
  }

 

  static double _degreesToRadians(double degrees){
    return degrees * math.pi / 180;
  }

  static double getDistanceBetween(Coords startLocation, Coords endLocation){
    var earthRadiusKM = 6371;
    var dLat = _degreesToRadians(endLocation.latitude - startLocation.latitude);
    var dLon = _degreesToRadians(endLocation.longitude - startLocation.longitude);

    var startLatitude = _degreesToRadians(startLocation.latitude) ;
    var endLatitude = _degreesToRadians(endLocation.latitude);

    var a = math.sin(dLat/2) * math.sin(dLat/2) + 
            math.sin(dLon/2) * math.sin(dLon/2) * math.cos(startLatitude)*math.cos(endLatitude);
  
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a));
    return earthRadiusKM  * c;
  }

}

// function degreesToRadians(degrees) {
//   return degrees * Math.PI / 180;
// }

// function distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
//   var earthRadiusKm = 6371;

//   var dLat = degreesToRadians(lat2-lat1);
//   var dLon = degreesToRadians(lon2-lon1);

//   lat1 = degreesToRadians(lat1);
//   lat2 = degreesToRadians(lat2);

//   var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
//           Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
//   var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
//   return earthRadiusKm * c;
// }