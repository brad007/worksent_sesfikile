import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worksent_sesfikile/models/company_model.dart';
import 'package:worksent_sesfikile/models/model.dart';

abstract class Repository<T extends Model, S extends Model> {
  Firestore _firestore = Firestore.instance;

  CollectionReference getCollection(
      Firestore _firestore, S model, CompanyModel company);

  DocumentReference getDocument(
      Firestore _firestore, T model, S sModel, CompanyModel company);

  T fromMap(Map<String, dynamic> mapData);

  Future<T> create(T model, S sModel, CompanyModel company) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(getDocument(_firestore, model, sModel, company));
      await tx.set(ds.reference, model.toMap());

      return model.toMap();
    };

    return _firestore.runTransaction(createTransaction).then((mapData) {
      return fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getList(
  {CompanyModel company, S model, int offset, int limit}) {
    Stream<QuerySnapshot> snapshots =
        getCollection(_firestore, model, company).snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Stream<QuerySnapshot> search(
      CompanyModel company, S model, String field, String query) {
    Stream<QuerySnapshot> snapshots = getCollection(_firestore, model, company)
        .where(field, isEqualTo: query)
        .snapshots();
    return snapshots;
  }

  Stream<DocumentSnapshot> get(CompanyModel company, S model, String id) {
    Stream<DocumentSnapshot> snapshots =
        getCollection(_firestore, model, company).document(id).snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getLatest(CompanyModel company, S model, String field) {
    Query snapshots = getCollection(_firestore, model, company)
        .orderBy(field, descending: true)
        .limit(1);

    return snapshots.snapshots();
  }

  Future<dynamic> update(CompanyModel company, T model, S sModel) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx
          .get(getCollection(_firestore, sModel, company).document(model.id));

      var date = DateTime.now().millisecondsSinceEpoch;
      model.dateUpdated = date;

      print("model: ${model.toMap()}");
      await tx.update(ds.reference, model.toMap());
      return {'updated': true};
    };

    return _firestore
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print(('error: $error'));
      return {'updated': false};
    });
  }

  Future<dynamic> delete(CompanyModel company, S model, String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(getCollection(_firestore, model, company).document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return _firestore
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
      return {'deleted': false};
    });
  }
}
