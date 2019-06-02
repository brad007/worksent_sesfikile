import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';

class VehiclePage extends StatefulWidget {
  final VehicleModel model;

  VehiclePage(this.model);

  @override
  State<StatefulWidget> createState() => _VehicleState(model);
}

class _VehicleState extends State<VehiclePage> {
  final VehicleModel model;

  _VehicleState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${model.vehicleType}")),
      body: ListView(
        children: <Widget>[
          _buildVehicleInfo(),
          _buildDateRange(),
          _buildInfo()
        ],
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[Text("${model.currentKMs}"), Text("Current KM")],
          ),
          Column(
            children: <Widget>[Text("${model.year}"), Text("Year")],
          ),
          Column(
            children: <Widget>[Text("Jane Doe"), Text("Current Driver")],
          )
        ],
      ),
    );
  }

  Widget _buildDateRange() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Today"),
          FlatButton(
            onPressed: () {},
            child: const Text("Choose Date"),
            color: const Color(0xFFE51460),
            textColor: Colors.white,
          )
        ],
      ),
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
              children: <Widget>[Text("Driver"), Text("Jane Doe")],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Registration Number"),
                Text("${model.numberPlate}")
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Branch/Division/Route"),
                Text("${model.branch}")
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Vehicle Storage Address"),
                Text("${model.vehicleStorageAddress}")
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Renewel Date"), Text("22 March 2020")],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Insurance Company"),
                Text("${model.insuranceCompany}")
              ],
            )
          ])),
    );
  }
}
