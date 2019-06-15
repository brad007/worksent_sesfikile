import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:owner/pages/main_page.dart';
import 'package:owner/pages/sign_in_page.dart';
import 'package:owner/pages/sign_up_page.dart';
import 'package:owner/provider/home_provider.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isAuthenticated = false;
  var _shownOnboarding = false;
  SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences preference) {
      _preferences = preference;
      final idToken = preference.getString("idToken");
      final shownOnboarding = preference.getBool("onboarding");

      setState(() {
        _isAuthenticated = idToken != null;
        _shownOnboarding = shownOnboarding == null ? false : shownOnboarding;
      });
    });

    PluginGooglePlacePicker.initialize(
      androidApiKey: "AIzaSyCyzt-5FtvS69Gz52qgG6NPEYLmkfB2fJY",
);
  } // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    _forcePortraitMode();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: createMaterialColor(const Color(0xFF162750))),
        routes: {
          "/register": (BuildContext context) => SignUpPage(),
          "/signIn": (BuildContext context) => SignInPage(),
        },
        home: _showPage()
    );
  }

  Widget _showPage(){
    if(_shownOnboarding == false){
      return Builder(
        builder: (context) => IntroViewsFlutter(
          _pages(),
          onTapDoneButton: (){
            
            _preferences.setBool("onboarding", true);
            _preferences.commit();

            Navigator.push(context, MaterialPageRoute(builder: 
              (context) => SignUpPage()
            ));
          },),
      );
    }else{
      return  _isAuthenticated ? HomeProvider(child: MainPage()) : SignUpPage();
    }
  }

  void _forcePortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  List<PageViewModel> _pages(){
    return [
      PageViewModel(
        title: 
        Text("WorkSent"),
        pageColor: const Color(0xFF162750),
        iconImageAssetPath: 'assets/onboarding_2.png',
        iconColor: null,
        bubbleBackgroundColor: const Color(0xFF162750),
        body: Column(
          children: <Widget>[
            Text("Identify\nDriving Habits", textAlign: TextAlign.center),
            // Text("Get data such as hard breaking, excessive speeding and trip history. Understand your drivers individual behavior",
            // textAlign: TextAlign.center)
          ],
        ),
        mainImage: Image.asset(
          'assets/onboarding_2.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        textStyle: TextStyle( color: Colors.white),
      ),
      PageViewModel(
        title: Text("WorkSent"),
        pageColor: const Color(0xFF162750),
        iconImageAssetPath: 'assets/onboarding_3.png',
        iconColor: null,
        bubbleBackgroundColor: const Color(0xFF162750),
        body: Column(
          children: <Widget>[
            Text("Score Driver Behavior"),
            // Text("Find out who is your best drivers based on accurate driver behavior score.", textAlign: TextAlign.center),
            // Text("WorkSent Location App ensures that you know how your drivers are taking care of your vehicles",
            // textAlign: TextAlign.center)
          ],
        ),
        mainImage: Image.asset(
          'assets/onboarding_3.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        textStyle: TextStyle( color: Colors.white),
      ),
      PageViewModel(
        title: Text("WorkSent"),
        pageColor: const Color(0xFF162750),
        iconImageAssetPath: 'assets/onboarding_1.png',
        iconColor: null,
        bubbleBackgroundColor: const Color(0xFF162750),
        body: Column(
          children: <Widget>[
            Text("Monitor Your Drivers in real time", textAlign: TextAlign.center),
            // Text("Monitor your drivers drivers location in real time at any time. KNow where they are, where they have been and where they are heading to",
            // textAlign: TextAlign.center)
          ],
        ),
        mainImage: Image.asset(
          'assets/onboarding_1.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        textStyle: TextStyle( color: Colors.white),
      )
    ];
  }
}
