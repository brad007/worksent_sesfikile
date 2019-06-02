import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worksent_sesfikile/models/company_model.dart';
import 'package:worksent_sesfikile/models/user_model.dart';
import 'package:worksent_sesfikile/repositories/repository.dart';

class UserRepository extends Repository<UserModel, UserModel> {
  final rootNode = "users";

  @override
  UserModel fromMap(Map<String, dynamic> mapData) {
    // TODO: implement fromMap
    return UserModel.fromMap(mapData);
  }

  @override
  CollectionReference getCollection(
      Firestore _firestore, UserModel model, CompanyModel company) {
    return _firestore.collection(rootNode);
  }

  @override
  DocumentReference getDocument(Firestore _firestore, UserModel model,
      UserModel sModel, CompanyModel company) {
    return _firestore.collection(rootNode).document(model.email);
  }
}
