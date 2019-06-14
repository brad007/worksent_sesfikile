import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:worksent_sesfikile/models/location_model.dart';
import 'dart:math' as math;

import 'package:worksent_sesfikile/pages/profile_image_camera.dart';

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

  static Future<dynamic> loadImage(BuildContext context) async{
        final editResult = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileEditCamera()));
          if (editResult != null) {

            print("downloadUrl: 2");
          Directory appDocDir = await getApplicationDocumentsDirectory();
          final directoryPath = "${appDocDir.path}/profile_images";
          final thumbnailPath = "$directoryPath/thumbnail.jpg";
          final thumbnailFile = await FlutterImageCompress.compressAndGetFile(
              editResult.path, thumbnailPath,
              minWidth: 250);

          print("downloadUrl: 3");
          final imageFileName = Uuid().v1();
          final StorageReference storageRef = FirebaseStorage.instance
              .ref()
              .child("profile_images")
              .child(imageFileName);

          print("downloadUrl: 3");
          final StorageUploadTask uploadTask =
              storageRef.putFile(thumbnailFile);

          print("downloadUrl: 4");
          final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
          print("downloadUrl: 5");
          return downloadUrl.ref.getDownloadURL();
    }else{
      return null;
    }
  }

  static bool isTaxiAssociation(String branch){
    return [
            "CODETA",
            "CATA",
            "UNCEDO",
            "Mitchelle's Plain",
            "BOLAND",
            "EDEN",
            "GREATER CAPE",
            "NORTHERNS",
            "TWO OCEANS",
            "WEST COAST"
          ].contains(branch);
  }

  static double calculateBearing(Coords first, Coords second){
    
    var deltaLong = second.longitude - first.longitude;
    var x = math.cos(second.latitude)*math.sin(deltaLong);
    var y = math.cos(first.latitude)*math.sin(second.latitude) - 
            math.sin(first.latitude)*math.cos(second.latitude)*math.cos(deltaLong);

    var bearing = math.atan2(x,y);
    var degrees = (bearing*(180/math.pi))%360;
    print("degrees $degrees");
    return degrees;
  }
}
