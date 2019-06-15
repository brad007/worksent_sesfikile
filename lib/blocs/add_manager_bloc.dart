import 'package:rxdart/rxdart.dart';
import 'package:owner/irrelevant.dart';
import 'package:owner/models/driver_data.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/repositories/auth/auth_repository.dart';
import 'package:owner/repositories/manager/manager_repository.dart';

class AddManagerBloc {
  final _managerRepository = ManagerRepository();
  final _authRepository = AuthRepository();

  //subjects
  final _firstNameSubject = BehaviorSubject<String>();
  final _lastNameSubject = BehaviorSubject<String>();
  final _mobileNumberSubject = BehaviorSubject<String>();
  final _driversLicenseSubject = BehaviorSubject<String>();
  final _branchSubject = BehaviorSubject<String>();
  final _addressSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _createManagerSubject = PublishSubject<Irrelevant>();
  final _managerCreatedSubject = BehaviorSubject<Irrelevant>();

  final _enableButton = BehaviorSubject<bool>.seeded(false);
  final _showLoader = BehaviorSubject<bool>.seeded(false);

  //error-subjects
  final _firstNameError = BehaviorSubject<String>();
  final _lastNameError = BehaviorSubject<String>();
  final _mobileNumberError = BehaviorSubject<String>();
  final _emailError = BehaviorSubject<String>();
  final _driversLicenseError = BehaviorSubject<String>();
  final _branchError = BehaviorSubject<String>();
  final _addressError = BehaviorSubject<String>();

  //functions
  Function(String) get firstNameChanged => _firstNameSubject.sink.add;

  Function(String) get lastNameChanged => _lastNameSubject.sink.add;

  Function(String) get mobileNumberChanged => _mobileNumberSubject.sink.add;

  Function(String) get emailChanged => _emailSubject.sink.add;

  Function(String) get driversLicenseChanged => _driversLicenseSubject.sink.add;

  Function(String) get branchChanged => _branchSubject.sink.add;

  Function(String) get addressChanged => _addressSubject.sink.add;

  Function(Irrelevant) get createManagerPressed =>
      _createManagerSubject.sink.add;

  //streams
  Stream<String> get firstNameStream => _firstNameSubject.stream;

  Stream<String> get lastNameStream => _lastNameSubject.stream;

  Stream<String> get mobileNumberStream => _mobileNumberSubject.stream;

  Stream<String> get emailStream => _emailSubject.stream;

  Stream<String> get driversLicenseStream => _driversLicenseSubject.stream;

  Stream<String> get branchStream => _branchSubject.stream;

  Stream<String> get addressStream => _addressSubject.stream;

  Stream<bool> get enableButton => _enableButton.stream;

  Stream<bool> get showLoader => _showLoader.stream;

  Stream<Irrelevant> get managerCreatedStream => _createManagerSubject.stream;

  Stream<Irrelevant> get managerCreateStream => _managerCreatedSubject.stream;

  //error-stream
  Stream<String> get firstNameError => _firstNameError.stream;

  Stream<String> get lastNameError => _lastNameError.stream;

  Stream<String> get mobileNumberError => _mobileNumberError.stream;

  Stream<String> get emailError => _emailError.stream;

  Stream<String> get driversLicenseError => _driversLicenseError.stream;

  Stream<String> get branchError => _branchError.stream;

  Stream<String> get addressError => _addressError.stream;

  AddManagerBloc() {
    // ignore: close_sinks
    BehaviorSubject<DriverData> createManagerFieldsStream =
        Observable.combineLatest7(
            firstNameStream,
            lastNameStream,
            mobileNumberStream,
            emailStream,
            driversLicenseStream,
            branchStream,
            addressStream, (firstName, lastName, mobileNumber, email,
                driversLicense, branch, address) {
      return DriverData(
          firstName: firstName,
          lastName: lastName,
          mobileNumber: mobileNumber,
          email: email,
          driversLicense: driversLicense,
          branch: branch,
          driversLicenceExpireDate: address);
    }).shareValue();

    Stream<bool> fieldsAreFilledIn =
        createManagerFieldsStream.map((DriverData data) {
      return data.firstName.isNotEmpty &&
          data.lastName.isNotEmpty &&
          data.mobileNumber.isNotEmpty &&
          data.email.isNotEmpty &&
          data.driversLicense.isNotEmpty &&
          data.branch.isNotEmpty &&
          data.driversLicenceExpireDate.isNotEmpty;
    });

    fieldsAreFilledIn.listen((bool isFilled) {
      _enableButton.sink.add(isFilled);
    });

    Stream<ValidationType> fieldsValidation =
        createManagerFieldsStream.map((DriverData data) {
      String firstName = data.firstName;
      String lastName = data.lastName;
      String mobileNumber = data.mobileNumber;
      String email = data.email;
      String driversLicense = data.driversLicense;
      String branch = data.branch;
      String address = data.driversLicenceExpireDate;

      return validateField(firstName, lastName, mobileNumber, email,
          driversLicense, branch, address);
    });

    Observable.combineLatest2(fieldsValidation, managerCreatedStream,
        (ValidationType validationType, _) {
      return validationType;
    }).listen((ValidationType validationType) {
      _firstNameError.sink.add(null);
      _lastNameError.sink.add(null);
      _mobileNumberError.sink.add(null);
      _emailError.sink.add(null);
      _driversLicenseError.sink.add(null);
      _branchError.sink.add(null);
      _addressError.sink.add(null);

      switch (validationType) {
        case ValidationType.MISSING_FIELDS:
          _firstNameError.sink.add("Missing Firstname.");
          _lastNameError.sink.add("Missing Lastname.");
          _mobileNumberError.sink.add("Missing Mobile Number.");
          _emailError.sink.add("Missing Email.");
          _driversLicenseError.sink.add("Missing Managers License.");
          _branchError.sink.add("Missing Branch.");
          _addressError.sink.add("Missing Address.");
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
          _driversLicenseError.sink.add("Missing Managers License.");
          break;

        case ValidationType.MISSING_BRANCH:
          _branchError.sink.add("Missing Branch.");
          break;

        case ValidationType.MISSING_ADDRESS:
          _addressError.sink.add("Missing Address.");
          break;
        default:
      }
    });

    _createManagerSubject
        .where((event) => event == Irrelevant.Instance)
        .flatMap((Irrelevant irrelevant) {
      return fieldsValidation.first.asStream();
    }).where((ValidationType validation) {
      return validation == ValidationType.VALID;
    }).flatMap((ValidationType validation) {
      return createManagerFieldsStream.first.asStream();
    }).flatMap((DriverData data) {
      _showLoader.sink.add(true);

      var managerModel = DriverModel(null,
          firstName: data.firstName,
          lastName: data.lastName,
          mobileNumber: data.firstName,
          email: data.email,
          driversLicenseUrl: null,
          pdpLicenseUrl: null,
          pdpExpireDate: null,
          branch: data.branch,
          driversLicenseExpireDate: data.driversLicenceExpireDate);

      return _authRepository.getUser().then((user) {
        managerModel.company = user.companyName;
        return _managerRepository.create(managerModel, managerModel, null);
      }).asStream();
    }).listen((DriverModel model) {
      _showLoader.sink.add(false);
      _managerCreatedSubject.sink.add(Irrelevant.Instance);
    }).onError((e) {
      print(e.toString());
    });
  }

  ValidationType validateField(
      String firstName,
      String lastName,
      String mobileNumber,
      String email,
      String driversLicense,
      String branch,
      String address) {
    if (firstName.isEmpty &&
        lastName.isEmpty &&
        mobileNumber.isEmpty &&
        email.isEmpty &&
        driversLicense == null &&
        branch.isEmpty &&
        address.isEmpty) {
      return ValidationType.MISSING_FIELDS;
    } else if (firstName.isEmpty) {
      return ValidationType.MISSING_FIRSTNAME;
    } else if (lastName.isEmpty) {
      return ValidationType.MISSING_LASTNAME;
    } else if (mobileNumber.isEmpty) {
      return ValidationType.MISSING_MOBILE_NUMBER;
    } else if (email.isEmpty) {
      return ValidationType.MISSING_EMAIL;
    } else if (driversLicense == null) {
      return ValidationType.MISSING_DRIVERS_LICENSE;
    } else if (branch.isEmpty) {
      return ValidationType.MISSING_BRANCH;
    } else if (address.isEmpty) {
      return ValidationType.MISSING_ADDRESS;
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
  MISSING_BRANCH,
  MISSING_ADDRESS,
  VALID
}
