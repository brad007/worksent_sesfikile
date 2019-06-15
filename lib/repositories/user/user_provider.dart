import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owner/models/user_model.dart';

class UserProvider {
  Firestore _firestore = Firestore.instance;

  Future<UserModel> createUser({UserModel user}) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
      await tx.get(_firestore.collection('users').document('${user.email}'));

      var dataMap = user.toMap();

      await tx.set(ds.reference, dataMap);

      return dataMap;
    };

    return _firestore.runTransaction(createTransaction).then((mapData) {
      return UserModel.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Future<UserModel> getUser(String email){
    return _firestore.collection("users").document(email).get().then((documentSnapshot){
      return UserModel.fromMap(documentSnapshot.data);
    });
  }

  Future<dynamic> updateUser({UserModel user}) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
      await tx.get(_firestore.collection('users').document(user.email));

      await tx.update(ds.reference, user.toMap());
      return {'updated': true};
    };

    return _firestore
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return {'updated': false};
    });
  }

}
