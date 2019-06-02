import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';

class ManagerPage extends StatefulWidget {
  final DriverModel model;

  ManagerPage(this.model);

  @override
  State<StatefulWidget> createState() => _ManagerState(model);
}

class _ManagerState extends State<ManagerPage> {
  final DriverModel model;

  _ManagerState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.firstName} ${model.lastName}"),
      ),
      body: ListView(
        children: <Widget>[_buildInfo()],
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
              children: <Widget>[
                Text("Mobile Number"),
                Text("${model.mobileNumber}")
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Branch/Division/Branch"),
                Text("${model.branch}")
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Email Address"),
                Text("${model.email}")
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Physical Address"),
                Text("${model.driversLicenseExpireDate}")
              ],
            ),
          ])),
    );
  }
}
