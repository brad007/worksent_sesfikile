import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owner/blocs/sign_in_bloc.dart';
import 'package:owner/provider/home_provider.dart';
import 'package:owner/widgets/FormTextInput.dart';
import 'package:owner/widgets/form_listview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../irrelevant.dart';
import 'main_page.dart';

class SignInPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage>{

  final _bloc = SignInBloc();
  SharedPreferences _preferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

    _bloc.showGenericError.listen((error){
      if(error != null){
        _scaffoldKey.currentState.showSnackBar(
         SnackBar(
          content: Text(error),
          duration: Duration(seconds: 3),
        ));
      }
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
          _loader(),
          _buildSignInButton(),
          SizedBox(height: 16)
        ],
      ),
    );
  }

  Widget _loader(){
    return StreamBuilder(
      initialData: false,
      stream: _bloc.showLoader,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(snapshot.hasData){
          if(snapshot.data){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator()
              ],
            ) ;
          }else{
            return Container();
          }
        }else{
          return Container();
        }
      },
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