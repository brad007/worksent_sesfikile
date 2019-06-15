import 'package:flutter/material.dart';
import 'package:owner/blocs/vehicles_bloc.dart';
import 'package:owner/models/vehicle_model.dart';
import 'package:owner/pages/vehicle_page.dart';
import 'package:owner/widgets/vehicle_widget.dart';

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
          stream: _bloc.vehiclesStream,
          initialData: null,
          builder: (BuildContext context,
              AsyncSnapshot<List<VehicleModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.map((driver) {
                  return VehicleWidget(model: driver);
                }).toList(growable: true),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
