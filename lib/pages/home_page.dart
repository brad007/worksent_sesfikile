import 'package:flutter/material.dart';

import 'add_driver_page.dart';
import 'add_manager_page.dart';
import 'add_vehicle_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddDialog, icon: Icon(Icons.add), label: Text("Add")),
    );
  }

  Future<void> _showAddDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Select Type"),
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.pop(context, DialogOptions.DRIVER);
                },
                title: const Text(
                  "Driver",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context, DialogOptions.VEHICLE);
                },
                title: const Text(
                  "Vehicle",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context, DialogOptions.MANAGER);
                },
                title: const Text(
                  "Manager",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )
            ],
          );
        })) {
      case DialogOptions.DRIVER:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => AddDriverPage()),
        );
        break;
      case DialogOptions.VEHICLE:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AddVehiclePage()),
        );
        break;
      case DialogOptions.MANAGER:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AddManagerPage()),
        );
        break;
    }
  }
}

enum DialogOptions { DRIVER, VEHICLE, MANAGER }
