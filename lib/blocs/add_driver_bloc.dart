import 'package:rxdart/rxdart.dart';
import 'package:owner/irrelevant.dart';
import 'package:owner/models/driver_data.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/repositories/auth/auth_repository.dart';
import 'package:owner/repositories/driver/driver_repository.dart';

class AddDriverBloc {
  final _driverRepository = DriverRepository();
  final _authRepository = AuthRepository();

  //subjects
  final _firstNameSubject = BehaviorSubject<String>();
  final _lastNameSubject = BehaviorSubject<String>();
  final _mobileNumberSubject = BehaviorSubject<String>();
  final _driversLicenseSubject = BehaviorSubject<String>();
  final _pdpLicenseSubject = BehaviorSubject<String>();
  final _pdpExpireDateSubject = BehaviorSubject<String>();
  final _branchSubject = BehaviorSubject<String>();
  final _driversLicenseExpireDateSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();

  final _createDriverSubject = PublishSubject<Irrelevant>();
  final _driverCreatedSubject = BehaviorSubject<Irrelevant>();

  final _enableButton = BehaviorSubject<bool>.seeded(false);
  final _showLoader = BehaviorSubject<bool>.seeded(false);

  //error-subjects
  final _firstNameError = BehaviorSubject<String>();
  final _lastNameError = BehaviorSubject<String>();
  final _emailError = BehaviorSubject<String>();
  final _mobileNumberError = BehaviorSubject<String>();
  final _driversLicenseError = BehaviorSubject<String>();
  final _pdpLicenseError = BehaviorSubject<String>();
  final _pdpExpireDateError = BehaviorSubject<String>();
  final _branchError = BehaviorSubject<String>();
  final _driversLicenseExpireDateError = BehaviorSubject<String>();

  //functions
  Function(String) get firstNameChanged => _firstNameSubject.sink.add;

  Function(String) get lastNameChanged => _lastNameSubject.sink.add;

  Function(String) get mobileNumberChanged => _mobileNumberSubject.sink.add;

  Function(String) get emailChanged => _emailSubject.sink.add;

  Function(String) get driversLicenseChanged => _driversLicenseSubject.sink.add;

  Function(String) get pdpLicenseChanged => _pdpLicenseSubject.sink.add;

  Function(String) get pdpExpireDateChanged => _pdpExpireDateSubject.sink.add;

  Function(String) get branchChanged => _branchSubject.sink.add;

  Function(String) get driversLicenseExpireDateChanged =>
      _driversLicenseExpireDateSubject.sink.add;

  Function(Irrelevant) get createDriverPressed => _createDriverSubject.sink.add;

  //streams
  Stream<String> get firstNameStream => _firstNameSubject.stream;

  Stream<String> get lastNameStream => _lastNameSubject.stream;

  Stream<String> get mobileNumberStream => _mobileNumberSubject.stream;

  Stream<String> get emailStream => _emailSubject.stream;

  Stream<String> get driversLicenseStream => _driversLicenseSubject.stream;

  Stream<String> get pdpLicenseStream => _pdpLicenseSubject.stream;

  Stream<String> get pdpExpireDateStream => _pdpExpireDateSubject.stream;

  Stream<String> get branchStream => _branchSubject.stream;

  Stream<String> get driversLicenseExpireDateStream =>
      _driversLicenseExpireDateSubject.stream;

  Stream<bool> get enableButton => _enableButton.stream;

  Stream<bool> get showLoader => _showLoader.stream;

  Stream<Irrelevant> get driverCreatedStream => _createDriverSubject.stream;

  Stream<Irrelevant> get driverCreateStream => _driverCreatedSubject.stream;

  //error-stream
  Stream<String> get firstNameError => _firstNameError.stream;

  Stream<String> get lastNameError => _lastNameError.stream;

  Stream<String> get mobileNumberError => _mobileNumberError.stream;

  Stream<String> get emailError => _emailError.stream;

  Stream<String> get driversLicenseError => _driversLicenseError.stream;

  Stream<String> get pdpLicenseError => _pdpLicenseError.stream;

  Stream<String> get pdpExpireDateError => _pdpExpireDateError.stream;

  Stream<String> get branchError => _branchError.stream;

  Stream<String> get driversLicenseExpireDateError =>
      _driversLicenseExpireDateError.stream;

  AddDriverBloc() {
    // ignore: close_sinks
    BehaviorSubject<DriverData> createDriverFieldsStream =
        Observable.combineLatest9(
            firstNameStream,
            lastNameStream,
            mobileNumberStream,
            emailStream,
            driversLicenseStream,
            pdpLicenseStream,
            pdpExpireDateStream,
            branchStream,
            driversLicenseExpireDateStream, (firstName,
                lastName,
                mobileNumber,
                email,
                driversLicense,
                pdpLicense,
                pdpExpireDate,
                branch,
                driversLicenseExpireDate) {
      return DriverData(
          firstName: firstName,
          lastName: lastName,
          mobileNumber: mobileNumber,
          email: email,
          driversLicense: driversLicense,
          pdpLicense: pdpLicense,
          pdpExpireDate: pdpExpireDate,
          branch: branch,
          driversLicenceExpireDate: driversLicenseExpireDate);
    }).shareValue();

    Stream<bool> fieldsAreFilledIn =
        createDriverFieldsStream.map((DriverData data) {
      return data.firstName.isNotEmpty &&
          data.lastName.isNotEmpty &&
          data.mobileNumber.isNotEmpty &&
          data.email.isNotEmpty &&
          data.driversLicense.isNotEmpty &&
          data.pdpLicense.isNotEmpty &&
          data.pdpExpireDate.isNotEmpty &&
          data.branch.isNotEmpty &&
          data.driversLicenceExpireDate.isNotEmpty;
    });

    fieldsAreFilledIn.listen((bool isFilled) {
      _enableButton.sink.add(isFilled);
    });

    Stream<ValidationType> fieldsValidation =
        createDriverFieldsStream.map((DriverData data) {
      String firstName = data.firstName;
      String lastName = data.lastName;
      String mobileNumber = data.mobileNumber;
      String email = data.email;
      String driversLicense = data.driversLicense;
      String pdpLicense = data.pdpLicense;
      String pdpExpireDate = data.pdpExpireDate;
      String branch = data.branch;
      String driversLicenseExpireDate = data.driversLicenceExpireDate;

      return validateField(
          firstName,
          lastName,
          mobileNumber,
          email,
          driversLicense,
          pdpLicense,
          pdpExpireDate,
          branch,
          driversLicenseExpireDate);
    });

    Observable.combineLatest2(fieldsValidation, driverCreatedStream,
        (ValidationType validationType, _) {
      return validationType;
    }).listen((ValidationType validationType) {
      _firstNameError.sink.add(null);
      _lastNameError.sink.add(null);
      _mobileNumberError.sink.add(null);
      _emailError.sink.add(null);
      _driversLicenseError.sink.add(null);
      _pdpLicenseError.sink.add(null);
      _pdpExpireDateError.sink.add(null);
      _branchError.sink.add(null);
      _driversLicenseExpireDateError.sink.add(null);

      switch (validationType) {
        case ValidationType.MISSING_FIELDS:
          _firstNameError.sink.add("Missing Firstname.");
          _lastNameError.sink.add("Missing Lastname.");
          _mobileNumberError.sink.add("Missing Mobile Number.");
          _emailError.sink.add("Missing Email.");
          _driversLicenseError.sink.add("Missing Drivers License.");
          _pdpLicenseError.sink.add("Missing PDP License.");
          _pdpExpireDateError.sink.add("Missing Photo.");
          _branchError.sink.add("Missing Branch.");
          _driversLicenseExpireDateError.sink.add("Missing Address.");
          break;

        case ValidationType.MISSING_FIRSTNAME:
          _firstNameError.sink.add("Missing Firstname.");
          break;

        case ValidationType.MISSING_LASTNAME:
          _lastNameError.sink.add("Missing Lastname.");
          break;

        case ValidationType.MISSING_MOBILE_NUMBER:
          _mobileNumberError.sink.add("Missing Mobile Number.");
          break;
        case ValidationType.MISSING_EMAIL:
          _emailError.sink.add("Missing Email.");
          break;
        case ValidationType.MISSING_DRIVERS_LICENSE:
          _driversLicenseError.sink.add("Missing Drivers License.");
          break;

        case ValidationType.MISSING_PDP_LICENSE:
          _pdpLicenseError.sink.add("Missing PDP License.");
          break;

        case ValidationType.MISSING_PDP_EXPIRE_DATE:
          _pdpExpireDateError.sink.add("Missing Photo.");
          break;

        case ValidationType.MISSING_BRANCH:
          _branchError.sink.add("Missing Branch.");
          break;

        case ValidationType.MISSING_DRIVERS_LICENSE_EXPIREY_DATE:
          _driversLicenseExpireDateError.sink.add("Missing Address.");
          break;
        default:
      }
    });

    _createDriverSubject
        .where((event) => event == Irrelevant.Instance)
        .flatMap((Irrelevant irrelevant) {
      return fieldsValidation.first.asStream();
    }).where((ValidationType validation) {
      return validation == ValidationType.VALID;
    }).flatMap((ValidationType validation) {
      return createDriverFieldsStream.first.asStream();
    }).flatMap((DriverData data) {
      _showLoader.sink.add(true);

      var driverModel = DriverModel(null,
          firstName: data.firstName,
          lastName: data.lastName,
          mobileNumber: data.mobileNumber,
          email: data.email,
          driversLicense: data.driversLicense,
          pdpLicense: data.pdpLicense,
          pdpExpireDate: data.pdpExpireDate,
          branch: data.branch,
          driversLicenseExpireDate: data.driversLicenceExpireDate,
          clockedIn: false);

      return _authRepository.getUser().then((user) {
        driverModel.company = user.companyName;
        return _driverRepository.create(driverModel, driverModel, null);
      }).asStream();
    }).listen((DriverModel model) {
      _showLoader.sink.add(false);
      _driverCreatedSubject.sink.add(Irrelevant.Instance);
    });
  }

  ValidationType validateField(
      String firstName,
      String lastName,
      String mobileNumber,
      String email,
      String driversLicense,
      String pdpLicense,
      String photo,
      String branch,
      String driversLicenseExpireDate) {
    if (firstName.isEmpty &&
        lastName.isEmpty &&
        mobileNumber.isEmpty &&
        email.isEmpty &&
        driversLicense.isEmpty &&
        pdpLicense.isEmpty &&
        photo.isEmpty &&
        branch.isEmpty &&
        driversLicenseExpireDate.isEmpty) {
      return ValidationType.MISSING_FIELDS;
    } else if (firstName.isEmpty) {
      return ValidationType.MISSING_FIRSTNAME;
    } else if (lastName.isEmpty) {
      return ValidationType.MISSING_LASTNAME;
    } else if (mobileNumber.isEmpty) {
      return ValidationType.MISSING_MOBILE_NUMBER;
    } else if (email.isEmpty) {
      return ValidationType.MISSING_EMAIL;
    } else if (driversLicense.isEmpty) {
      return ValidationType.MISSING_DRIVERS_LICENSE;
    } else if (pdpLicense.isEmpty) {
      return ValidationType.MISSING_PDP_LICENSE;
    } else if (photo.isEmpty) {
      return ValidationType.MISSING_PDP_EXPIRE_DATE;
    } else if (branch.isEmpty) {
      return ValidationType.MISSING_BRANCH;
    } else if (driversLicenseExpireDate.isEmpty) {
      return ValidationType.MISSING_DRIVERS_LICENSE_EXPIREY_DATE;
    } else {
      return ValidationType.VALID;
    }
  }
}

enum ValidationType {
  MISSING_FIELDS,
  MISSING_FIRSTNAME,
  MISSING_LASTNAME,
  MISSING_MOBILE_NUMBER,
  MISSING_EMAIL,
  MISSING_DRIVERS_LICENSE,
  MISSING_PDP_LICENSE,
  MISSING_PDP_EXPIRE_DATE,
  MISSING_BRANCH,
  MISSING_DRIVERS_LICENSE_EXPIREY_DATE,
  VALID
}
