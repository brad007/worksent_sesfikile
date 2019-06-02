import 'package:firebase_auth/firebase_auth.dart';
import 'package:worksent_sesfikile/models/user_model.dart';
import 'package:worksent_sesfikile/repositories/auth/auth_provider.dart';
import 'package:worksent_sesfikile/repositories/user/user_provider.dart';

class AuthRepository {
  AuthProvider _authProvider = AuthProvider();
  UserProvider _userProvider = UserProvider();

  Future<FirebaseUser> getUser() {
    return _authProvider.getUser();
  }

  Future<FirebaseUser> signInUser({String email, String password}) {
    return _authProvider.signInUser(email: email, password: password);
  }

  Future<UserModel> createUser(
      {String email,
      String password,
      String fullName,
      String companyName,
      String companyAddress}) async {
    FirebaseUser user =
        await _authProvider.createUser(email: email, password: password);
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['fullName'] = fullName;
    map['userId'] = user.uid;
    map['companyName'] = companyName;
    map['companyAddress'] = companyAddress;
    map['dateCreated'] = DateTime.now().millisecondsSinceEpoch;
    map['dateUpdated'] = DateTime.now().millisecondsSinceEpoch;
    UserModel userModel = UserModel.fromMap(map);
    return _userProvider.createUser(user: userModel);
  }

  Future<void> sendResetPassword({String email}) {
    return _authProvider.sendResetPassword(email: email);
  }

  Future<void> logOut() {
    return _authProvider.logOut();
  }

  Future<dynamic> updateUser({UserModel user}) async {
    return _userProvider.updateUser(user: user);
  }
}
