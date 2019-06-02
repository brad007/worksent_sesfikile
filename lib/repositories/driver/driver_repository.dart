import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worksent_sesfikile/models/company_model.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/repositories/repository.dart';

class DriverRepository extends Repository<DriverModel, DriverModel> {
  final rootNode = "drivers";

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
  }
}
