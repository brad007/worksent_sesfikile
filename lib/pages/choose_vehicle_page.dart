import 'package:flutter/material.dart';
import 'package:owner/blocs/vehicles_bloc.dart';
import 'package:owner/models/vehicle_model.dart';
import 'package:owner/widgets/vehicle_widget.dart';

class ChooseVehiclePage extends StatefulWidget {
  ChooseVehiclePage({Key key}) : super(key: key);

  _ChooseVehiclePageState createState() => _ChooseVehiclePageState();
}

class _ChooseVehiclePageState extends State<ChooseVehiclePage> {
  final _bloc = VehiclesBloc();
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text("Choose Vehicle")),
         body: _buildVehicles(),
       ),
    );
  }

  Widget _buildVehicles(){
    return StreamBuilder(
      initialData: null,
      stream: _bloc.vehiclesStream,
      builder: (BuildContext context, AsyncSnapshot<List<VehicleModel>> snapshot){
        if(snapshot.hasData){
         return  ListView(
            children: snapshot.data.map((v){
                return VehicleWidget(model: v, onTap: (){
                      Navigator.of(context).pop({'selectedVehicle': v});
                    },);
            }).toList(growable: true),
          );
        }else{
          return Container();
        }
      },
    );
  }
}