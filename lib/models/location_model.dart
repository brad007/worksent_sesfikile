import 'dart:collection';

import 'package:flutter/services.dart';

class Coords {
  int floor;
  double latitude;
  double longitude;
  double accuracy;
  double altitude;
  double heading;
  double speed;
  double altitudeAccuracy;

  Coords(dynamic  coords) {

    this.latitude = coords['latitude'] * 1.0;
    this.longitude = coords['longitude'] * 1.0;
    this.accuracy = coords['accuracy'] * 1.0;
    this.altitude = coords['altitude'] * 1.0;
    this.heading = coords['heading'] * 1.0;
    this.speed = coords['speed'] * 1.0;
    if (coords['altitude_accuracy'] != null) {
      this.altitudeAccuracy = coords['altitude_accuracy'] * 1.0;
    }
    this.floor = coords['floor'];
  }
  String toString() {
    return 'coords: $latitude,$longitude, acy: $accuracy, spd: $speed';
  }
}

class Battery {
  bool isCharging;
  double level;

  Battery(dynamic  battery) {
    this.isCharging = battery['is_charging'];
    this.level = battery['level'] * 1.0;
  }
}

class Activity {
  String type;
  int confidence;

  Activity(dynamic  activity) {
    this.type = activity['type'];
    this.confidence = activity['confidence'];
  }
}

/// Geolocation event object provided to [BackgroundGeolocation.onLocation] and [BackgroundGeolocation.onMotionChange].
///
///
class LocationModel {
  dynamic map;

  /// Timestamp in __`ISO 8601` (UTC) format.
  ///
  /// Eg: `2018-01-01T12:00:01.123Z'.
  ///
  String timestamp;

  /// Event which caused this location to be recorded.
  ///
  /// `motionchange | heartbeat | providerchange`
  ///
  String event;

  /// __`[Android only]`__ `true` if the location was provided by a Mock location app.
  bool mock;

  /// `true` if this Location is just 1 of several samples before settling upon a final location.
  ///
  /// Multiple samples are requested when using [BackgroundGeolocation.getCurrentPosition] or when the plugin is performing a [BackgroundGeolocation.onMotionChange].
  /// If you're manually uploading locations to your server, you should __ignore__ those with `location.sample == true`.
  ///
  bool sample;

  /// The current distance traveled.
  ///
  /// __See also:__
  /// - [BackgroundGeolocation.setOdometer]
  /// - [BackgroundGeolocation.odometer]
  ///
  double odometer;

  /// `true` if this `Location` was recored while the device was in-motion.
  ///
  bool isMoving;

  /// Universally Unique Identifier.
  ///
  /// This property is helpful for debugging location issues.  It can be used to match locations recorded at your server with those within the plugin's [BackgroundGeolocation.log].
  ///
  String uuid;

  /// Location coordinates.
  Coords coords;


  /// Device battery-level when this 'Location' was recorded.
  Battery battery;

  /// Device motion-activity when this `Location` was recorded.
  Activity activity;

  Map extras;

  LocationModel(dynamic params) {
    this.map = params;
    
    // print("coords: ${Map<String, dynamic>.from(params)["location"]["coords"].toString()}");
    this.coords = new Coords(params['coords']);
    this.battery = new Battery(params['battery']);
    this.activity = new Activity(params['activity']);

    this.timestamp = params['timestamp'];
    this.isMoving = params['is_moving'];
    this.uuid = params['uuid'];
    this.odometer = params['odometer'] * 1.0;

    this.sample = (params['sample'] != null) ? params['sample'] : false;

    if (params['event'] != null) {
      this.event = params['event'];
    }
    if (params['mock'] != null) {
      this.mock = params['mock'];
    }
    if (params['extras'] != null) {
      this.extras = params['extras'];
    }
  }

  String toString({compact: bool}) {
    if (compact == true) {
      return '[Location ${DateTime.parse(timestamp).toLocal()}, isMoving: $isMoving, sample: $sample, $coords]';
    } else {
      return '[Location ${map.toString()}]';
    }
  }

  Map toMap() {
    return map;
  }
}

/// Location Error
///
/// ## Error Codes
///
/// | Code  | Error                       |
/// |-------|-----------------------------|
/// | 0     | Location unknown            |
/// | 1     | Location permission denied  |
/// | 2     | Network error               |
/// | 408   | Location timeout            |
///
class LocationError {
  int code;
  String message;

  LocationError(PlatformException e) {
    code = int.parse(e.code);
    message = e.message;
  }

  String toString() {
    return '[LocationError code: $code, message: $message]';
  }
}
