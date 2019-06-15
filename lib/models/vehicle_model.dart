import 'package:owner/models/driver_model.dart';
import 'package:owner/models/model.dart';

class VehicleModel extends Model {
  String vehicleType;
  String brand;
  String numberPlate;
  String year;
  String pictureUrl;
  String branch;
  String currentKMs;
  String vehicleStorageAddress;
  String insuranceCompany;
  String vehicleRegistrationNumber;
  String company;
  DriverModel driver;

  VehicleModel(String id,
      {this.vehicleType,
      this.brand,
      this.numberPlate,
      this.year,
      this.branch,
      this.currentKMs,
      this.vehicleStorageAddress,
      this.insuranceCompany,
      this.company,
      this.vehicleRegistrationNumber,
      this.driver
      })
      : super(id, DateTime.now().millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch);

  VehicleModel.map(dynamic obj) : super.map(obj) {
    this.vehicleType = obj['vehicleType'];
    this.brand = obj['brand'];
    this.numberPlate = obj['numberPlate'];
    this.year = obj['year'];
    this.pictureUrl = obj['pictureUrl'];
    this.branch = obj['branch'];
    this.currentKMs = obj['currentKMs'];
    this.vehicleStorageAddress = obj['vehicleStorageAddress'];
    this.insuranceCompany = obj['insuranceCompany'];
    this.vehicleRegistrationNumber = obj['vehicleRegistrationNumber'];
    this.company = obj['company'];
    
    if(obj.containsKey('driver') && obj['driver'] != null){
      this.driver = DriverModel.map(obj['driver']);
    }else{
      this.driver = null;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['vehicleType'] = this.vehicleType;
    map['brand'] = this.brand;
    map['numberPlate'] = this.numberPlate;
    map['year'] = this.year;
    map['pictureUrl'] = this.pictureUrl;
    map['branch'] = this.branch;
    map['currentKMs'] = this.currentKMs;
    map['vehicleStorageAddress'] = this.vehicleStorageAddress;
    map['insuranceCompany'] = this.insuranceCompany;
    map['vehicleRegistrationNumber'] = this.vehicleRegistrationNumber;
    map['company'] = this.company;
    if(this.driver != null){
      map['driver'] = this.driver.toMapWithoutVehicle();
    }else{
      map['driver'] = null;
    }
    return map;
  }

  Map<String, dynamic> toMapWithoutDriver() {
    var map = Map<String, dynamic>();
    map['vehicleType'] = this.vehicleType;
    map['brand'] = this.brand;
    map['numberPlate'] = this.numberPlate;
    map['year'] = this.year;
    map['pictureUrl'] = this.pictureUrl;
    map['branch'] = this.branch;
    map['currentKMs'] = this.currentKMs;
    map['vehicleStorageAddress'] = this.vehicleStorageAddress;
    map['insuranceCompany'] = this.insuranceCompany;
    map['vehicleRegistrationNumber'] = this.vehicleRegistrationNumber;
    map['company'] = this.company;
    return map;
  }

  VehicleModel.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    this.id = map['id'];
    this.vehicleType = map['vehicleType'];
    this.brand = map['brand'];
    this.numberPlate = map['numberPlate'];
    this.year = map['year'];
    this.pictureUrl = map['pictureUrl'];
    this.branch = map['branch'];
    this.currentKMs = map['currentKMs'];
    this.vehicleStorageAddress = map['vehicleStorageAddress'];
    this.insuranceCompany = map['insuranceCompany'];
    this.vehicleRegistrationNumber = map['vehicleRegistrationNumber'];
    this.company = map['company'];
    if(map.containsKey('driver') && map['driver'] != null){
      this.driver = DriverModel.map(map['driver']);
    }else{
      map['driver'] = null;
    }
  }
}
