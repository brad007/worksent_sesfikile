import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';
import 'package:worksent_sesfikile/repositories/vehicle/vehicle_repository.dart';

class VehicleBloc{
  var _vehicleRepository = VehicleRepository();
  VehicleBloc(){
  }

  updateVehicleInfo(VehicleModel model){
    _vehicleRepository.update(null, model, model);
  }
}