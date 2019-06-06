import 'package:worksent_sesfikile/models/model.dart';

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
      this.driversLicenseExpireDate})
      : super(id, DateTime.now().millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch);

  DriverModel.map(dynamic obj) : super.map(obj) {
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
    return map;
  }


  DriverModel.fromMap(Map<String, dynamic> map): super.fromMap(map){
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
  }


}
