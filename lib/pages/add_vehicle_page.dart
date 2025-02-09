import 'package:flutter/material.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:owner/blocs/add_vehicle_bloc.dart';
import 'package:owner/widgets/FormTextInput.dart';
import 'package:owner/widgets/form_listview.dart';

import '../irrelevant.dart';

class AddVehiclePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AddVehicleState();

}

class _AddVehicleState extends State<AddVehiclePage>{
  final _bloc = AddVehicleBloc();
  String placeName;

  @override
  void initState() {
    super.initState();
    _bloc.vehicleCreateStream.listen((Irrelevant ir) {
      if (ir != null) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Add Vehicle")),
      body: FormListView(
        children: <Widget>[
          _buildVehicleType(),
          _buildBrand(),
          _buildNumberPlate(),
          _buildYear(),
          _buildBranch(),
          _buildCurrentKMs(),
          _buildStorageAddress(),
          _buildInsurance(),
          _buildRegistration(),
          _buildCreateVhicleButton()
        ],
      ),
    );
  }

  Widget _buildVehicleType() {
    return FormTextInput(
      hint: "Type of Vehicle",
      stream: _bloc.vehicleTypeError,
      onChange: _bloc.vehicleTypeChanged,
    );
  }

  Widget _buildBrand() {
    return FormTextInput(
      hint: "Brand",
      stream: _bloc.brandError,
      onChange: _bloc.brandChanged,
    );
  }

  Widget _buildNumberPlate() {
    return FormTextInput(
      hint: "Number Plate",
      stream: _bloc.numberPlateError,
      onChange: _bloc.numberPlateChanged,
    );
  }

  Widget _buildYear() {
    return FormTextInput(
      isNumber: true,
      hint: "Year",
      stream: _bloc.yearError,
      onChange: _bloc.yearChanged,
    );
  }

  Widget _buildBranch() {
    return FormTextInput(
      hint: "Branch",
      stream: _bloc.branchError,
      onChange: _bloc.branchChanged,
    );
  }

  Widget _buildCurrentKMs() {
    return FormTextInput(
      isNumber: true,
      hint: "Current KMs",
      stream: _bloc.currentKMError,
      onChange: _bloc.currentKMChanged,
    );
  }

  Widget _buildStorageAddress() {
    return InkWell(
      child: Container(padding: EdgeInsets.all(16),child:Text(placeName == null ? "Vehicle Storage Address":placeName, style: TextStyle(fontWeight: FontWeight.bold),)  ,),
      onTap: () async{
        var place = await PluginGooglePlacePicker.showAutocomplete(mode: PlaceAutocompleteMode.MODE_FULLSCREEN, countryCode: "ZA");
        _bloc.vehicleAddressChanged(place.name);
        setState(() {
          placeName = place.name;
        });
      },
    );
  }

  Widget _buildInsurance() {
    return FormTextInput(
      hint: "Insurance Company - not required",
      stream: null,
      onChange: _bloc.insuranceCompanyChanged,
    );
  }

  Widget _buildRegistration() {
    return FormTextInput(
      hint: "Registration",
      stream: _bloc.vehicleRegistrationError,
      onChange: _bloc.vehicleRegistrationChanged,
    );
  }

  Widget _buildCreateVhicleButton() {
    return StreamBuilder<bool>(
      stream: _bloc.enableButton,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MaterialButton(
              onPressed: () => _bloc.createVehiclePressed(Irrelevant.Instance),
              child: const Text("CREATE VEHICLE"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MaterialButton(
              disabledColor: const Color(0xFFF5F5F5),
              child: const Text("CREATE VEHICLE"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          );
        }
      },
    );
  }
}