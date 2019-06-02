import 'package:flutter/material.dart';

class FormListView extends StatelessWidget {
  final List<Widget> children;

  FormListView({this.children});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        )
      ],
    );
  }
}
