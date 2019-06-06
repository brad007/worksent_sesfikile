import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:worksent_sesfikile/blocs/driver_bloc.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/models/user_model.dart';
import 'package:worksent_sesfikile/pages/profile_image_camera.dart';
import 'package:worksent_sesfikile/widgets/star_display.dart';
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:firebase_storage/firebase_storage.dart";

class DriverPage extends StatefulWidget {
  final DriverModel model;
  DriverPage(this.model);

  @override
  State<StatefulWidget> createState() => _DriverState(model);
}

class _DriverState extends State<DriverPage> {
   DriverModel model;
  File profileImage;
  final  _bloc = DriverBloc();

  _DriverState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.firstName} ${model.lastName}"),
      ),
      body: ListView(
        children: <Widget>[
          _buildProfileImage(),
          _buildTrackingInfo(),
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

  Widget _buildTrackingInfo() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[Text("125"), Text("Trips")],
          ),
          Spacer(),
          Column(
            children: <Widget>[Text("100KM/h"), Text("AVG SPEED")],
          ),
          Spacer(),
          Column(
            children: <Widget>[Text("321"), Text("KMs Driven")],
          )
        ],
      ),
    );
  }


  Widget _profileImage() {
    final buttonSize = 50.0;
    return InkWell(
        child: Container(
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
    DriverModel updateUser = model;
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
          updateUser.imageUrl = profileImageUrl;
          profileImage = null;
          setState(() {
            model = updateUser;
          });

          print("downloadUrl: 6");
        }
        _bloc.updateDriverInfo(updateUser);
//        Navigator.pop(context, updateUser);

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
