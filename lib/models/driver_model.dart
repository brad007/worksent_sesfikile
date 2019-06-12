import 'package:worksent_sesfikile/models/location_model.dart';
import 'package:worksent_sesfikile/models/model.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';

class DriverModel extends Model {
  String firstName;
  String lastName;
  String mobileNumber;
  String email;
  String driversLicenseUrl;
  String pdpLicenseUrl;
  String pdpExpireDate;
  String branch;
  String driversLicenseExpireDate;
  String company;
  String imageUrl;
  VehicleModel vehicle;
  LocationModel location;

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
      this.location
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
    
    if(obj.containsKey('vehicle') && obj['vehicle'] != null){
      this.vehicle = VehicleModel.map(obj['vehicle']);
    }else{
      this.vehicle = null;
    }

    if(obj.containsKey('location') && obj['location'] != null){
      this.location = LocationModel(obj['location']);
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
    if(this.vehicle != null){
      map['vehicle'] = this.vehicle.toMapWithoutDriver();
    }else{
      map['vehicle'] = null;
    }

    if(this.location != null){
      map['location'] = this.location.map;
    }else{
      map['location'] = null;
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
    return map;
  }



  DriverModel.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    print("location_2: ${map}");
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
    if(map.containsKey('vehicle') && map['vehicle'] != null){
      this.vehicle = VehicleModel.map(map['vehicle']);
    }else{
      this.vehicle = null;
    }

    if(map['location'] != null){
      this.location = LocationModel(map['location']);
    }
  }
}
