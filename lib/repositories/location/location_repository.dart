import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owner/models/driver_model.dart';

class LocationRepository{
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getList(){
    final now = DateTime.now();

    final startOfDay = now.subtract(Duration(
    hours: now.hour,
    minutes: now.minute,
    seconds: now.second,
    milliseconds: now.millisecond,
    microseconds: now.microsecond,
    ));

    final endOfday = startOfDay.add(Duration(days: 1));

    
    Stream<QuerySnapshot> snapshots = _firestore.collection("locations")
    // .where("timestamp", 
    // isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
    // isLessThanOrEqualTo: endOfday.toIso8601String())
      .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getDateList(DateTime date, DriverModel driver){
    
    date = date.add(Duration(hours: 2));
    final startDateTime = date.subtract(Duration(
    hours: date.hour,
    minutes: date.minute,
    seconds: date.second,
    milliseconds: date.millisecond,
    microseconds: date.microsecond,
    ));

    final endDay = startDateTime.add(Duration(days: 1)).toIso8601String();
    final startDate = startDateTime.toIso8601String();
    Stream<QuerySnapshot> snapshots = _firestore.collection("locations").document(driver.email).collection("location")
    .where("location.timestamp", 
    isGreaterThanOrEqualTo: startDate,
    isLessThanOrEqualTo: endDay)
    .snapshots();

    return snapshots;
  }
}