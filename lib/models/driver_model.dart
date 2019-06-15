import 'package:owner/models/location_model.dart';
import 'package:owner/models/model.dart';
import 'package:owner/models/vehicle_model.dart';

class DriverModel extends Model {
  String firstName;
  String lastName;
  String mobileNumber;
  String email;
  String driversLicenseUrl;
  String pdpLicenseUrl;
  String pdpLicense;
  String pdpExpireDate;
  String branch;
  String driversLicenseExpireDate;
  String driversLicense;
  String company;
  String imageUrl;
  VehicleModel vehicle;
  LocationModel location;
  LocationModel previousLocation;
  bool clockedIn;

  DriverModel(String id,
      {this.firstName,
      this.lastName,
      this.mobileNumber,
      this.email,
      this.driversLicenseUrl,
      this.pdpLicenseUrl,
      this.pdpExpireDate,
      this.branch,
      this.company,
      this.imageUrl,
      this.driversLicenseExpireDate,
      this.vehicle,
      this.location,
      this.previousLocation,
      this.clockedIn,
      this.driversLicense,
      this.pdpLicense
      })
      : super(id, DateTime.now().millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch);

  DriverModel.map(dynamic obj) : super.map(obj) {
    print("location_1: ${obj}");
    this.firstName = obj['firstName'];
    this.lastName = obj['lastName'];
    this.mobileNumber = obj['mobileNumber'];
    this.email = obj['email'];
    this.driversLicenseUrl = obj['driversLicenseUrl'];
    this.pdpLicenseUrl = obj['pdpLicenseUrl'];
    this.pdpExpireDate = obj['pdpExpireDate'];
    this.branch = obj['branch'];
    this.driversLicenseExpireDate = obj['driversLicenseExpireDate'];
    this.company = obj['company'];
    this.imageUrl = obj['imageUrl'];
    this.clockedIn = obj['clockedIn'];
    this.driversLicense = obj['driversLicense'];
    this.pdpLicense = obj['pdpLicense'];
    if(obj.containsKey('vehicle') && obj['vehicle'] != null){
      this.vehicle = VehicleModel.map(obj['vehicle']);
    }else{
      this.vehicle = null;
    }

    if(obj.containsKey('location') && obj['location'] != null){
      this.location = LocationModel(obj['location']);
    }else{
      this.location = null;
    }

    if(obj.containsKey('previousLocation') && obj['previousLocation'] != null){
      this.previousLocation = LocationModel(obj['previousLocation']);
    }else{
      this.previousLocation = null;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['firstName'] = this.firstName;
    map['lastName'] = this.lastName;
    map['mobileNumber'] = this.mobileNumber;
    map['email'] = this.email;
    map['driversLicenseUrl'] = this.driversLicenseUrl;
    map['pdpLicenseUrl'] = this.pdpLicenseUrl;
    map['pdpExpireDate'] = this.pdpExpireDate;
    map['branch'] = this.branch;
    map['driversLicenseExpireDate'] = this.driversLicenseExpireDate;
    map['company'] = this.company;
    map['imageUrl'] = this.imageUrl;
    map['clockedIn'] = this.clockedIn;
    map['driversLicense'] = this.driversLicense;
    map['pdpLicense'] = this.pdpLicense;
    if(this.vehicle != null){
      map['vehicle'] = this.vehicle.toMapWithoutDriver();
    }else{
      map['vehicle'] = null;
    }

    if(this.location != null){
      map['location'] = this.location.map;
    }else{
      map['vehicle'] = null;
    }

    if(this.previousLocation != null){
      map['previousLocation'] = this.previousLocation.map;
    }else{
      map['vehicle'] = null;
    }
    return map;
  }

  Map<String, dynamic> toMapWithoutVehicle() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['firstName'] = this.firstName;
    map['lastName'] = this.lastName;
    map['mobileNumber'] = this.mobileNumber;
    map['email'] = this.email;
    map['driversLicenseUrl'] = this.driversLicenseUrl;
    map['pdpLicenseUrl'] = this.pdpLicenseUrl;
    map['pdpExpireDate'] = this.pdpExpireDate;
    map['branch'] = this.branch;
    map['driversLicenseExpireDate'] = this.driversLicenseExpireDate;
    map['company'] = this.company;
    map['imageUrl'] = this.imageUrl;
    map['location'] = this.location;
    map['previousLocation'] = this.previousLocation;
    map['clockedIn'] = this.clockedIn;
    map['driversLicense'] = this.driversLicense;
    map['pdpLicense'] = this.pdpLicense;
    return map;
  }



  DriverModel.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    this.id = map['id'];
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.mobileNumber = map['mobileNumber'];
    this.email = map['email'];
    this.driversLicenseUrl = map['driversLicenseUrl'];
    this.pdpLicenseUrl = map['pdpLicenseUrl'];
    this.pdpExpireDate = map['pdpExpireDate'];
    this.branch = map['branch'];
    this.driversLicenseExpireDate = map['driversLicenseExpireDate'];
    this.company = map['company'];
    this.imageUrl = map['imageUrl'];
    this.driversLicense = map['driversLicense'];
    this.pdpLicense = map['pdpLicense'];
    this.clockedIn = map['clockedIn'];

    if(map.containsKey('vehicle') && map['vehicle'] != null){
      this.vehicle = VehicleModel.map(map['vehicle']);
    }else{
      this.vehicle = null;
    }

    if(map['location'] != null){
      this.location = LocationModel(map['location']);
    }else{
      this.location = null;
    }

    if(map['previousLocation'] != null){
      this.previousLocation = LocationModel(map['previousLocation']);
    }else{
      this.previousLocation = null;
    }
  }
}
