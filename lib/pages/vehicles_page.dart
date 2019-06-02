import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/blocs/vehicles_bloc.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';
import 'package:worksent_sesfikile/pages/vehicle_page.dart';

import 'add_vehicle_page.dart';

class VehiclesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VehiclesState();
}

class _VehiclesState extends State<VehiclesPage> {
  final _bloc = VehiclesBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddVehiclePage()),
            );
          },
          label: Text("Add"),
          icon: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: _bloc.driversStream,
          initialData: null,
          builder: (BuildContext context,
              AsyncSnapshot<List<VehicleModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.map((driver) {
                  return vehicleWidget(driver);
                }).toList(growable: true),
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Widget vehicleWidget(VehicleModel model) {
    return InkWell(
      child: Card(
        margin: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
        child: Container(
          margin: EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${model.vehicleType}"),
                  Text("${model.vehicleRegistrationNumber}")
                ],
              ),
              Icon(Icons.location_on)
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => VehiclePage(model)),
        );
      },
    );
  }
}
