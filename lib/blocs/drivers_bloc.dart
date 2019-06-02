import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/repositories/auth/auth_repository.dart';
import 'package:worksent_sesfikile/repositories/driver/driver_repository.dart';

class DriversBloc {
  final _driverRepository = DriverRepository();
  final _authRepository = AuthRepository();

  final _driversSubject = PublishSubject<List<DriverModel>>();

  Stream<List<DriverModel>> get driversStream =>
      _driversSubject.stream.asBroadcastStream();

  DriversBloc() {
    _authRepository.getUser().then((user) {
      _driverRepository
          .getList(user.companyName)
          .listen((QuerySnapshot snapshot) {
        _driversSubject.sink.add(snapshot.documents
            .map((documentSnapshot) =>
                DriverModel.fromMap(documentSnapshot.data))
            .toList());
      }).onError((error) {
        print("error: $error");
      });
    });
  }
}
