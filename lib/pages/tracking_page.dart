import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:worksent_sesfikile/blocs/driver_bloc.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';

class TrackingPage extends StatefulWidget {
  final DateTime selectedDate;
  final DriverModel driver;


  TrackingPage(this.selectedDate, this.driver, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrackingState(this.selectedDate, this.driver);
}

class _TrackingState extends State<TrackingPage> {
  final _bloc = DriverBloc();
  Polyline polylines;
  Set<Marker> markers = Set();
  double averageSpeed = 0;
  int lastDate = 0;

  var selectedDate;
  final DriverModel driver;

  _TrackingState(this.selectedDate, this.driver);

  @override
  void initState() {
    super.initState();

    _bloc.changeDate(selectedDate);
    _bloc.driverChange(driver);

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
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
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

          averageSpeed = totalSpeed / locations.length;
          lastDate =DateTime.parse(locations.last.timestamp).millisecondsSinceEpoch;
        });
      }
    }).onError((error) {
      error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  zoom: 10, target: LatLng(-33.918861, 18.423300)),
              polylines: Set.of([polylines]),
              markers: markers,
            ),
          ),
          Card(
            margin: EdgeInsets.all(0),
            child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Icon(Icons.directions_car),
                      SizedBox(width: 16),
                      Text(
                          "Ave. Speed: ${(averageSpeed * 3.6).toStringAsFixed(2)}Km/h",
                          style: TextStyle(fontSize: 20))
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Icon(Icons.date_range),
                      SizedBox(width: 16),
                      Text(
                          "Date: ${DateFormat.yMMMMEEEEd().format(selectedDate)}",
                          style: TextStyle(fontSize: 20))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
