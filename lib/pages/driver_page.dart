import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:worksent_sesfikile/blocs/driver_bloc.dart';
import 'package:worksent_sesfikile/blocs/vehicle_bloc.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/models/location_model.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';
import 'package:worksent_sesfikile/pages/choose_vehicle_page.dart';
import 'package:worksent_sesfikile/pages/profile_image_camera.dart';
import 'package:worksent_sesfikile/pages/tracking_page.dart';
import 'package:worksent_sesfikile/widgets/stacked_area_custom_color_line_chart.dart';
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:firebase_storage/firebase_storage.dart";
import 'package:charts_flutter/flutter.dart' as charts;



class DriverPage extends StatefulWidget {
  final DriverModel model;
  DriverPage(this.model);

  @override
  State<StatefulWidget> createState() => _DriverState(model);
}

class _DriverState extends State<DriverPage> {
   DriverModel model;
  File profileImage;
  final  _bloc = DriverBloc();
  final _vehicleBloc = VehicleBloc();

  DateTime startTime;

  DateTime endTime;

  DateTime selectedDate;

  _DriverState(this.model);

  GoogleMapController mapController;

  Polyline polylines;
  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
    _bloc.driverChange(model);
    _bloc.changeDate(DateTime.now());
    selectedDate = DateTime.now();
    polylines = Polyline(
        polylineId: PolylineId("polyline_id"),
        startCap: Cap.roundCap,
        endCap: Cap.squareCap);

    _bloc.locationsStream.listen((locations) {
      if (locations != null) {
        setState(() {
          polylines = polylines.copyWith(
              pointsParam: locations
                  .map((location) =>
                      LatLng(location.coords.latitude, location.coords.longitude))
                  .toList());

          var startMarker = Marker(
              infoWindow: InfoWindow(title: "Start"),
              markerId: MarkerId("start_marker"),
              position:
                  LatLng(locations.first.coords.latitude, locations.first.coords.longitude));
          var endMarker = Marker(
              infoWindow: InfoWindow(title: "End"),
              markerId: MarkerId("end_marker"),
              position:
                  LatLng(locations.last.coords.latitude, locations.last.coords.longitude));

          markers.clear();
          markers.add(startMarker);
          markers.add(endMarker);
          double totalSpeed = 0.0;
          locations.forEach((location) => totalSpeed += location.coords.speed);

          // averageSpeed = totalSpeed / locations.length;
          // lastDate = locations.last.dateCreated;
        });
  }
  });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.firstName} ${model.lastName}"),
      ),
      body: ListView(
        children: <Widget>[
          _buildProfileImage(),
          _buildTrackingInfo(),
          _buildDateRange(),
          _buildInfo(),
          _buildGraph(),
          _buildMap()
        ],
      ),
    );
  }

  Widget _buildProfileImage(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 32),
        _profileImage(),
        SizedBox(height: 4),
        Text("Upload Photo", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTrackingInfo() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[Text("1"), Text("Trips")],
          ),
          Spacer(),
          Column(
            children: <Widget>[_getSpeed(), Text("AVG SPEED")],
          ),
          Spacer(),
          Column(
            children: <Widget>[_buildKMsDriven(), Text("Driven")],
          )
        ],
      ),
    );
  }


  Widget _profileImage() {
    final buttonSize = 50.0;
    return InkWell(
        child: Container(
          child: model.imageUrl != null?
              ClipRRect(
                  borderRadius: BorderRadius.circular(buttonSize * 0.5),
                  child: Image.network(
                    model.imageUrl,
                    fit: BoxFit.cover,
                  ))
              : Icon(
                  Icons.center_focus_weak
                ),
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
              color: Colors.blue[400],
              borderRadius: BorderRadius.circular(buttonSize * 0.5)),
        ),
        onTap: () async {
          final editResult = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileEditCamera()));
          if (editResult != null) {
            setState((){
              profileImage = editResult;
            });

          print("downloadUrl: 1");
            _save();
          }
        });
  }

   _save() async {
    DriverModel updateUser = model;
        if (profileImage != null) {

          print("downloadUrl: 2");
          Directory appDocDir = await getApplicationDocumentsDirectory();
          final directoryPath = "${appDocDir.path}/profile_images";
          final thumbnailPath = "$directoryPath/thumbnail.jpg";
          final thumbnailFile = await FlutterImageCompress.compressAndGetFile(
              profileImage.path, thumbnailPath,
              minWidth: 250);

          print("downloadUrl: 3");
          final imageFileName = Uuid().v1();
          final StorageReference storageRef = FirebaseStorage.instance
              .ref()
              .child("profile_images")
              .child(imageFileName);

          print("downloadUrl: 3");
          final StorageUploadTask uploadTask =
              storageRef.putFile(thumbnailFile);

          print("downloadUrl: 4");
          final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
          print("downloadUrl: 5");
          final String profileImageUrl =
              (await downloadUrl.ref.getDownloadURL());
          print("downloadUrl: $profileImageUrl");
          updateUser.imageUrl = profileImageUrl;
          profileImage = null;
          setState(() {
            model = updateUser;
          });

          print("downloadUrl: 6");
        }
        _bloc.updateDriverInfo(updateUser);
//        Navigator.pop(context, updateUser);

  }

  Widget _getDate(){
    return StreamBuilder(
      initialData: DateTime.now(),
      stream: _bloc.dateStream,
      builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot){
        var date = snapshot.data;
        if(date == null){
          date = DateTime.now();
        }
        return Text("${date.day}-${date.month}-${date.year}");
      },
    );
  }

  Widget _buildDateRange() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _getDate(),
          FlatButton(
            onPressed: () async {
              final DateTime picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2019).subtract(Duration(days: 365)),
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 1))
              );

                setState((){
                  selectedDate = picked;
                });
              _bloc.changeDate(selectedDate);

            },
            child: const Text("Choose Date"),
            color: const Color(0xFFE51460),
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

//   DateTime dob = DateTime.parse('1967-10-12');
// Duration dur =  DateTime.now().difference(dob);
// String differenceInYears = (dur.inDays/365).floor().toString();
// return new Text(differenceInYears + ' years');

Widget _getDuration(){
  return StreamBuilder(
    initialData: "0",
    stream: _bloc.durationStream,
     builder: (BuildContext context, AsyncSnapshot<String> snapshot){
      return Text("${snapshot.data}Hrs");
    },
  );
}

Widget _getSpeed(){
  return StreamBuilder(
    initialData: 0.0,
    stream: _bloc.speedStream,
     builder: (BuildContext context, AsyncSnapshot<double> snapshot){
      return Text("${(snapshot.data*3.6).toStringAsFixed(2)}KM/h");
    },
  );
}

  Widget _buildInfo() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Container(
          margin: EdgeInsets.all(16),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Duration"), _getDuration()],
            ),
            SizedBox(height: 8),
            Divider(),
            InkWell(
              onTap:() async{
                var results = await Navigator.of(context).push(MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) {
                    return ChooseVehiclePage();
                  },
                ));

              if (results != null && results.containsKey('selectedVehicle')) {
                VehicleModel returned = results['selectedVehicle'];
              var vehicle = returned;
              vehicle.driver = model;
              
              setState(() {
                  model.vehicle = returned;
              });
              _bloc.updateDriverInfo(model);
              _vehicleBloc.updateVehicleInfo(vehicle);
    }
              },
              child: Column(
                children: <Widget>[
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Assigned Vehicle"),model.vehicle == null ?  Text("Assign Vehicle") : Text("${model.vehicle.vehicleType} ${model.vehicle.brand}")],
                  ),
                  SizedBox(height: 8)
                ],
              ),
            )

          ])),
    );
  }

  Widget _buildKMsDriven(){
    return StreamBuilder(
       initialData: null,
       stream: _bloc.distanceStream,
       builder: (BuildContext ctxt, AsyncSnapshot<double> snapshot){
        if(snapshot.hasData){
          return Text("${snapshot.data.toStringAsFixed(2)}KM");
        }else{
          return Text("0KM");
        }
        });
  }

  Widget _buildGraph(){
   return
     StreamBuilder(
       initialData: null,
       stream: _bloc.locationsStream,
       builder: (BuildContext ctxt, AsyncSnapshot<List<LocationModel>> snapshot){
        if(snapshot.hasData){
          if(snapshot.data.length > 0){
            return Container(
              height: 240,
              child: 
             StackedAreaCustomColorLineChart(_generateSeries(snapshot.data), animate: false),
            );
          }else{
            return Text("No Data Available", textAlign: TextAlign.center);
          }
        }else{
            return Text("No Data Available", textAlign: TextAlign.center);
        }
       },
     );
  }

  Widget _buildMap(){
    return Container(
      margin: EdgeInsets.all(16),
      child: MaterialButton(
        color: const Color(0xFFE51460),
        child: Text("View User Route"),
        textColor: Colors.white,
        onPressed: (){
          if(selectedDate == null){
            setState(() {
             selectedDate = DateTime.now(); 
            });
          }
          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => TrackingPage(selectedDate, model),
             ));
      },
    ));
  }

  List<charts.Series<LocationModel, double>> _generateSeries(List<LocationModel> locations){
      

      return [charts.Series<LocationModel, double>(
              id: 'Location',
              displayName: "Location",
              // colorFn specifies that the line will be blue.
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              // areaColorFn specifies that the area skirt will be light blue.
              areaColorFn: (_, __) =>
                charts.MaterialPalette.blue.shadeDefault.lighter,
              domainFn: (LocationModel location, _) =>  (DateTime.parse(location.timestamp).millisecondsSinceEpoch - DateTime.parse(locations.first.timestamp).millisecondsSinceEpoch)/1000.0,
              measureFn: (LocationModel location, _) => location.coords.speed*3.6,
              data:  locations,
            )];
  }
}
// numbers.sort((a, b) => a.length.compareTo(b.length));