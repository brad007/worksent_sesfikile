//This is for Heidi!!!!

import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/blocs/drivers_bloc.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/pages/view_driver_page.dart';

import 'add_driver_page.dart';
import 'driver_page.dart';

class DriversPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DriversState();
}

class _DriversState extends State<DriversPage> {
  final _bloc = DriversBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  return driverWidget(driver);
                }).toList(growable: true),
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Widget driverWidget(DriverModel model) {
    return InkWell(
      child: Card(
        margin: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
        child: Container(
          margin: EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${model.firstName} ${model.lastName}"),
                      Text("Assign Vehicle")
                    ],
                  ),
                  Icon(Icons.location_off)
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[Icon(Icons.location_on), Text("Trips")],
                  ),
                  InkWell(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.account_circle),
                        Text("Profile")
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ViewDriverPage(model)),
                      );
                    },
                  ),
                  Column(
                    children: <Widget>[Text("${model.driversLicenseExpireDate}")],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => DriverPage(model)),
        );
      },
    );
  }
}
