import 'package:owner/models/driver_model.dart';
import 'package:owner/models/vehicle_model.dart';
import 'package:owner/repositories/vehicle/vehicle_repository.dart';

class VehicleBloc{
  var _vehicleRepository = VehicleRepository();
  VehicleBloc(){
  }

  updateVehicleInfo(VehicleModel model){
    _vehicleRepository.update(null, model, model);
  }
}