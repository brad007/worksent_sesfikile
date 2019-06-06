import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/repositories/driver/driver_repository.dart';

class DriverBloc{
  var _driverRepository = DriverRepository();
  DriverBloc(){
  }

  updateDriverInfo(DriverModel model){
    _driverRepository.update(null, model, model);
  }
}