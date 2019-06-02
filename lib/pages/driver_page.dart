import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/widgets/star_display.dart';

class DriverPage extends StatefulWidget {
  final DriverModel model;

  DriverPage(this.model);

  @override
  State<StatefulWidget> createState() => _DriverState(model);
}

class _DriverState extends State<DriverPage> {
  final DriverModel model;

  _DriverState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.firstName} ${model.lastName}"),
      ),
      body: ListView(
        children: <Widget>[
          _buildTrackingInfo(),
          _buildDateRange(),
          _buildInfo()
        ],
      ),
    );
  }

  Widget _buildTrackingInfo() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[Text("125"), Text("Trips")],
          ),
          Column(
            children: <Widget>[Text("100KM/h"), Text("AVG SPEED")],
          ),
          Column(
            children: <Widget>[Text("321"), Text("KMs Driven")],
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
              children: <Widget>[Text("KMs Driven"), Text("33.4KM")],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Duration"), Text("2.3Hr")],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Assigned Vehicle"), Text("Some Car")],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("KMs Driven"),
                  StarDisplay(value: 4),
                ])
          ])),
    );
  }
}
