import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:owner/blocs/driver_bloc.dart';
import 'package:owner/models/driver_model.dart';
import 'package:owner/pages/profile_image_camera.dart';
import 'package:owner/pages/view_image_page.dart';
import 'package:owner/utils/Utills.dart';

class ViewDriverPage extends StatefulWidget {
  final DriverModel model;

  ViewDriverPage(this.model);

  @override
  State<StatefulWidget> createState() => _ViewDriverState(model);
}

class _ViewDriverState extends State<ViewDriverPage> {
   DriverModel model;
  File profileImage;
  bool isLoading = false;

  final  _bloc = DriverBloc();
  _ViewDriverState(this.model);

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _bloc.driverChange(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.firstName} ${model.lastName}"),
      ),
      body: ListView(
        children: <Widget>[
          _buildProfileImage(),

          Container(
              margin: EdgeInsets.all(16), child: Text("Driver Information")),
          _buildInfo(),
          _buildLoading()
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
        SizedBox(height: 16),
        Text("Upload Photo", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
      ],
    );
  }


  Widget _profileImage() {
    final buttonSize = 100.0;
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
     
      setState(() {
       isLoading = true; 
      });
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

      setState(() {
       isLoading = false; 
      });
  }

  Widget _buildInfo() {

    // print("date_1: ${int.parse(model.driversLicenseExpireDate).runtimeType}");
    // print("date_2: ${DateTime(int.parse(model.driversLicenseExpireDate)).toIso8601String()}");
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
                Text("Drivers License"),
                Row(
                  children: <Widget>[
                    Text("${model.driversLicense}"),
                    SizedBox(width: 8),
                    InkWell(
                      child: model.driversLicenseUrl != null? Image.network(model.driversLicenseUrl, height: 24, width: 24): Icon(Icons.credit_card) ,
                      onTap: ()=> 
                        _showAddDialog(DialogOptions.LICENSE)
                      ,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            InkWell(
              onTap: () async{
                
                  final DateTime picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365*5))
                  );

                  setState(() {
                   model.driversLicenseExpireDate = "${picked.millisecondsSinceEpoch}"; 
                  });

                  _bloc.updateDriverInfo(model);
              },
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Drivers License Expiry"),
                Text(_getDate(int.parse(model.driversLicenseExpireDate)))
              ],
            ),
            )
            ,
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(!Utils.isTaxiAssociation(model.branch) ? "Branch/Division/Route" : "Route"),
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
                Text("Contact Number"),
                Text("${model.mobileNumber}")
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("PDP License"),
                Row(
                  children: <Widget>[
                    Text("${model.pdpLicense}"),
                    SizedBox(width: 8),
                    InkWell(
                      child:model.pdpLicenseUrl != null? Image.network(model.pdpLicenseUrl, height: 24, width: 24): Icon(Icons.credit_card),
                      onTap: ()=> 
                        _showAddDialog(DialogOptions.PDP)
                      ,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
             InkWell(
              onTap: () async{
                
                  final DateTime picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365*5))
                  );

                  setState(() {
                   model.pdpExpireDate = "${picked.millisecondsSinceEpoch}"; 
                  });

                  _bloc.updateDriverInfo(model);
              },
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("PDP Expiry"),
                Text("${_getDate(int.parse(model.pdpExpireDate))}")
              ],
            ),)
          ])),
    );
  }

  String _getDate(int date){
    print("date_n: $date");
    var dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  Future<void> _showAddDialog(DialogOptions option) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Options"),
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.pop(context, DialogOptions.VIEW);
                },
                title: const Text(
                  "View",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context, DialogOptions.EDIT);
                },
                title: const Text(
                  "Edit",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context, DialogOptions.DELETE);
                },
                title: const Text(
                  "Delete",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )
            ],
          );
        })) {
      case DialogOptions.VIEW:
      if(option == DialogOptions.LICENSE){
        if(model.driversLicenseUrl != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => ViewImagePage(model.driversLicenseUrl,
          )));
        }
      }else{
        if(model.pdpLicenseUrl != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => ViewImagePage(model.pdpLicenseUrl)),
          );
        }
      }
      break;
      case DialogOptions.EDIT:
      setState(() {
       isLoading = true; 
      });
        var downloadUrl = await Utils.loadImage(context);
        
      setState(() {
       isLoading = false; 
      });
        if(option == DialogOptions.LICENSE){
        setState(() {
         model.driversLicenseUrl = downloadUrl; 
        });
        }else{
          setState(() {
         model.pdpLicenseUrl = downloadUrl; 
        });
        _bloc.updateDriverInfo(model);
        }
        break;
      case DialogOptions.DELETE:
        if(option == DialogOptions.LICENSE){
        setState(() {
         model.driversLicenseUrl = null; 
        });
        }else{
          setState(() {
         model.pdpLicenseUrl = null; 
        });
        _bloc.updateDriverInfo(model);
        }
        break;
    }
  }

  Widget _buildLoading(){
    return Container(
      margin: EdgeInsets.all(16),
      child: isLoading ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      
        CircularProgressIndicator()
      ],
    ) : Container(),) ;
  }
}


enum DialogOptions { VIEW, EDIT, DELETE, PDP, LICENSE }