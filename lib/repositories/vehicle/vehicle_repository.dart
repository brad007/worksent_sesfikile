import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owner/models/company_model.dart';
import 'package:owner/models/vehicle_model.dart';
import 'package:owner/repositories/repository.dart';

class VehicleRepository extends Repository<VehicleModel, VehicleModel> {
  final rootNode = "vehicles";

  @override
  VehicleModel fromMap(Map<String, dynamic> mapData) {
    // TODO: implement fromMap
    return VehicleModel.fromMap(mapData);
  }

  @override
  CollectionReference getCollection(
      Firestore _firestore, VehicleModel model, CompanyModel company) {
    // TODO: implement getCollection
    return _firestore.collection(rootNode);
  }

  @override
  DocumentReference getDocument(Firestore _firestore, VehicleModel model,
      VehicleModel sModel, CompanyModel company) {
    // TODO: implement getDocument
    return _firestore.collection(rootNode).document();
  }
}
