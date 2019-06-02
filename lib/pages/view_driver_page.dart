import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';

class ViewDriverPage extends StatefulWidget {
  final DriverModel model;

  ViewDriverPage(this.model);

  @override
  State<StatefulWidget> createState() => _ViewDriverState(model);
}

class _ViewDriverState extends State<ViewDriverPage> {
  final DriverModel model;

  _ViewDriverState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.firstName} ${model.lastName}"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(16), child: Text("Driver Information")),
          _buildInfo()
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
                Text("Drivers License Expiry"),
                Text("${model.driversLicenseExpireDate}")
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
                ]),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("PDP Expiry"),
                Text("${model.pdpExpireDate}")
              ],
            ),
          ])),
    );
  }
}
