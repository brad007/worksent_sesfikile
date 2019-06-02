import 'package:worksent_sesfikile/models/company_model.dart';
import 'package:worksent_sesfikile/models/model.dart';

class UserModel extends Model {
  String email;
  String fullName;
  String workNumber;
  String companyName;
  String companyAddress;

  UserModel(String userId, int dateCreated, int dateUpdated,
      {this.email, this.fullName, this.workNumber})
      : super(userId, dateCreated, dateUpdated);

  UserModel.map(dynamic obj) : super.map(obj) {
    this.id = obj['userId'];
    this.email = obj['email'];
    this.fullName = obj['fullName'];
    this.workNumber = obj['workNumber'];
    this.companyName = obj['companyName'];
    this.companyAddress = obj['companyAddress'];
    this.dateCreated = obj['dateCreated'];
    this.dateUpdated = obj['dateUpdated'];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['userId'] = this.id;
    map['email'] = email;
    map['fullName'] = fullName;
    map['workNumber'] = workNumber;
    map['companyName'] = companyName;
    map['companyAddress'] = companyAddress;
    map['dateCreated'] = dateCreated;
    map['dateUpdated'] = dateUpdated;

    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    this.id = map['userId'];
    this.email = map['email'];
    this.fullName = map['fullName'];
    this.workNumber = map['workNumber'];
    this.companyName = map['companyName'];
    this.companyAddress = map['companyAddress'];
    this.dateCreated = map['dateCreated'];
    this.dateUpdated = map['dateUpdated'];
  }
}
