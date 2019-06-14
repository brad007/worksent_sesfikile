import 'package:flutter/material.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worksent_sesfikile/blocs/sign_up_bloc.dart';
import 'package:worksent_sesfikile/irrelevant.dart';
import 'package:worksent_sesfikile/models/user_model.dart';
import 'package:worksent_sesfikile/pages/main_page.dart';
import 'package:worksent_sesfikile/provider/home_provider.dart';
import 'package:worksent_sesfikile/widgets/FormTextInput.dart';
import 'package:worksent_sesfikile/widgets/form_listview.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _bloc = SignUpBloc();
  SharedPreferences _preferences;
  bool isCommercial;
  String placeName;
  String branchValue;

  @override
  void initState() {
    super.initState();
    isCommercial = false;

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _preferences = sp;
    });

    _bloc.registered.listen((UserModel user) {
      if (user != null) {
        _saveIdToken(user.id);
        _navigateToHome();
      }
    });

    _bloc.genericError.listen((error){
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
      key: _scaffoldKey,
        body: FormListView(children: <Widget>[
      Padding(
        padding:
            const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 16),
        child: Center(
            child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        )),
      ),
      _buildCompanyName(),
      _buildContactName(),
      _buildCompanyEmail(),
      _buildMobileName(),
      _buildCompanyAddress(),
      _buildCommercialToggle(),
      _buildBranch(),
      _buildDivision(),
      _buildPassword(),
      _buildConfirmPassword(),
      _loader(),
      _buildSignUpButton(),
      _buildSwitchToLoginButton(),
      SizedBox(height: 16)
    ]));
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

  Widget _buildCompanyName() {
    return FormTextInput(
      hint: "Company Name",
      onChange: _bloc.companyNameChanged,
      stream: _bloc.companyNameError,
    );
  }

  Widget _buildContactName() {
    return FormTextInput(
      hint: "Contact Name",
      onChange: _bloc.contactNameChanged,
      stream: _bloc.contactNameError,
    );
  }

  Widget _buildCompanyEmail() {
    return FormTextInput(
      hint: "Company Email",
      onChange: _bloc.companyEmailChanged,
      stream: _bloc.companyEmailError,
    );
  }

  Widget _buildMobileName() {
    return FormTextInput(
      hint: "Contact Number",
      isNumber: true,
      onChange: _bloc.contactNumberChanged,
      stream: _bloc.contactNumberError,
    );
  }

  Widget _buildCompanyAddress()  {
    return InkWell(
      child: Container(padding: EdgeInsets.all(16),child:Text(placeName == null ? "Company Address":placeName, style: TextStyle(fontWeight: FontWeight.bold),)  ,),
      onTap: () async{
        var place = await PluginGooglePlacePicker.showAutocomplete(mode: PlaceAutocompleteMode.MODE_FULLSCREEN, countryCode: "ZA");
        _bloc.companyAddressChanged(place.name);
        setState(() {
          placeName = place.name;
        });
      },
    );
  }

  Widget _buildBranch() {
    if (isCommercial) {
      return FormTextInput(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          hint: "Branch - If Required *",
          onChange: _bloc.branchChanged);
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: DropdownButton(
          hint: Text("Taxi Association"),
          value: branchValue,
          items: <String>[
            "CODETA",
            "CATA",
            "UNCEDO",
            "Mitchelle's Plain",
            "BOLAND",
            "EDEN",
            "GREATER CAPE",
            "NORTHERNS",
            "TWO OCEANS",
            "WEST COAST"
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String value) {
            _bloc.branchChanged(value);
            setState(() {
             branchValue = value; 
            });
          },
        ),
      );
    }
  }

  Widget _buildDivision() {
    return isCommercial? FormTextInput(
        hint: "Division - If Required *", onChange: _bloc.divisionChanged): Container();
  }

  Widget _buildPassword() {
    return FormTextInput(
      hint: "Password",
      onChange: _bloc.passwordChanged,
      stream: _bloc.passwordError,
    );
  }

  Widget _buildConfirmPassword() {
    return FormTextInput(
      hint: "Confirm Password",
      onChange: _bloc.confirmPasswordChanged,
      stream: _bloc.confirmPasswordError,
    );
  }

  Widget _buildSignUpButton() {
    return StreamBuilder<bool>(
      stream: _bloc.enableSignUpButtonStream,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MaterialButton(
              onPressed: () => _bloc.signUpPressed(Irrelevant.Instance),
              child: const Text("SIGN UP"),
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

  Widget _buildSwitchToLoginButton() {
    return FlatButton(
      child: Text("Already have an account? Log in",
          style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontFamily: "NunitoSans",
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline)),
      onPressed: () {
        Navigator.pushNamed(context, "/signIn");
      },
    );
  }

  

  Widget _buildCommercialToggle() {
    return Container(
      margin: EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(!isCommercial? "Taxi Association" : "Commercial"),
          Switch(
              value: isCommercial,
              onChanged: (bool changed) {
                _bloc.branchChanged(null);
                setState(() {
                  isCommercial = changed;
                });
              })
        ],
      ),
    );
  }
}
