
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TextField_for_Auth extends StatelessWidget {

  final String labelText;
  final String hintText;
  final IconData iconss;
  final Function(String) onValueChanged;
  final String? Function(String?)? validationFunction;
  TextField_for_Auth({ required this.labelText, required this.hintText, required this.iconss, required this.onValueChanged, required this.validationFunction});

  void notifyValueChanged(String changedValue) {
    onValueChanged(changedValue);
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(

      validator: validationFunction,


      onChanged: (val){
        notifyValueChanged(val);
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0.0),
        labelText: '$labelText',
        hintText: '$hintText',
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
        ),
        prefixIcon: Icon(
          iconss,
          color: Colors.black,
          size: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}