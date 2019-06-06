import "dart:io";

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import 'package:path_provider/path_provider.dart';
import "package:uuid/uuid.dart";

List<CameraDescription> cameras;
int cameraIndex = 0;

enum CameraDirection { FRONT, BACK }

class ProfileEditCamera extends StatefulWidget {
  State<StatefulWidget> createState() => ProfileEditCameraState();
}

class ProfileEditCameraState extends State<ProfileEditCamera> {
  File _image;
  CameraDirection cameraDirection = CameraDirection.FRONT;
  CameraController cameraController;

  @override
  void initState() {
    super.initState();
    _configureSaveDirectory();
   setCameras();
  }

  setCameras() async{
    cameras = await availableCameras();
     if (cameras.length > 1) {
      setCamera(CameraDirection.FRONT);
    } else {
      setCamera(CameraDirection.BACK);
    }
  }

  setCamera(CameraDirection direction) {
    if (direction == CameraDirection.FRONT) {
      cameraController = CameraController(cameras[1], ResolutionPreset.high);
    } else {
      cameraController = CameraController(cameras[0], ResolutionPreset.high);
    }
    cameraController.initialize().then((_) {
      setState(() {
        cameraDirection = direction;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          cameraController.value.isInitialized != true
              ? Container(color: Colors.black)
              : AspectRatio(
                  aspectRatio: cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
          InkWell(
            onTap: () {
              Navigator.pop(context, _image);
            },
            child: Container(
              margin: EdgeInsets.only(top: 32.0, left: 16.0),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 25.0),
                    child: _cameraButton(context),
                  ),
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  cameras.length > 1
                      ? Container(
                          margin: EdgeInsets.only(bottom: 50.0),
                          height: 50.0,
                          child: _flipCameraButton(),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(bottom: 50.0),
                    height: 50.0,
                    child: _galleryButton(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _takePicture(context) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final directoryPath = "${appDocDir.path}/profile_images";
    var directory = Directory(directoryPath);
    final directoryExists = await directory.exists();
    if (!directoryExists) {
      directory = await directory.create(recursive: true);
    }
    final filePath = "${directory.path}/profileImage_${Uuid().v1()}.jpg";
    await cameraController.takePicture(filePath).then((onValue) {
      setState(() {
        _image = File(filePath);
        Navigator.pop(context, _image);

      });
    });
  }

  void _imageFromLibrary() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final directoryPath = "${appDocDir.path}/profile_images";
    var directory = Directory(directoryPath);
    final directoryExists = await directory.exists();
    if (!directoryExists) {
      directory = await directory.create(recursive: true);
    }
    setState(() {
      if (imageFile != null) {
        _image = imageFile;
        Navigator.pop(context, _image);
      }
    });
  }

  Widget _galleryButton() {
    final buttonSize = 50.0;
    return InkWell(
      child: Container(
        child: _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(buttonSize * 0.5),
                child: Image.file(
                  _image,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(Icons.camera_roll),
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(buttonSize * 0.5)),
      ),
      onTap: _imageFromLibrary,
    );
  }

  Widget _flipCameraButton() {
    final buttonSize = 50.0;
    return InkWell(
      child: Container(
        child: Icon(
          cameraDirection == CameraDirection.FRONT
              ? Icons.camera_rear
              : Icons.camera_front,
          size: 30.0,
        ),
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(buttonSize * 0.5)),
      ),
      onTap: () {
        final newCameraDirection = cameraDirection == CameraDirection.FRONT
            ? CameraDirection.BACK
            : CameraDirection.FRONT;
        setCamera(newCameraDirection);
      },
    );
  }

  Widget _cameraButton(context) {
    final buttonSize = 100.0;
    return InkWell(
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromRGBO(128, 128, 128, 1.0), width: 8.0),
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(buttonSize * 0.5)),
      ),
      onTap: () {
        _takePicture(context);
      },
    );
  }

  void _configureSaveDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final directoryPath = "${appDocDir.path}/profile_images";
    final directory = Directory(directoryPath);
    final directoryExists = await directory.exists();
    if (directoryExists) {
      directory.delete(recursive: true);
    }
  }
}
