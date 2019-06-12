import 'dart:core';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:worksent_sesfikile/irrelevant.dart';
import 'package:worksent_sesfikile/models/sign_up_data.dart';
import 'package:worksent_sesfikile/models/user_model.dart';
import 'package:worksent_sesfikile/repositories/auth/auth_repository.dart';

class SignUpBloc {
  final AuthRepository _authRepository = AuthRepository();

  //subjects
  final _companyNameSubject = BehaviorSubject<String>();
  final _contactNameSubject = BehaviorSubject<String>();
  final _companyEmailSubject = BehaviorSubject<String>();
  final _contactNumberSubject = BehaviorSubject<String>();
  final _companyAddressSubject = BehaviorSubject<String>();
  final _branchSubject = BehaviorSubject<String>.seeded("");
  final _divisionSubject = BehaviorSubject<String>.seeded("");
  final _passwordSubject = BehaviorSubject<String>();
  final _confirmPasswordSubject = BehaviorSubject<String>();

  final _signUpSubject = PublishSubject<Irrelevant>();
  final _registered = PublishSubject<UserModel>();

  final _enableSignUpButton = BehaviorSubject<bool>.seeded(false);
  final _showLoader = BehaviorSubject<bool>.seeded(false);
  final _showGenericError = BehaviorSubject<String>();

  final _showCompanyNameError = BehaviorSubject<String>();
  final _showContactNameError = BehaviorSubject<String>();
  final _showCompanyEmailError = BehaviorSubject<String>();
  final _showContactNumberError = BehaviorSubject<String>();
  final _showCompanyAddressError = BehaviorSubject<String>();
  final _showPasswordError = BehaviorSubject<String>();
  final _showConfirmPasswordError = BehaviorSubject<String>();

  //functions
  Function(String) get companyNameChanged => _companyNameSubject.sink.add;

  Function(String) get contactNameChanged => _contactNameSubject.sink.add;

  Function(String) get companyEmailChanged => _companyEmailSubject.sink.add;

  Function(String) get contactNumberChanged => _contactNumberSubject.sink.add;

  Function(String) get companyAddressChanged => _companyAddressSubject.sink.add;

  Function(String) get branchChanged => _branchSubject.sink.add;

  Function(String) get divisionChanged => _divisionSubject.sink.add;

  Function(String) get passwordChanged => _passwordSubject.sink.add;

  Function(String) get confirmPasswordChanged =>
      _confirmPasswordSubject.sink.add;

  Function(Irrelevant) get signUpPressed => _signUpSubject.sink.add;

  //streams
  Stream<Irrelevant> get loginStream =>
      _signUpSubject.stream.asBroadcastStream();

  Stream<bool> get enableSignUpButtonStream => _enableSignUpButton.stream;

  Stream<bool> get showLoader => _showLoader.stream;

  Stream<String> get companyNameStream => _companyNameSubject.stream;

  Stream<String> get contactNameStream => _contactNameSubject.stream;

  Stream<String> get companyEmailStream => _companyEmailSubject.stream;

  Stream<String> get contactNumberStream => _contactNumberSubject.stream;

  Stream<String> get companyAddressStream => _companyAddressSubject.stream;

  Stream<String> get branchStream => _branchSubject.stream;

  Stream<String> get divisionStream => _divisionSubject.stream;

  Stream<String> get passwordStream => _passwordSubject.stream;

  Stream<String> get confirmPasswordStream => _confirmPasswordSubject.stream;

  Stream<String> get genericError => _showGenericError.stream;

  Stream<String> get companyNameError => _showCompanyNameError.stream;

  Stream<String> get contactNameError => _showContactNameError.stream;

  Stream<String> get companyAddressError =>
      _showCompanyAddressError.stream;

  Stream<String> get passwordError => _showPasswordError.stream;

  Stream<String> get confirmPasswordError =>
      _showConfirmPasswordError.stream;

  Stream<String> get companyEmailError => _showCompanyEmailError.stream;

  Stream<String> get contactNumberError => _showContactNumberError.stream;

  Stream<UserModel> get registered => _registered.stream;

  SignUpBloc() {
    BehaviorSubject<SignUpData> signUpCredentialsStream =
        Observable.combineLatest9(
            companyNameStream,
            contactNameStream,
            companyEmailStream,
            contactNumberStream,
            companyAddressStream,
            branchStream,
            divisionStream,
            passwordStream,
            confirmPasswordStream, (companyName, contactName, companyEmail, contactNumber,
                companyAddress, branch, division, password, confirmPassword) {
      return SignUpData(companyName, contactName, companyEmail,contactNumber ,companyAddress,
          branch, division, password, confirmPassword);
    }).shareValue();

    Stream<bool> signUpCredentialsAreFilledIn =
        signUpCredentialsStream.map((SignUpData signUpData) {
      return signUpData.companyName.isNotEmpty &&
          signUpData.contactName.isNotEmpty &&
          signUpData.companyEmail.isNotEmpty &&
          signUpData.contactNumber.isNotEmpty &&
          signUpData.companyAddress.isNotEmpty &&
          signUpData.password.isNotEmpty &&
          signUpData.confirmPassword.isNotEmpty;
    });

    signUpCredentialsAreFilledIn.listen((bool isFilled) {
      _enableSignUpButton.sink.add(isFilled);
    });

    Stream<ValidationType> signUpCredentialsValidation =
        signUpCredentialsStream.map((SignUpData signUpData) {
      String companyName = signUpData.companyName;
      String contactName = signUpData.contactName;
      String companyEmail = signUpData.companyEmail;
      String contactNumber = signUpData.contactNumber;
      String companyAddress = signUpData.companyAddress;
      String password = signUpData.password;
      String confirmPassword = signUpData.confirmPassword;

      return _validateCredentials(
        companyName, 
        contactName, 
        companyEmail,
        contactNumber,
        companyAddress, 
        password, 
        confirmPassword);
    });

    Observable.combineLatest2(signUpCredentialsValidation, loginStream,
        (ValidationType validationType, _) {
      _showGenericError.sink.add(null);
      _showCompanyNameError.sink.add(null);
      _showContactNameError.sink.add(null);
      _showCompanyEmailError.sink.add(null);
      _showContactNumberError.sink.add(null);
      _showCompanyAddressError.sink.add(null);
      _showPasswordError.sink.add(null);
      _showConfirmPasswordError.sink.add(null);

      switch (validationType) {
        case ValidationType.MISSING_CREDENTIALS:
          _showCompanyNameError.sink.add("Missing Company Name.");
          _showContactNameError.sink.add("Missing Contact Name.");
          _showCompanyEmailError.sink.add("Missing Company Email.");
          _showContactNumberError.sink.add("Missing Contact Number.");
          _showCompanyAddressError.sink.add("Missing Company Address.");
          _showPasswordError.sink.add("Missing Password.");
          _showConfirmPasswordError.sink.add("Missing Password.");
          break;

        case ValidationType.MISSING_COMPANY_NAME:
          _showCompanyNameError.sink.add("Missing Company Name.");
          break;
        case ValidationType.MISSING_CONTACT_NAME:
          _showContactNameError.sink.add("Missing Contact Name.");
          break;
        case ValidationType.MISSING_COMPANY_EMAIL:
          _showCompanyEmailError.sink.add("Missing Company Email.");
          break;
        case ValidationType.MISSING_CONTACT_NUMBER:
          _showContactNumberError.sink.add("Missing Contact Number.");
          break;
        case ValidationType.MISSING_COMPANY_ADDRESS:
          _showCompanyAddressError.sink.add("Missing Company Address.");
          break;
        case ValidationType.MISSING_PASSWORD:
          _showPasswordError.sink.add("Missing Password.");
          break;
        case ValidationType.MISSING_CONFIRM_PASSWORD:
          _showConfirmPasswordError.sink.add("Missing Password.");
          break;
        case ValidationType.INVALID_PASSWORD:
          _showPasswordError.sink.add("Passwords Do Not Match.");
          _showConfirmPasswordError.sink.add("Passwords Do Not Match.");
          break;
        default:
      }
    });

    _signUpSubject
        .where((event) => event == Irrelevant.Instance)
        .flatMap((Irrelevant irrelevant) {
      return signUpCredentialsStream.first.asStream();
    }).flatMap((SignUpData signUpData) {
      String companyName = signUpData.companyName;
      String contactName = signUpData.contactName;
      String companyEmail = signUpData.companyEmail;
      String contactNumber = signUpData.contactNumber;
      String companyAddress = signUpData.companyAddress;
      String password = signUpData.password;
      _showLoader.sink.add(true);
      return _authRepository
          .createUser(
            email: companyEmail,
            contactNumber: contactNumber,
            password: password,
            fullName: contactName,
            companyName: companyName,
            companyAddress: companyAddress,
          )
          .asStream();
    }).listen((UserModel user) {
      _showLoader.sink.add(false);
      _registered.sink.add(user);
    }).onError((error){
      _showLoader.sink.add(false);
      _handleError(error);
    });
  }

  _handleError(PlatformException e){
      print("error: ${e.message}");
      _showGenericError.sink.add(e.message);
  }

  _validateCredentials(
      String companyName,
      String contactName,
      String companyEmail,
      String contactNumber,
      String companyAddress,
      String password,
      String confirmPassword) {
    if (companyName.isEmpty &&
        contactName.isEmpty &&
        companyEmail.isEmpty &&
        contactNumber.isEmpty &&
        companyAddress.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      return ValidationType.MISSING_CREDENTIALS;
    } else if (companyName.isEmpty) {
      return ValidationType.MISSING_COMPANY_NAME;
    } else if (contactName.isEmpty) {
      return ValidationType.MISSING_CONTACT_NAME;
    } else if (companyEmail.isEmpty) {
      return ValidationType.MISSING_COMPANY_EMAIL;
    } else if (password.isEmpty) {
      return ValidationType.MISSING_PASSWORD;
    } else if (confirmPassword.isEmpty) {
      return ValidationType.MISSING_CONFIRM_PASSWORD;
    } else if (password.length != confirmPassword.length) {
      return ValidationType.INVALID_PASSWORD;
    } else if(contactNumber.isEmpty){
      return ValidationType.MISSING_CONTACT_NUMBER;
    } else {
      return ValidationType.VALID;
    }
  }
}

enum ValidationType {
  MISSING_CREDENTIALS,
  MISSING_COMPANY_NAME,
  MISSING_CONTACT_NAME,
  MISSING_COMPANY_EMAIL,
  MISSING_CONTACT_NUMBER,
  MISSING_COMPANY_ADDRESS,
  MISSING_PASSWORD,
  MISSING_CONFIRM_PASSWORD,
  INVALID_PASSWORD,
  VALID
}
