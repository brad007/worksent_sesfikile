import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worksent_sesfikile/pages/main_page.dart';
import 'package:worksent_sesfikile/pages/sign_in_page.dart';
import 'package:worksent_sesfikile/pages/sign_up_page.dart';
import 'package:worksent_sesfikile/provider/home_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isAuthenticated = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences preference) {
      final idToken = preference.getString("idToken");

      setState(() {
        _isAuthenticated = idToken != null;
      });
    });
  } // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    _forcePortraitMode();
    return MaterialApp(
        theme: ThemeData(primarySwatch: createMaterialColor(const Color(0xFF162750))),
        routes: {
          "/register": (BuildContext context) => SignUpPage(),
          "/signIn": (BuildContext context) => SignInPage(),
        },
        home:
            _isAuthenticated ? HomeProvider(child: MainPage()) : SignUpPage());
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
}
