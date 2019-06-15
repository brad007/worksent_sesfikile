import 'package:flutter/material.dart';
import 'package:owner/blocs/driver_bloc.dart';
import 'package:owner/blocs/drivers_bloc.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/widgets/driver_widget.dart';

class ChooseDriverPage extends StatefulWidget {
  ChooseDriverPage({Key key}) : super(key: key);

  _ChooseDriverPageState createState() => _ChooseDriverPageState();
}

class _ChooseDriverPageState extends State<ChooseDriverPage> {
  final _bloc = DriversBloc();
  
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text("Choose Driver"),),
         body: _buildDrivers(),
       ),
    );
  }

  Widget _buildDrivers(){
    return StreamBuilder(
      initialData: null,
      stream: _bloc.driversStream,
      builder: (BuildContext context, AsyncSnapshot<List<DriverModel>> snapshot){
        return ListView(
          children: snapshot.data.map((d){
            return DriverWidget(model: d, onTap: (){
              Navigator.of(context).pop({'selectedDriver': d});
            },);
          }).toList(growable: true),
        );
      },);
  }
}