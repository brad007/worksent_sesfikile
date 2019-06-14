import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/pages/driver_page.dart';
import 'package:worksent_sesfikile/pages/view_driver_page.dart';

class DriverWidget extends StatelessWidget {
  final DriverModel model;
  final VoidCallback onTap;


  const DriverWidget({Key key,this.model, this.onTap}) : super(key: key);

  Widget _getCarWidget(){
    if(model.vehicle == null){
      return Container( height: 80, width: 80);
    }else{
      if(model.vehicle.pictureUrl == null){
        return Image.asset("images/bus.png", height: 80, width: 80,);
      }else{
        return Image.network(model.vehicle.pictureUrl, height: 80, width: 80,);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
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
                      model.vehicle == null ?
                      Text("No Assigned Vehicle") :
                      Text("${model.vehicle.vehicleType} ${model.vehicle.brand}")
                    ],
                  ),
                  _getCarWidget()
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[Icon(Icons.location_on), Text("Trips")],
                  ),
                  InkWell(
                    child: _profileImage(),
                    onTap: () {
                      if(onTap == null)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ViewDriverPage(model)),
                        );
                      else
                        onTap();
                    },
                  ),
                  Column(
                    children: 
                      model.clockedIn ?
                      [Icon(Icons.location_on, color: Colors.green), Text("Clocked In")] : 
                      [Icon(Icons.location_off, color: Colors.red), Text("Clocked Out")],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        if(onTap == null){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => DriverPage(model)),
        );
        }else{
          onTap();
        }
      },
    );
  }

  Widget _profileImage() {
    final buttonSize = 40.0;
    return  Column(
      children: <Widget>[
        Container(
              child: model.imageUrl != null?
                  ClipRRect(
                      borderRadius: BorderRadius.circular(buttonSize * 0.5),
                      child: Image.network(
                        model.imageUrl,
                        fit: BoxFit.cover,
                      ))
                  : Icon(
                      Icons.center_focus_weak
                    ),
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(buttonSize * 0.5)),
            ),
        Text("Profile")
      ],
    );
  }
}