import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/blocs/vehicle_bloc.dart';
import 'package:worksent_sesfikile/models/vehicle_model.dart';
import 'package:worksent_sesfikile/pages/profile_image_camera.dart';
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:firebase_storage/firebase_storage.dart";
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class VehiclePage extends StatefulWidget {
  final VehicleModel model;

  VehiclePage(this.model);

  @override
  State<StatefulWidget> createState() => _VehicleState(model);
}

class _VehicleState extends State<VehiclePage> {
  VehicleModel model;
  File profileImage;
  final _bloc = VehicleBloc();
  _VehicleState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${model.vehicleType}")),
      body: ListView(
        children: <Widget>[
          _buildProfileImage(),
          _buildVehicleInfo(),
          _buildDateRange(),
          _buildInfo()
        ],
      ),
    );
  }

    Widget _buildProfileImage(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 32),
        _profileImage(),
        SizedBox(height: 4),
        Text("Upload Photo", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _profileImage() {
    final buttonSize = 50.0;
    return InkWell(
        child: Container(
          child: model.pictureUrl != null?
              ClipRRect(
                  borderRadius: BorderRadius.circular(buttonSize * 0.5),
                  child: Image.network(
                    model.pictureUrl,
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
        onTap: () async {
          final editResult = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileEditCamera()));
          if (editResult != null) {
            setState((){
              profileImage = editResult;
            });

          print("downloadUrl: 1");
            _save();
          }
        });
  }

     _save() async {
    VehicleModel updateUser = model;
        if (profileImage != null) {

          print("downloadUrl: 2");
          Directory appDocDir = await getApplicationDocumentsDirectory();
          final directoryPath = "${appDocDir.path}/profile_images";
          final thumbnailPath = "$directoryPath/thumbnail.jpg";
          final thumbnailFile = await FlutterImageCompress.compressAndGetFile(
              profileImage.path, thumbnailPath,
              minWidth: 250);

          print("downloadUrl: 3");
          final imageFileName = Uuid().v1();
          final StorageReference storageRef = FirebaseStorage.instance
              .ref()
              .child("profile_images")
              .child(imageFileName);

          print("downloadUrl: 3");
          final StorageUploadTask uploadTask =
              storageRef.putFile(thumbnailFile);

          print("downloadUrl: 4");
          final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
          print("downloadUrl: 5");
          final String profileImageUrl =
              (await downloadUrl.ref.getDownloadURL());
          print("downloadUrl: $profileImageUrl");
          updateUser.pictureUrl = profileImageUrl;
          profileImage = null;
          setState(() {
            model = updateUser;
          });

          print("downloadUrl: 6");
        }
        _bloc.updateVehicleInfo(updateUser);
//        Navigator.pop(context, updateUser);

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
