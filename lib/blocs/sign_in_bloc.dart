import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:worksent_sesfikile/irrelevant.dart';
import 'package:worksent_sesfikile/models/login_data.dart';
import 'package:worksent_sesfikile/repositories/auth/auth_repository.dart';
import 'package:worksent_sesfikile/utils/Utills.dart';

class SignInBloc {
  final AuthRepository _authRepository = AuthRepository();

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _loginSubject = PublishSubject<Irrelevant>();
  final _firebaseUser = PublishSubject<FirebaseUser>();

  final _enableLoginButton = BehaviorSubject<bool>.seeded(false);
  final _showLoader = BehaviorSubject<bool>.seeded(false);
  final _showGenericError = BehaviorSubject<String>();
  final _showEmailError = BehaviorSubject<String>();
  final _showPasswordError = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailSubject.sink.add;

  Function(String) get passwordChanged => _passwordSubject.sink.add;

  Function(Irrelevant) get loginPressed => _loginSubject.sink.add;

  Stream<String> get emailStream => _emailSubject.stream;

  Stream<String> get passwordStream => _passwordSubject.stream;

  Stream<Irrelevant> get loginStream =>
      _loginSubject.stream.asBroadcastStream();

  Stream<bool> get enableLoginButtonStream => _enableLoginButton.stream;

  Stream<bool> get showLoader => _showLoader.stream;

  Stream<String> get showGenericError => _showGenericError.stream;

  Stream<String> get showEmailError => _showEmailError.stream;

  Stream<String> get showPasswordError => _showPasswordError.stream;

  Stream<FirebaseUser> get firebaseUser => _firebaseUser.stream;

  SignInBloc() {
    BehaviorSubject<LoginData> loginCredentialsStream =
    Observable.combineLatest2(emailStream, passwordStream,
            (email, password) {
          return LoginData(email, password);
        }).shareValue();

    Stream<bool> loginCredentialsAreFilledIn =
    loginCredentialsStream.map((LoginData loginData) {
      return loginData.email.isNotEmpty && loginData.password.isNotEmpty;
    });

    loginCredentialsAreFilledIn.listen((bool isFilled) {
      _enableLoginButton.sink.add(isFilled);
    });

    Stream<ValidationType> loginCredentialsValidation =
    loginCredentialsStream.map((LoginData loginCredentials) {
      String email = loginCredentials.email;
      String password = loginCredentials.password;
      return _validateLoginCredentials(email, password);
    });

    Observable.combineLatest2(loginCredentialsValidation, loginStream,
            (ValidationType validationType, _) {
          return validationType;
        }).listen((ValidationType validationType) {
      _showEmailError.sink.add(null);
      _showPasswordError.sink.add(null);

      switch (validationType) {
        case ValidationType.MISSING_CREDENTIALS:
          _showEmailError.sink.add("Please fill in your email.");
          _showPasswordError.sink.add("Please fill in your password.");
          break;
        case ValidationType.MISSING_EMAIL:
          _showEmailError.sink.add("Please fill in your email.");
          break;
        case ValidationType.MISSING_PASSWORD:
          _showPasswordError.sink.add("Please fill in your password.");
          break;
        case ValidationType.INVALID_EMAIL:
          _showEmailError.sink.add("Incorrect email, please try again.");
          break;
        case ValidationType.PASSWORD_TOO_SHORT:
          _showPasswordError.sink.add("Your password is too short.");
          break;
        default:
      }
    });

    _loginSubject
        .where((event) => event == Irrelevant.Instance)
        .flatMap((Irrelevant irrelevant) {
      return loginCredentialsValidation.first.asStream();
    })
        .where((ValidationType validationType) =>
    validationType == ValidationType.VALID)
        .flatMap((ValidationType validationType) {
      return loginCredentialsStream.first.asStream();
    })
        .flatMap((LoginData credentials) {
      String email = credentials.email;
      String password = credentials.password;
      //TODO nice way to show and hide the loader
      _showLoader.sink.add(true);
      return _authRepository
          .signInUser(email: email, password: password)
          .asStream();
    })
        .listen((FirebaseUser user) {
      _showLoader.sink.add(false);
      _firebaseUser.sink.add(user);
    })
        .onError((error) {
      _handleError(error);
      _showLoader.sink.add(false);
    });
  }

  ValidationType _validateLoginCredentials(String email, String password) {
    if (email.isEmpty && password.isEmpty) {
      return ValidationType.MISSING_CREDENTIALS;
    } else if (email.isEmpty) {
      return ValidationType.MISSING_EMAIL;
    } else if (password.isEmpty) {
      return ValidationType.MISSING_PASSWORD;
    } else if (password.length < 6) {
      return ValidationType.PASSWORD_TOO_SHORT;
    } else if (!Utils.emailIsValid(email)) {
      return ValidationType.INVALID_EMAIL;
    } else {
      return ValidationType.VALID;
    }
  }

  void _handleError(PlatformException error) {
    _showGenericError.sink.add(error.message);
  }
}

enum ValidationType {
  MISSING_CREDENTIALS,
  MISSING_EMAIL,
  MISSING_PASSWORD,
  PASSWORD_TOO_SHORT,
  INVALID_EMAIL,
  VALID
}
