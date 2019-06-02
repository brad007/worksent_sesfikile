import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';
import 'package:worksent_sesfikile/repositories/vehicle/vehicle_repository.dart';

class VehiclesBloc {
  final _vehicleRepository = VehicleRepository();

  final _vehiclesSubject = PublishSubject<List<VehicleModel>>();

  Stream<List<VehicleModel>> get driversStream =>
      _vehiclesSubject.stream.asBroadcastStream();

  VehiclesBloc() {
    _vehicleRepository.getList().listen((QuerySnapshot snapshot) {
      _vehiclesSubject.sink.add(snapshot.documents
          .map((documentSnapshot) => VehicleModel.fromMap(documentSnapshot.data))
          .toList());
    }).onError((error) {
      print("error: $error");
    });
  }
}