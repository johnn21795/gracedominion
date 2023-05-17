
import 'dart:async';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../Interface/MainInterface.dart';
import '../Interface/Product.dart';



class WidgetClass{
  static Color defaultColor = Colors.black45;
  static  Color mainColor = Color(0xff000077);
}


class MySavedPreferences {
  static final MySavedPreferences _instance = MySavedPreferences._internal();
  static final Map<String, dynamic> _sharedPreferences = {};

  factory MySavedPreferences() {
    return _instance;
  }

  MySavedPreferences._internal();

  static void addPreference(String key, dynamic value) {
    _sharedPreferences[key] = value;
    print("key $key value $value");
  }

  static dynamic getPreference(String key) {
    dynamic value = _sharedPreferences[key];
    print("get key $key value $value");
    return value ?? 0.0;
  }
}


class MyFloatingActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const MyFloatingActionButton({super.key, required this.text, required this.onPressed});

  @override
  MyFloatingActionButtonState createState() => MyFloatingActionButtonState();
}

class MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool _isHovering = false;
  static const Duration _animationDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (isHovering) {
        setState(() { _isHovering = isHovering;});},
      child: AnimatedContainer(
        duration: _animationDuration,
        width: _isHovering ? 150 : 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: _isHovering ? Colors.white70: WidgetClass.mainColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _isHovering ? Center(child: Text(widget.text, style:  TextStyle(color: WidgetClass.mainColor, fontWeight: FontWeight.bold),)) :
          Icon(Icons.add, color: !_isHovering ? Colors.white: WidgetClass.mainColor,),
        ),
      ),
    );
  }
}

class MyCustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Size size;

  const MyCustomButton({super.key, required this.text, required this.onPressed, required this.icon, required this.size, } );

  @override
  MyCustomButtonState createState() => MyCustomButtonState();
}

class MyCustomButtonState extends State<MyCustomButton> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: FaIcon( widget.icon,
          size: widget.size.height * 0.5,
          color: _isHovering ?  WidgetClass.mainColor : Colors.white
      ),
      onPressed: widget.onPressed,
      onHover: (isHovering) {
        _isHovering = isHovering;
        setState(() {});
      },
      label: Text(
        widget.text,
        style: TextStyle(
            color: _isHovering ? WidgetClass.mainColor : Colors.white,
            fontSize: widget.size.height / 3),
      ),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        backgroundColor:_isHovering ?   Colors.white : WidgetClass.mainColor,
        fixedSize: widget.size,
        shape:widget.size.height == 42? RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)) : RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }
}





class CustomerInformation {
  String name = "Chukwuedo Jame2s";
  String phone = "08142605775";
  String address = "CS 60 CornerStone Plaza, Alaba Int'l Market Ojo Lagos";
  String date = "11/10/2022";
  String status = "Active";
  String cardNo  = "Active" ;


  static Map<String, dynamic> data = {
    "Address":"",
    "Amount":0,
    "AuditDate":"",
    "Branch":"",
    "CardNo":"",
    "CardPackage":"",
    "CardType":"",
    "ClearedDate":"",
    "ClearedTimes":"",
    "CollectedBy":"",
    "DateOfReg":"",
    "Image":"",
    "LastAudit":"",
    "LastClearedDate":"",
    "LastMark":"",
    "LastPayAmt":0,
    "LastDate":"",
    "Name":"",
    "Percentage":0.0,
    "Period":"",
    "Phone":"",
    "SecondRnd":"",
    "StaffReg":"",
    "StartDate":"",
    "Status":"",
    "Status2":"",
    "TotalAmtPaid":0,
    "TotalAmtPayable":0,
    "TotalBalRem":0,
  };

  static Map<String, dynamic> defaultData = {
    "Address":"",
    "Amount":0,
    "AuditDate":"",
    "Branch":"",
    "CardNo":"",
    "CardPackage":"",
    "CardType":"",
    "ClearedDate":"",
    "ClearedTimes":"",
    "CollectedBy":"",
    "DateOfReg":"",
    "Image":"",
    "LastAudit":"",
    "LastClearedDate":"",
    "LastMark":"",
    "LastPayAmt":0,
    "LastDate":"",
    "Name":"",
    "Percentage":0.0,
    "Period":"",
    "Phone":"",
    "SecondRnd":"",
    "StaffReg":"",
    "StartDate":"",
    "Status":"",
    "Status2":"",
    "TotalAmtPaid":0,
    "TotalAmtPayable":0,
    "TotalBalRem":0,
  };
  static Map<String, dynamic> getInfo(){
    return data;
  }

}

