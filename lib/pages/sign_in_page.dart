import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worksent_sesfikile/blocs/sign_in_bloc.dart';
import 'package:worksent_sesfikile/irrelevant.dart';
import 'package:worksent_sesfikile/pages/main_page.dart';
import 'package:worksent_sesfikile/provider/home_provider.dart';
import 'package:worksent_sesfikile/widgets/FormTextInput.dart';
import 'package:worksent_sesfikile/widgets/form_listview.dart';

class SignInPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage>{

  final _bloc = SignInBloc();
  SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _preferences = sp;
    });

    _bloc.firebaseUser.listen((FirebaseUser user) {
      user.getIdToken().then((idToken) {
        if (idToken != null && _preferences != null) {
          _saveIdToken(idToken);
          _navigateToHome();
        }
      });
    });
  }

  _saveIdToken(String idToken) {
    _preferences.setString("idToken", idToken);
  }

  _navigateToHome() {
    final home = MaterialPageRoute(builder: (context) {
      return HomeProvider(child: MainPage());
    });

    Navigator.pushReplacement(context, home);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FormListView(
        children: <Widget>[
          Padding(
            padding:
            const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 16),
            child: Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )),
          ),
          _buildCompanyEmail(),
          _buildPassword(),
          _buildSignInButton(),
          SizedBox(height: 16)
        ],
      ),
    );
  }

  Widget _buildCompanyEmail() {
    return FormTextInput(
      hint: "Company Email",
      onChange: _bloc.emailChanged,
      stream: _bloc.showEmailError,
    );
  }

  Widget _buildPassword() {
    return FormTextInput(
      hint: "Password",
      onChange: _bloc.passwordChanged,
      stream: _bloc.showPasswordError,
    );
  }

  Widget _buildSignInButton() {
    return StreamBuilder<bool>(
      stream: _bloc.enableLoginButtonStream,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MaterialButton(
              onPressed: () => _bloc.loginPressed(Irrelevant.Instance),
              child: const Text("SIGN IN"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MaterialButton(
              disabledColor: const Color(0xFFF5F5F5),
              child: const Text("SIGN UP"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          );
        }
      },
    );
  }



}