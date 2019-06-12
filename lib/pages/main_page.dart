import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worksent_sesfikile/pages/sign_up_page.dart';
import 'package:worksent_sesfikile/pages/vehicles_page.dart';

import 'drivers_page.dart';
import 'home_page.dart';
import 'managers_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  int menuItemSelected;
  Widget page;
  String title = "Work Sent";
  final int HOME = 0;
  final int DRIVERS = 1;
  final int VEHICLES = 2;
  final int MANAGERS = 3;
  final int BOOKINGS = 4;
  final int MARKET_PLACE = 5;
  final int SIGN_OUT = 6;

  @override
  void initState() {
    super.initState();
    setState(() {
      page = HomePage();
      menuItemSelected = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: _getDrawer(),
      body: page,
    );
  }

  Drawer _getDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            selected: HOME == menuItemSelected,
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              setState(() {
                page = HomePage();
                menuItemSelected = HOME;
                title = "SESFIKILE";
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: DRIVERS == menuItemSelected,
            title: Text("Drivers"),
            leading: Icon(Icons.people),
            onTap: () {
              setState(() {
                page = DriversPage();
                menuItemSelected = DRIVERS;
                title = "Drivers";
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: VEHICLES == menuItemSelected,
            title: Text("Vehicles"),
            leading: Icon(Icons.directions_car),
            onTap: () {
              setState(() {
                page = VehiclesPage();
                menuItemSelected = VEHICLES;
                title = "Vehicles";
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: MANAGERS == menuItemSelected,
            title: Text("Managers"),
            leading: Icon(Icons.person),
            onTap: () {
              setState(() {
                page = ManagersPage();
                menuItemSelected = MANAGERS;
                title = "Managers";
              });
              Navigator.pop(context);
            },
          ),
//           ListTile(
//             selected: BOOKINGS == menuItemSelected,
//             title: Text("Bookings *"),
//             leading: Icon(Icons.event),
//             onTap: () {
//               setState(() {
// //                page = EmployeesPage();
//                 menuItemSelected = BOOKINGS;
//                 title = "Bookings";
//               });
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             selected: MARKET_PLACE == menuItemSelected,
//             title: Text("Market Place *"),
//             leading: Icon(Icons.local_grocery_store),
//             onTap: () {
//               setState(() {
// //                page = EmployeesPage();
//                 menuItemSelected = MARKET_PLACE;
//                 title = "Market MARKET_PLACE";
//               });
//               Navigator.pop(context);
//             },
//           ),
          ListTile(
            selected: SIGN_OUT == menuItemSelected,
            title: Text("Sign Out"),
            leading: Icon(Icons.arrow_back),
            onTap: () {
              setState(() {
                SharedPreferences.getInstance().then((SharedPreferences sp) {
                  sp.remove("idToken");

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/register', (Route<dynamic> route) => false);
                });
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 32, left: 16),
            child: Text("WorkSent - Sesfikile"),
          )
        ],
      ),
    );
  }
}
