
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class WidgetClass{
  static Color defaultColor = Colors.black45;
   static Widget mainNavigationButton(bool isHover, String text, IconData icon,
      Function(bool)? onHover, Function() onPressed,  [Size size = const Size(150, 50)]) {
    return ElevatedButton.icon(icon: FaIcon(icon, size: 20,
        color: isHover ? Colors.purple : defaultColor = Colors.white),
      onPressed: onPressed,
      onHover: onHover,
      label: Text(text, style: TextStyle(
          color: isHover ? Colors.purple : defaultColor = Colors.white, fontSize: 13), ),
      style:
      ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        fixedSize: size,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0)),
        backgroundColor:
        isHover ? Colors.white : defaultColor = Colors.purple,
      ),
    );
  }
}

class MainNavigation{
  static Color defaultColor = Colors.black45;
  static Widget mainNavigationButton(bool isHover, String text, IconData icon,
      Function(bool)? onHover, Function() onPressed,  [Size size = const Size(150, 50)]) {
    return ElevatedButton.icon(icon: FaIcon(icon, size: 20,
        color: isHover ?  Color(0xff004400) : defaultColor = Colors.white),
      onPressed: onPressed,
      onHover: onHover,
      label: Text(text, style: TextStyle(
          color: isHover ? Color(0xff004400) : defaultColor = Colors.white, fontSize: 13), ),
      style:
      ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        fixedSize: size,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0)),
        backgroundColor:
        isHover ? Colors.white : defaultColor =  Color(0xff008000),
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

