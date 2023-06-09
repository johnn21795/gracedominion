import 'dart:convert';
import 'dart:io';

import 'package:bouncing_draggable_dialog/bouncing_draggable_dialog.dart';
import 'package:firebase_dart/auth.dart';
import 'package:gracedominion/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Classes/MainClass.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

@override
  void initState() {
    super.initState();


  }


  bool pass = true;
  String id = "James";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Platform.isWindows?  desktopView() :  mobileView();
  }
  void requestPermissions() async{
    print(Platform.pathSeparator);
    print(Platform.operatingSystemVersion);
    Map<Permission, PermissionStatus> stats ;
    try {
      stats = await [ Permission.storage, Permission.camera, Permission.accessMediaLocation,Permission.manageExternalStorage, ].request();
      for (var element in stats.values) {
        if(element.isDenied){
          // requestPermissions();
        }
      }
    } catch (e) {
      print(e);
    }


    MainClass.loadStaffInformation();
    // if(stats.values.first.isDenied){
    //   requestPermissions();
    // }

  }

Widget mobileView(){
  Size screenSize = MediaQuery.of(context).size;
  return Scaffold(
    body: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        height: screenSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                height: screenSize.height / 2.4,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/backgrounds/purplegold.jpg'),
                        fit: BoxFit.fill,
                        opacity: 0.35,
                        colorFilter: ColorFilter.mode(
                            Colors.black, BlendMode.colorDodge))),
                child: Stack(
                  children: [
                    Positioned(
                        top: screenSize.width / 12,
                        left: 30,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Claredon'),
                        )),
                    Positioned(
                        top: screenSize.height / 14,
                        width: screenSize.width,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:  [
                              Container(
                                height: screenSize.width / 4,
                                width: screenSize.width / 4,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.scaleDown,
                                      image: AssetImage('assets/images/profile.jpg')),
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                'Grace Dominion',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    // letterSpacing: 1.0,
                                    wordSpacing: 4.0,
                                    // fontWeight: FontWeight.w600,
                                    fontFamily: 'majoris'),
                              ),
                              const Text(
                                'Making People Smile...',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    // letterSpacing: 1.0,
                                    wordSpacing: 4.0,
                                    // fontWeight: FontWeight.w600,
                                    fontFamily: 'Claredon'),
                              ),
                            ],
                          ),
                        )),
                    // Positioned(
                    //   top: 60,
                    //   width: screenSize.width,
                    //   child: Container(
                    //     height: screenSize.width / 4,
                    //     width: screenSize.width / 4,
                    //     decoration: const BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       image: DecorationImage(
                    //           fit: BoxFit.scaleDown,
                    //           image: AssetImage('assets/images/profile.jpg')),
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            SizedBox(
              width: screenSize.width * 0.8,
              child:  TextField(
                controller: controller,
                onChanged: (value){
                  id = value;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  hintText: "Enter Name or ID ",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  label: Text(
                    "Name",
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: screenSize.width * 0.8,
                child: TextField(
                  obscureText: pass,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            pass = !pass;
                          });
                        },
                        child: Icon(pass? Icons.visibility : Icons.visibility_off)),
                    hintText: "Password",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    label: const Text(
                      "Password",
                      style: TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: screenSize.width * 0.8,
                height: 50,
                child: ElevatedButton(
                  onPressed: ()  async {
                    // MainClass.updateDB("CREATE TABLE IF NOT EXISTS Printout (Date String,CardNo String, Amount INTEGER)", []);
                    // MainClass.staff = id;
                    // await MainClass.getTodayBalance(DateTime.now());
                    // MainClass.loadStaffInformation();
                    // requestPermissions();

                    // var result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "johnn21795@gmail.com", password: "123456");

                    //   final window = await DesktopMultiWindow.createWindow(jsonEncode({
                    //         'args1': 'Sub window',
                    //         'args2': 100,
                    //         'args3': true,
                    //
                    // }));
                    //        window.show();

                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context,) {
                        double height = 150;
                        bool isPassword = false;
                        Color color = Colors.white;
                        return StatefulBuilder(builder: (context, setState){
                          return
                            // backgroundColor:  color,
                            // contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            SizedBox(
                              height: height,
                              width: 500,
                              child: Container(
                                color:const Color(0x00BEBEBE),
                                child:
                                isPassword ? FutureBuilder(
                                    future: allPayments(),
                                    builder: (context, snapshot) {

                                      return paymentHistory();
                                    })
                                    : Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      const Text("Administrator Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Claredon'),),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                                        child: TextField(
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.key),
                                            hintText: "Password",
                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                            label: Text(
                                              "Password",
                                              style: TextStyle(
                                                textBaseline: TextBaseline.alphabetic,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: SizedBox(
                                          height: 40,
                                          width: 200,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isPassword = true;
                                                height = 350;
                                                color = const Color(0xBBFFFFFF);
                                              });


                                            },
                                            child: const Text("Show Payments"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ;},
                        );
                      },
                    );



                    // Navigator.pushReplacementNamed(context, AppRoutes.newCustomer);
                  },
                  child: const Text("Login"),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(),
            ),
            ClipPath(
              clipper: CustomClipPath2(),
              child: Container(
                height: screenSize.height / 6,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/backgrounds/purplegold.jpg'),
                        fit: BoxFit.fill,
                        opacity: 0.35,
                        colorFilter: ColorFilter.mode(
                            Colors.black, BlendMode.colorDodge))),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 30,
                      width: screenSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Text(
                            'Powered By Xenaya',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'ThirstyBold',
                            ),
                          ),
                          Text(
                            '(C) 2022 Grace Dominion Limited. All Rights reserved',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1.0,
                              color: Colors.white,

                              fontFamily: 'Condensed',
                            ),
                          ),
                          Text(
                            'Support: godtech@gmail.com, Phone:0814 260 5775',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontFamily: 'Claredon',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget desktopView(){
  Size screenSize = MediaQuery.of(context).size;
  return Scaffold(
    body: Container(
      height: screenSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: screenSize.height / 2.5,
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/backgrounds/purple.jpg'),
                      fit: BoxFit.fill,
                      opacity: 0.35,
                      colorFilter: ColorFilter.mode(
                          Colors.black, BlendMode.colorDodge))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: screenSize.width / 4,
                      width: screenSize.width / 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: AssetImage('assets/images/dominion.jpg')),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            transform: Matrix4.translationValues(0, -25, 0),
            child: const Padding(
              padding: EdgeInsets.only(left: 120.0),
              child: Text(
                'Login',
                style: TextStyle(
                    color: Color(0xff50025d),
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Claredon'),
              ),
            ),
          ),
          SizedBox(
            width: screenSize.width * 0.6,
            child:  TextField(
              controller: controller,
              onChanged: (value){
                id = value;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                hintText: "Enter Name or ID ",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                label: Text(
                  "Name",
                  style: TextStyle(textBaseline: TextBaseline.alphabetic),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: screenSize.width * 0.6,
              child: TextField(
                obscureText: pass,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          pass = !pass;
                        });
                      },
                      child: Icon(pass? Icons.visibility : Icons.visibility_off)),
                  hintText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  label: const Text(
                    "Password",
                    style: TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: screenSize.width * 0.6,
              height: 50,
              child: ElevatedButton(
                onPressed: ()  async {
                  // MainClass.updateDB("CREATE TABLE IF NOT EXISTS Printout (Date String,CardNo String, Amount INTEGER)", []);
                  // MainClass.staff = id;
                  // await MainClass.getTodayBalance(DateTime.now());
                  // MainClass.loadStaffInformation();
                  // requestPermissions();

                  // var result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "johnn21795@gmail.com", password: "123456");

                  //   final window = await DesktopMultiWindow.createWindow(jsonEncode({
                  //         'args1': 'Sub window',
                  //         'args2': 100,
                  //         'args3': true,
                  //
                  // }));
                  //        window.show();


                  Navigator.pushReplacementNamed(context, Platform.isWindows? AppRoutes.operatorDashboard : AppRoutes.login);
                },
                child: const Text("Login"),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(),
          ),
          ClipPath(
            clipper: CustomClipPath2(),
            child: Container(
              height: screenSize.height / 5.2,
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/backgrounds/purple.jpg'),
                      fit: BoxFit.fill,
                      opacity: 0.35,
                      colorFilter: ColorFilter.mode(
                          Colors.black, BlendMode.colorDodge))),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 10,
                    width: screenSize.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Text(
                          'Powered By Xenaya',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'ThirstyBold',
                          ),
                        ),
                        Text(
                          '(C) 2023 Grace Dominion Limited. All Rights reserved',
                          style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 1.0,
                            color: Colors.white,

                            fontFamily: 'Condensed',
                          ),
                        ),
                        Text(
                          'Support: godtech@gmail.com, Phone:0814 260 5775',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontFamily: 'Claredon',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}







class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h * 0.8);
    path.quadraticBezierTo(
      w * 0.25,
      h * 0.7,
      w * 0.5,
      h * 0.8,
    );
    path.quadraticBezierTo(
      w * 0.85,
      h * 0.95,
      w,
      h * 0.8,
    );
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomClipPath2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.quadraticBezierTo(
      w * 0.25,
      h * 0.3,
      w * 0.5,
      h * 0.2,
    );
    path.quadraticBezierTo(
      w * 0.85,
      h * 0.05,
      w,
      h * 0.2,
    );
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
Future<Future<List<Map<String, dynamic>>?>> allPayments () async {
  return MainClass.loadFireBaseAppInformation();
}

Widget paymentHistory()   {
  return ListView.builder(itemCount: 4,
    // controller: scrollController,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical:5),
        child: Container(
          decoration: const BoxDecoration(
            color:Color(0xFFFCFFFB),
            boxShadow: [
              BoxShadow(
                  color: Color(0x55000000),
                  offset: Offset(1.0, 2.0),
                  blurRadius: 1.0,
                  spreadRadius: 1.5
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            height: 45,
            child: Stack(
              children:  [
                Positioned(
                  top: 3,
                  left: 10,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 13, ),
                      const SizedBox(width: 5,),
                      Text("James", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,fontFamily: 'claredon', ),),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top:3,
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money_outlined, size: 15,),
                      Text("5000", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,  fontFamily: 'claredon', letterSpacing: 1.5),),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 10,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 9,),
                      Text("21/7/95", style: const TextStyle(fontSize: 8),),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 5,
                  child: Row(
                    children: [
                      const Icon(Icons.account_circle, size: 11,),
                      const SizedBox(width: 5,),
                      Text("Mike", style: const TextStyle(fontSize: 11, fontFamily: 'claredon',),),
                    ],
                  ),
                ),

              ],
            ),
          ),

        ),
      );

    },
  );
}
