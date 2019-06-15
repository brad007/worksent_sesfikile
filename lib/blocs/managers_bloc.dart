import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/repositories/auth/auth_repository.dart';
import 'package:owner/repositories/manager/manager_repository.dart';

class ManagersBloc {
  final _managerRepository = ManagerRepository();
  final _authRepository = AuthRepository();

  final _managersSubject = PublishSubject<List<DriverModel>>();

  Stream<List<DriverModel>> get managersStream =>
      _managersSubject.stream.asBroadcastStream();

  ManagersBloc() {
    _authRepository.getUser().then((user) {
      _managerRepository
          .getList(user.companyName)
          .listen((QuerySnapshot snapshot) {
        _managersSubject.sink.add(snapshot.documents
            .map((documentSnapshot) =>
                DriverModel.fromMap(documentSnapshot.data))
            .toList());
      }).onError((error) {
        print("error: $error");
      });
    });
  }
}
