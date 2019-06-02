import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/blocs/add_manager_bloc.dart';
import 'package:worksent_sesfikile/irrelevant.dart';
import 'package:worksent_sesfikile/widgets/FormTextInput.dart';

class AddManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddManagerState();
}

class _AddManagerState extends State<AddManagerPage> {
  final _bloc = AddManagerBloc();

  @override
  void initState() {
    super.initState();
    _bloc.managerCreateStream.listen((Irrelevant ir) {
      if (ir != null) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Manager")),
      body: ListView(
        children: <Widget>[
          _buildFirstName(),
          _buildLastName(),
          _buildMobileNumber(),
          _buildEmail(),
          _buildDriversLicense(),
          _buildBranch(),
          _buildAddress(),
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
        hint: "Mobile Number",
        stream: _bloc.mobileNumberError,
        onChange: _bloc.mobileNumberChanged);
  }

  Widget _buildEmail() {
    return FormTextInput(
      hint: "Email",
      stream: _bloc.emailError,
      onChange: _bloc.emailChanged,
    );
  }

  Widget _buildDriversLicense() {
    return FormTextInput(
      hint: "Driver License Number",
      stream: _bloc.driversLicenseError,
      onChange: _bloc.driversLicenseChanged,
    );
  }

  Widget _buildBranch() {
    return FormTextInput(
      hint: "Branch / Division / Route",
      stream: _bloc.branchError,
      onChange: _bloc.branchChanged,
    );
  }

  Widget _buildAddress() {
    return FormTextInput(
      hint: "Address",
      stream: _bloc.addressError,
      onChange: _bloc.addressChanged,
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
              onPressed: () => _bloc.createManagerPressed(Irrelevant.Instance),
              child: const Text("CREATE MANAGER"),
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
              child: const Text("CREATE MANAGER"),
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
