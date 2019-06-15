import 'package:flutter/material.dart';
import 'package:owner/blocs/add_driver_bloc.dart';
import 'package:owner/irrelevant.dart';
import 'package:owner/widgets/FormTextInput.dart';
import 'package:owner/widgets/form_listview.dart';

class AddDriverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriverPage> {
  final _bloc = AddDriverBloc();
  DateTime selectedLicenseExpiryDate;
  DateTime selectedPDPExpiryDate;
  @override
  void initState() {
    super.initState();
    _bloc.driverCreateStream.listen((Irrelevant ir) {
      if (ir != null) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Driver")),
      body: FormListView(
        children: <Widget>[
          _buildFirstName(),
          _buildLastName(),
          _buildMobileNumber(),
          _buildEmail(),
          _buildDriversLicense(),
          _buildDriversLicenseExpireDate(),
          _buildPDPLicense(),
          _buildPDPLicenseExpireDate(),
          _buildBranch(),
          _buildCreateDriverButton()
        ],
      ),
    );
  }

  Widget _buildFirstName() {
    return FormTextInput(
      hint: "First Name",
      stream: _bloc.firstNameError,
      onChange: _bloc.firstNameChanged,
    );
  }

  Widget _buildLastName() {
    return FormTextInput(
      hint: "Last Name",
      stream: _bloc.lastNameError,
      onChange: _bloc.lastNameChanged,
    );
  }

  Widget _buildMobileNumber() {
    return FormTextInput(
        isNumber: true,
        hint: "Mobile Number",
        stream: _bloc.mobileNumberError,
        onChange: _bloc.mobileNumberChanged);
  }

  Widget _buildDriversLicense() {
    return FormTextInput(
      hint: "Driver License Number",
      stream: _bloc.driversLicenseError,
      onChange: _bloc.driversLicenseChanged,
    );
  }

  Widget _buildPDPLicense() {
    return FormTextInput(
      hint: "PDP License Number",
      stream: _bloc.pdpLicenseError,
      onChange: _bloc.pdpLicenseChanged,
    );
  }

  Widget _buildEmail() {
    return FormTextInput(
      hint: "Email",
      stream: _bloc.emailError,
      onChange: _bloc.emailChanged,
    );
  }

  Widget _buildBranch() {
    return FormTextInput(
      hint: "Branch / Division / Route",
      stream: _bloc.branchError,
      onChange: _bloc.branchChanged,
    );
  }

  Widget _buildDriversLicenseExpireDate() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Text(selectedLicenseExpiryDate == null? "Drivers License Expire Date" : "Drivers License Expire Date: ${selectedLicenseExpiryDate.day}/${selectedLicenseExpiryDate.month}/${selectedLicenseExpiryDate.year}", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      onTap: () async{
                final DateTime picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365*10))
              );

                setState((){
                  selectedLicenseExpiryDate = picked;
                });
              _bloc.driversLicenseExpireDateChanged("${picked.millisecondsSinceEpoch}");
      },
    );
  }

  Widget _buildCreateDriverButton() {
    return StreamBuilder<bool>(
      stream: _bloc.enableButton,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MaterialButton(
              onPressed: () => _bloc.createDriverPressed(Irrelevant.Instance),
              child: const Text("CREATE DRIVER"),
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
              child: const Text("CREATE DRIVER"),
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          );
        }
      },
    );
  }

  Widget _buildPDPLicenseExpireDate() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Text(selectedPDPExpiryDate == null? "PDP License Number Expire Date" : "PDP License Number Expire Date: ${selectedPDPExpiryDate.day}/${selectedPDPExpiryDate.month}/${selectedPDPExpiryDate.year}", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      onTap: () async{
                final DateTime picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365*10))
              );

                setState((){
                  selectedPDPExpiryDate = picked;
                });
              _bloc.pdpExpireDateChanged("${picked.millisecondsSinceEpoch}");
      },
    );
  }
}
