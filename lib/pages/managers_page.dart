import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/blocs/managers_bloc.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';

import 'add_manager_page.dart';
import 'manager_page.dart';

class ManagersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManagersState();
}

class _ManagersState extends State<ManagersPage> {
  final _bloc = ManagersBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddManagerPage()),
            );
          },
          label: Text("Add"),
          icon: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: _bloc.managersStream,
          initialData: null,
          builder: (BuildContext context,
              AsyncSnapshot<List<DriverModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.map((manager) {
                  return managerWidget(manager);
                }).toList(growable: true),
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Widget managerWidget(DriverModel model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ManagerPage(model)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${model.firstName} ${model.lastName}"),
                Text("Division - ${model.branch}")
              ],
            ),
            Icon(Icons.person)
          ],
        ),
      ),
    );
  }
}
