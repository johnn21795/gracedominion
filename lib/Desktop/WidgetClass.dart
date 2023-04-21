
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

