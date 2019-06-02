import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';
import 'package:worksent_sesfikile/repositories/manager/manager_repository.dart';

class ManagersBloc {
  final _managerRepository = ManagerRepository();

  final _managersSubject = PublishSubject<List<DriverModel>>();

  Stream<List<DriverModel>> get managersStream =>
      _managersSubject.stream.asBroadcastStream();

  ManagersBloc() {
    _managerRepository.getList().listen((QuerySnapshot snapshot) {
      _managersSubject.sink.add(snapshot.documents
          .map((documentSnapshot) => DriverModel.fromMap(documentSnapshot.data))
          .toList());
    }).onError((error) {
      print("error: $error");
    });
  }
}