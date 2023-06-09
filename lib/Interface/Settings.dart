
import 'dart:async';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Classes/LogicClass.dart';
import '../Classes/TableClass.dart';
import '../Desktop/WidgetClass.dart';
import 'package:file_picker/file_picker.dart';

import 'MainInterface.dart';

Size? screenSize;
class SettingsPage extends StatefulWidget {

  // final Function() myFunction;
  // const ProductPage({Key? key, required this.data, required this.myFunction}) : super(key: key);
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void dispose(){
    super.dispose();
  }
  bool isEditing = false;
  bool updateImage = false;
  bool newProduct = false;
  bool processingImage = false;
  bool isMoving = true;
  bool pass = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final List<FocusNode> focusNode = List.generate(3, (index) => FocusNode());
  Map<String, dynamic> staffData = {};
  String? department = "Warehouse";
  String? staffID = "Warehouse" ;
  String tableHistory = "ProductHistory";
  String moveLocation = appName == "Warehouse" || appName == "Management"? "Showroom" : "Warehouse";

  int wBal = 0;
  int sBal = 0;



  Color labelColor = WidgetClass.mainColor;
  String? imagePath;
  List<File?> files = [];
  List<String> staffList = [];
  String? selectedStaff ;






  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async { });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;
    return  Scaffold(

      body:  Stack(
        children: [
          Positioned(
              top:10,
              left: screenSize!.width * 0.02,
              child: SizedBox(
                  child: Text("Add Staff", style: TextStyle(fontFamily: "Claredon", fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.03),))
          ),
          Positioned(
              top: screenSize!.height * 0.05,
              left: screenSize!.width * 0.02,
              child:SizedBox(
                  width:  screenSize!.width * 0.20,
                  child: TextField(
                    style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                    controller: nameController,
                    decoration:  InputDecoration(
                        errorStyle: const TextStyle(color: Colors.red),
                        prefixIcon: Icon(Icons.account_circle, color: labelColor,),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: labelColor, width: 2.0),
                        ),
                      label:  Text("Full Name", style: TextStyle(color: labelColor),)
                    ),
                  ))
          ),
          Positioned(
              top: screenSize!.height * 0.13,
              left: screenSize!.width * 0.02,
              child:SizedBox(
                  width:  screenSize!.width * 0.2,
                  child: TextField(
                    style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                    controller: emailController,
                    decoration:  InputDecoration(
                        errorStyle: const TextStyle(color: Colors.red),
                        prefixIcon: Icon(Icons.email_rounded, color: labelColor,),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: labelColor, width: 2.0),
                        ),
                        label:  Text("Email", style: TextStyle(color: labelColor))
                    ),
                  ))
          ),
          Positioned(
              top: screenSize!.height * 0.21,
              left: screenSize!.width * 0.02,
              child:SizedBox(
                  width:  screenSize!.width * 0.2,
                  child: TextField(
                    style:  TextStyle(fontSize:  screenSize!.height * 0.022),
                    obscureText: pass,
                    controller: passwordController,
                    decoration:  InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                pass = !pass;
                              });
                            },
                            child: Icon(pass? Icons.visibility : Icons.visibility_off, color:labelColor ,)),
                        errorStyle: const TextStyle(color: Colors.red),
                        prefixIcon: Icon(Icons.key, color: labelColor,),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: labelColor, width: 2.0),
                        ),
                        label:  Text("Password",style: TextStyle(color: labelColor))
                    ),
                  ))
          ),

          Positioned(
            top: screenSize!.height * 0.30,
            left: screenSize!.width * 0.02,
            child:   SizedBox(
              // height: 48,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Department", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mainColor),),
                  DropdownButton(
                      alignment: AlignmentDirectional.bottomStart,
                      isExpanded: false,
                      dropdownColor: mainColor.withOpacity(0.9),
                      style: const TextStyle(color: Colors.white),
                      selectedItemBuilder: (BuildContext context) {
                        return ["Warehouse", "Showroom"].map((String value) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      underline: Container(
                        height: 1,
                        color: mainColor,
                      ),
                      value: department,
                      items: ["Warehouse", "Showroom"]
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                          .toList(),
                      onChanged: (string) {
                        department = string!;
                        setState(() {});
                      }),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenSize!.height * 0.32,
            left: screenSize!.width * 0.13,
            child:   SizedBox(
              // height: 48,
              child:  MyCustomButton(
                  text: "Add Staff",
                  onPressed: () async {
                    if(nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty){
                      return;
                    }
                    if( emailController.text.contains("@") && emailController.text.toLowerCase().contains(".com") ){
                      if(passwordController.text.length >= 6){
                        showDialog<bool>(
                            context: context,
                            barrierColor: Colors.black54,
                            barrierDismissible: false,
                            builder:(BuildContext context) {
                              return  const LoadingDialog(title: 'Adding Staff...',);
                            });
                        addNewStaff().then((value) => {
                          Navigator.of(context).pop(),
                        });
                      }
                    }


                  },
                  icon: Icons.account_circle_outlined,
                  size: const Size(120, 40)
              ),
            ),
          ),
          Positioned(
            bottom: screenSize!.height * 0.1,
            left: screenSize!.width * 0.4,
            child:   SizedBox(
              // height: 48,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Version 3.7.9',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color:mainColor,
                      fontFamily: 'Claredon',
                    ),
                  ),

                  const SizedBox(height: 10,),
                  DownloadFileScreen(),
                  const SizedBox(height: 25,),

                  Text(
                    'Powered By Xenaya',
                    style: TextStyle(
                      fontSize: 16,
                      color: mainColor,
                      fontFamily: 'ThirstyBold',
                    ),
                  ),
                  Text(
                    '(C) 2023 MightyKens International Limited. All Rights reserved',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1.0,
                      color: mainColor,

                      fontFamily: 'Condensed',
                    ),
                  ),
                  Text(
                    'Support: godtech@gmail.com, Phone:0814 260 5775',
                    style: TextStyle(
                      fontSize: 12,
                      color: mainColor,
                      fontFamily: 'Claredon',
                    ),
                  ),
                ],
              ),
            ),
          ),









        ]
        ,
      )
      ,
    );
  }




  Future<bool> addNewStaff() async {
    try {
    staffData["Name"] = nameController.text.trim().toUpperCase();
    staffData["Email"] = emailController.text.trim().toLowerCase();
    staffData["Password"] = passwordController.text.trim();
    staffData["Department"] = department;
    staffData["StaffID"] = await FirebaseClass.getDynamic("Other", "Preferences", "StaffID");

    var success = await FirebaseClass.setDynamic("Staff", staffData["StaffID"], staffData);
    String newStaffID;
    int id = int.tryParse(staffData["StaffID"].replaceAll("ST", ""))??0;
    id = id+1;
    newStaffID = "ST$id";
    await FirebaseClass.updateDynamic("Other", "Preferences", {"StaffID": newStaffID});
    await FirebaseClass.addPasswordUser( staffData["Email"], staffData["Password"]);
    success = true;
   nameController.text = "";
   emailController.text = "";
   passwordController.text = "";
      return success;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }

  }


}

