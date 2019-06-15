import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:owner/models/vehicle_model.dart';
import 'package:owner/repositories/auth/auth_repository.dart';
import 'package:owner/repositories/vehicle/vehicle_repository.dart';

class VehiclesBloc {
  final _vehicleRepository = VehicleRepository();
  final _authRepository = AuthRepository();

  final _vehiclesSubject = PublishSubject<List<VehicleModel>>();

  Stream<List<VehicleModel>> get vehiclesStream =>
      _vehiclesSubject.stream.asBroadcastStream();

  VehiclesBloc() {
    _authRepository.getUser().then((user) {
      _vehicleRepository
          .getList(user.companyName)
          .listen((QuerySnapshot snapshot) {
        _vehiclesSubject.sink.add(snapshot.documents
            .map((documentSnapshot) =>
                VehicleModel.fromMap(documentSnapshot.data))
            .toList());
      }).onError((error) {
        print("error: $error");
      });
    });
  }
}
