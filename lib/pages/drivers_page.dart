//This is for Heidi!!!!

import 'package:flutter/material.dart';
import 'package:owner/blocs/drivers_bloc.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/widgets/driver_widget.dart';

import 'add_driver_page.dart';

class DriversPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DriversState();
}

class _DriversState extends State<DriversPage> {
  final _bloc = DriversBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddDriverPage()),
            );
          },
          label: Text("Add"),
          icon: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: _bloc.driversStream,
          initialData: null,
          builder: (BuildContext context,
              AsyncSnapshot<List<DriverModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.map((driver) {
                  return DriverWidget(model: driver);
                }).toList(growable: true),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
