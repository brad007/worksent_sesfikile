import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:location/location.dart" as LocationManager;
import 'package:owner/blocs/driver_bloc.dart';
import 'package:owner/blocs/drivers_bloc.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/pages/tracking_page.dart';
import 'package:owner/utils/Utills.dart';

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

  final _bloc = DriversBloc();
  final _driverBloc = DriverBloc();
  Set<Marker> mapMarkers = Set<Marker>();

  @override
  void initState() {
    super.initState();

    _bloc.driversStream.listen((drivers){
      _updateMarkerDrivers(drivers.where((d)=>d.location != null && d.previousLocation != null).toList(growable: true));
    });
  }

  _updateMarkerDrivers(List<DriverModel> drivers) async{
    setState(() {
       mapMarkers.clear();
    mapMarkers.addAll(drivers.map((d){
      final marker = Marker(
        rotation: Utils.calculateBearing(d.previousLocation.coords, d.location.coords),
        icon: BitmapDescriptor.fromAsset("images/markerpng"),
        markerId: MarkerId(d.id),
        position: LatLng(d.location.coords.latitude, d.location.coords.longitude),
        onTap: (){
          _settingModalBottomSheet(d);
        }
      );
      return marker;
    }).toList(growable: true));
    });
   
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: GoogleMap(
          rotateGesturesEnabled: false,
          markers: mapMarkers,
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

void _settingModalBottomSheet(DriverModel model){
  _driverBloc.driverChange(model);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
          return Container(
            color:const Color(0xFF162750) ,
            child:  Wrap(
            children: <Widget>[
               ListTile(
                title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const Text("Name", style: TextStyle(color: Colors.white),),  Text('${model.firstName} ${model.lastName}', style: TextStyle(color: Colors.white),)],),
                onTap: () => {}          
            ),
             Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: const Divider(color: Colors.grey,),
            ),
               ListTile(
                title:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const Text("Vehicle", style: TextStyle(color: Colors.white),),model.vehicle != null ?  Text('${model.vehicle.brand} ${model.vehicle.vehicleType} - ${model.vehicle.vehicleRegistrationNumber}', style: TextStyle(color: Colors.white),) : Text("No Assigned Vehicle", style: TextStyle(color: Colors.white))]),
                onTap: () => {},          
            ),
             Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: const Divider(color: Colors.grey,),
            ),
             ListTile(
                title:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const Text("Speed", style: TextStyle(color: Colors.white),),
                  Text('${(model.location.coords.speed < 0 ? 0 : model.location.coords.speed*3.6).toStringAsFixed(2)}KM/h', style: TextStyle(color: Colors.white),)]),
                onTap: () => {},          
            ),
             Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: const Divider(color: Colors.grey,),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
            const Text("Track Trips", style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
              ],
            ),
             Container(
              margin: EdgeInsets.all(4),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  MaterialButton(
              color: const Color(0xFFE51460),
              child: const Text("Choose Date"),
              onPressed: ()async{
                 final DateTime picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2019).subtract(Duration(days: 365)),
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 1))
              );
               Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => TrackingPage(picked, model),
             ));
              },
              textColor: Colors.white
            )
              ],
            ),
             Container(
              margin: EdgeInsets.all(8),
            )
           
            ],
          ),
          );
      }
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
