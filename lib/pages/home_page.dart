import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:location/location.dart" as LocationManager;

import 'add_driver_page.dart';
import 'add_manager_page.dart';
import 'add_vehicle_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;
  final mapZoomFactor = 13.0;
  CameraPosition position;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: (cameraPosition) {},
            initialCameraPosition
                : position == null ? CameraPosition(target: LatLng(0, 0),
        zoom: mapZoomFactor): position
    ),
    floatingActionButton: FloatingActionButton.extended(
    onPressed: _showAddDialog, icon: Icon(Icons.add), label: Text("Add")
    )
    ,
    );
  }

  _onMapCreated(GoogleMapController controller) {
    if(position == null){
      _getUserLocation();
    }
    setState(() {
      mapController = controller;
    });
  }

  void _getUserLocation() async {
    final location = LocationManager.Location();
    try {
      final locationData = await location.getLocation();

      final currentLocation =
      LatLng(locationData.latitude, locationData.longitude);
      position =
          CameraPosition(target: currentLocation, zoom: mapZoomFactor);

      setState(() {});
      mapController
          .moveCamera(CameraUpdate.newCameraPosition(position));
    } on Exception {
      // TODO(brad): Handle failed to fetch user location
    }
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
