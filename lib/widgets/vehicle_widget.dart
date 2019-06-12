import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';
import 'package:worksent_sesfikile/pages/vehicle_page.dart';

class VehicleWidget extends StatelessWidget {
  final VehicleModel model;
  final VoidCallback onTap;
  const VehicleWidget({Key key, this.model, this.onTap}) : super(key: key);

   Widget _profileImage() {
    final buttonSize = 80.0;
    return
        Container(
              child: model.pictureUrl != null? Image.network(
                        model.pictureUrl,
                        fit: BoxFit.cover,
                      )
                  : Icon(
                      Icons.center_focus_weak
                    ),
              width: buttonSize,
              height: buttonSize,
            );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
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
              Row(
                children:<Widget>[
                    _profileImage(),
                    Icon(Icons.location_on)
                ]
              )
            ],
          ),
        ),
      ),
      onTap: () {
        if(onTap == null)
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => VehiclePage(model)),
          );
        else
          onTap();
      },
    ),
    );
  }
}