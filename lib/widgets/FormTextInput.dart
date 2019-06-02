import 'package:flutter/material.dart';

class FormTextInput extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChange;
  final Stream stream;
  final EdgeInsets padding;

  FormTextInput(
      {this.hint,
      this.onChange,
      this.stream,
      this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    if (stream != null) {
      return StreamBuilder<String>(
          stream: stream,
          initialData: null,
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return Padding(
                padding: padding,
                child: TextField(
                  decoration: InputDecoration(hintText: hint),
                  onChanged: onChange,
                ),
              );
            } else {
              return Padding(
                padding: padding,
                child: TextField(
                  decoration:
                      InputDecoration(hintText: hint, errorText: snapshot.data),
                  onChanged: onChange,
                ),
              );
            }
          });
    } else {
      return Padding(
        padding: padding,
        child: TextField(
          decoration: InputDecoration(hintText: hint),
          onChanged: onChange,
        ),
      );
    }
    ;
  }
}
