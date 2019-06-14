import 'package:rxdart/rxdart.dart';
import 'package:worksent_sesfikile/models/vehicle_data.dart';
import 'package:worksent_sesfikile/irrelevant.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';
import 'package:worksent_sesfikile/repositories/auth/auth_repository.dart';
import 'package:worksent_sesfikile/repositories/vehicle/vehicle_repository.dart';

class AddVehicleBloc {
  final _vehicleRepository = VehicleRepository();
  final _authRepository = AuthRepository();

  //subject
  final _vehicleTypeSubject = BehaviorSubject<String>();
  final _brandSubject = BehaviorSubject<String>();
  final _numberPlateSubject = BehaviorSubject<String>();
  final _yearSubject = BehaviorSubject<String>();
  final _branchSubject = BehaviorSubject<String>();
  final _currentKMSubject = BehaviorSubject<String>();
  final _vehicleAddressSubject = BehaviorSubject<String>();
  final _insuranceCompanySubject = BehaviorSubject<String>.seeded("");
  final _vehicleRegisterationSubject = BehaviorSubject<String>();

  final _createVehicleSubject = PublishSubject<Irrelevant>();
  final _vehicleCreatedSubject = BehaviorSubject<Irrelevant>();

  final _enableButton = BehaviorSubject<bool>.seeded(false);
  final _showLoader = BehaviorSubject<bool>.seeded(false);

  //error-subjects
  final _vehicleTypeError = BehaviorSubject<String>();
  final _brandError = BehaviorSubject<String>();
  final _numberPlateError = BehaviorSubject<String>();
  final _yearError = BehaviorSubject<String>();
  final _branchError = BehaviorSubject<String>();
  final _currentKMError = BehaviorSubject<String>();
  final _vehicleAddressError = BehaviorSubject<String>();
  final _vehicleRegisterationError = BehaviorSubject<String>();

  //functions
  Function(String) get vehicleTypeChanged => _vehicleTypeSubject.sink.add;

  Function(String) get brandChanged => _brandSubject.sink.add;

  Function(String) get numberPlateChanged => _numberPlateSubject.sink.add;

  Function(String) get yearChanged => _yearSubject.sink.add;

  Function(String) get branchChanged => _branchSubject.sink.add;

  Function(String) get currentKMChanged => _currentKMSubject.sink.add;

  Function(String) get vehicleAddressChanged => _vehicleAddressSubject.sink.add;

  Function(String) get insuranceCompanyChanged =>
      _insuranceCompanySubject.sink.add;

  Function(String) get vehicleRegistrationChanged =>
      _vehicleRegisterationSubject.sink.add;

  Function(Irrelevant) get createVehiclePressed =>
      _createVehicleSubject.sink.add;

  //streams
  Stream<String> get vehicleTypeStream => _vehicleTypeSubject.stream;

  Stream<String> get brandStream => _brandSubject.stream;

  Stream<String> get numberPlateStream => _numberPlateSubject.stream;

  Stream<String> get yearStream => _yearSubject.stream;

  Stream<String> get branchStream => _branchSubject.stream;

  Stream<String> get currentKMStream => _currentKMSubject.stream;

  Stream<String> get vehicleAddressStream => _vehicleAddressSubject.stream;

  Stream<String> get insuranceCompanyStream => _insuranceCompanySubject.stream;

  Stream<String> get vehicleRegistrationStream =>
      _vehicleRegisterationSubject.stream;

  Stream<bool> get enableButton => _enableButton.stream;

  Stream<bool> get showLoader => _showLoader.stream;

  Stream<Irrelevant> get vehicleCreatedStream => _createVehicleSubject.stream;

  Stream<Irrelevant> get vehicleCreateStream => _vehicleCreatedSubject.stream;

  //error-stream
  Stream<String> get vehicleTypeError => _vehicleTypeError.stream;

  Stream<String> get brandError => _brandError.stream;

  Stream<String> get numberPlateError => _numberPlateError.stream;

  Stream<String> get yearError => _yearError.stream;

  Stream<String> get branchError => _branchError.stream;

  Stream<String> get currentKMError => _currentKMError.stream;

  Stream<String> get vehicleAddressError => _vehicleAddressError.stream;


  Stream<String> get vehicleRegistrationError =>
      _vehicleRegisterationError.stream;

  AddVehicleBloc() {
    BehaviorSubject<VehicleData> createVehicleFieldsStream =
        Observable.combineLatest9(
            vehicleTypeStream,
            brandStream,
            numberPlateStream,
            yearStream,
            branchStream,
            currentKMStream,
            vehicleAddressStream,
            insuranceCompanyStream,
            vehicleRegistrationStream, (vehicleType,
                brand,
                numberPlate,
                year,
                branch,
                currentKM,
                vehicleAddress,
                insuranceCompany,
                vehicleRegistration) {
      return VehicleData(
          vehicleType: vehicleType,
          brand: brand,
          numberPlate: numberPlate,
          year: year,
          pictureUrl: "",
          branch: branch,
          currentKMs: currentKM,
          vehicleStorageAddress: vehicleAddress,
          insuranceCompany: insuranceCompany,
          vehicleRegistrationNumber: vehicleRegistration);
    }).shareValue();

    Stream<bool> fieldsAreFilledIn =
        createVehicleFieldsStream.map((VehicleData data) {
      return data.vehicleType.isNotEmpty &&
          data.brand.isNotEmpty &&
          data.numberPlate.isNotEmpty &&
          data.year.isNotEmpty &&
          data.branch.isNotEmpty &&
          data.currentKMs.isNotEmpty &&
          data.vehicleStorageAddress.isNotEmpty &&
          data.vehicleRegistrationNumber.isNotEmpty;
    });

    fieldsAreFilledIn.listen((bool isFilled) {
      _enableButton.sink.add(isFilled);
    });

    Stream<ValidationType> fieldsValidation =
        createVehicleFieldsStream.map((VehicleData data) {
      String vehicleType = data.vehicleType;
      String brand = data.brand;
      String numberPlate = data.numberPlate;
      String year = data.year;
      String branch = data.branch;
      String currentKMs = data.currentKMs;
      String vehicleStorageAddress = data.vehicleStorageAddress;
      String vehicleRegistrationNumber = data.vehicleRegistrationNumber;

      return validateFields(
          vehicleType,
          brand,
          numberPlate,
          year,
          branch,
          currentKMs,
          vehicleStorageAddress,
          vehicleRegistrationNumber);
    });

    Observable.combineLatest2(fieldsValidation, vehicleCreatedStream,
        (ValidationType validationType, _) {
      return validationType;
    }).listen((ValidationType validationType) {
      _vehicleTypeError.sink.add(null);
      _brandError.sink.add(null);
      _numberPlateError.sink.add(null);
      _yearError.sink.add(null);
      _branchError.sink.add(null);
      _currentKMError.sink.add(null);
      _vehicleAddressError.sink.add(null);
      _vehicleRegisterationError.sink.add(null);

      switch (validationType) {
        case ValidationType.MISSING_FIELDS:
          _vehicleTypeError.sink.add("Missing Vehicle Type.");
          _brandError.sink.add("Missing Brand.");
          _numberPlateError.sink.add("Missing Number Plate.");
          _yearError.sink.add("Missing Year.");
          _branchError.sink.add("Missing Branch.");
          _currentKMError.sink.add("Missing Current KMs.");
          _vehicleAddressError.sink.add("Missing Vehicle Storage Address.");
          _vehicleRegisterationError.sink
              .add("Missing Vehicle Registration Number.");
          break;
        case ValidationType.MISSING_VEHICLE_TYPE:
          _vehicleTypeError.sink.add("Missing Vehicle Type.");
          break;
        case ValidationType.MISSING_BRAND:
          _brandError.sink.add("Missing Brand.");
          break;
        case ValidationType.MISSING_NUMBER_PLATE:
          _numberPlateError.sink.add("Missing Number Plate.");
          break;
        case ValidationType.MISSING_YEAR:
          _yearError.sink.add("Missing Year.");
          break;
        case ValidationType.MISSING_BRANCH:
          _branchError.sink.add("Missing Branch.");
          break;
        case ValidationType.MISSING_CURRENT_KMS:
          _currentKMError.sink.add("Missing Current KMs.");
          break;
        case ValidationType.MISSING_VEHICLE_ADDRESS:
          _vehicleAddressError.sink.add("Missing Vehicle Storage Address.");
          break;
        case ValidationType.MISSING_VEHICLE_REGISTRATION:
          _vehicleRegisterationError.sink
              .add("Missing Vehicle Registration Number.");
          break;
        default:
      }
    });

    _createVehicleSubject
        .where((event) => event == Irrelevant.Instance)
        .flatMap((Irrelevant irrelevant) {
      return fieldsValidation.first.asStream();
    }).where((ValidationType validationType) {
      return validationType == ValidationType.VALID;
    }).flatMap((ValidationType validation) {
      return createVehicleFieldsStream.first.asStream();
    }).flatMap((VehicleData data) {
      _showLoader.sink.add(true);

      var vehicleModel = VehicleModel(null,
          vehicleType: data.vehicleType,
          brand: data.brand,
          numberPlate: data.numberPlate,
          year: data.year,
          branch: data.branch,
          currentKMs: data.currentKMs,
          vehicleStorageAddress: data.vehicleStorageAddress,
          insuranceCompany: data.insuranceCompany,
          vehicleRegistrationNumber: data.vehicleRegistrationNumber);

      return _authRepository.getUser().then((user) {
        vehicleModel.company = user.companyName;
        return _vehicleRepository.create(vehicleModel, vehicleModel, null);
      }).asStream();
    }).listen((VehicleModel model) {
      _showLoader.sink.add(false);
      _vehicleCreatedSubject.sink.add(Irrelevant.Instance);
    }).onError((e) {
      print(e.toString());
    });
  }

  ValidationType validateFields(
      String vehicleType,
      String brand,
      String numberPlate,
      String year,
      String branch,
      String currentKMs,
      String vehicleStorageAddress,
      String vehicleRegistrationNumber) {
    if (vehicleType.isEmpty &&
        brand.isEmpty &&
        numberPlate.isEmpty &&
        year.isEmpty &&
        branch.isEmpty &&
        currentKMs.isEmpty &&
        vehicleStorageAddress.isEmpty &&
        vehicleRegistrationNumber.isEmpty) {
      return ValidationType.MISSING_FIELDS;
    } else if (vehicleType.isEmpty) {
      return ValidationType.MISSING_VEHICLE_TYPE;
    } else if (brand.isEmpty) {
      return ValidationType.MISSING_BRAND;
    } else if (numberPlate.isEmpty) {
      return ValidationType.MISSING_NUMBER_PLATE;
    } else if (year.isEmpty) {
      return ValidationType.MISSING_YEAR;
    } else if (branch.isEmpty) {
      return ValidationType.MISSING_BRANCH;
    } else if (currentKMs.isEmpty) {
      return ValidationType.MISSING_CURRENT_KMS;
    } else if (vehicleStorageAddress.isEmpty) {
      return ValidationType.MISSING_VEHICLE_ADDRESS;
    } else if (vehicleRegistrationNumber.isEmpty) {
      return ValidationType.MISSING_VEHICLE_REGISTRATION;
    } else {
      return ValidationType.VALID;
    }
  }
}

enum ValidationType {
  MISSING_FIELDS,
  MISSING_VEHICLE_TYPE,
  MISSING_BRAND,
  MISSING_NUMBER_PLATE,
  MISSING_YEAR,
  MISSING_BRANCH,
  MISSING_CURRENT_KMS,
  MISSING_VEHICLE_ADDRESS,
  MISSING_VEHICLE_REGISTRATION,
  VALID
}
