import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owner/models/company_model.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/models/user_model.dart';

import '../repository.dart';

class ManagerRepository extends Repository<DriverModel, DriverModel> {
  final rootNode = "managers";

  @override
  DriverModel fromMap(Map<String, dynamic> mapData) {
    return DriverModel.fromMap(mapData);
  }

  @override
  CollectionReference getCollection(
      Firestore _firestore, DriverModel model, CompanyModel company) {
    return _firestore.collection(rootNode);
  }

  @override
  DocumentReference getDocument(Firestore _firestore, DriverModel model,
      DriverModel sModel, CompanyModel company) {
    return _firestore.collection(rootNode).document();
    ;
  }
}
