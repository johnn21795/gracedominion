import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Column(
          children: [

            Container(
              color: Colors.white,
              child:
                Stack(
                  children: [
                    ClipPath(
                      clipper: CustomClipPath(),
                      child: Container(
                        height: screenSize.height /3.6,
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,

                            image: DecorationImage(image: AssetImage('assets/images/backgrounds/greenYellow.jpg'), fit: BoxFit.fill, opacity: 0.3, colorFilter: ColorFilter.mode(Colors.black, BlendMode.colorDodge))
                        ),
                        child:
                        Stack(
                          children: [
                            Positioned(top: 30,  left: 20, child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Claredon'),)),
                            Positioned(
                              top: 65,
                              left: screenSize.width /12,
                              child:  Container(
                                height: screenSize.width / 4.5,
                                width: screenSize.width / 4.5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  image: const DecorationImage(
                                      fit: BoxFit.scaleDown,
                                      image: AssetImage('assets/images/profile.jpg')),

                                  color: Colors.grey,),),
                            ),
                            Positioned(
                              top: screenSize.height / 9,  left: screenSize.width /2.9, child:  Column(
                                        children: [
                                          Text(
                                            'Grace Dominion',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontFamily: 'Copper'
                                            ),
                                          ),
                                          Text(
                                            'Version: 1.0.2',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Claredon',
                                                decoration: TextDecoration.underline,
                                                color: Colors.blue[300]

                                            ),
                                          ),
                                        ],
                                      ),),

                          ],
                        ),

                      ),
                    ),
                  ]
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenSize.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 0.5,
                          spreadRadius: 2.0,
                          color: Colors.black26)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.shield_sharp,
                      size: 25,
                      color: Color(0xff1b6606),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Privacy and Security',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenSize.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 0.5,
                          spreadRadius: 2.0,
                          color: Colors.black26)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.palette,
                      size: 25,
                      color: Color(0xff1b6606),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenSize.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 0.5,
                          spreadRadius: 2.0,
                          color: Colors.black26)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.help,
                      size: 25,
                      color: Color(0xff1b6606),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Help',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenSize.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 0.5,
                          spreadRadius: 2.0,
                          color: Colors.black26)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.sync,
                      size: 25,
                      color: Color(0xff1b6606),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: screenSize.height / 4,
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenSize.width,
                    height: screenSize.height / 4,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.5,
                              spreadRadius: 1.0,
                              color: Colors.black26)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          height: screenSize.width / 5,
                          width: screenSize.width / 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                                fit: BoxFit.scaleDown,
                                image: AssetImage('assets/images/profile.jpg')),

                            color: Colors.grey,),),
                        Text(
                          'Powered By Xenaya',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'ThirstyBold',
                          ),
                        ),
                        Text(
                          '(C) 2022 Grace Dominion Limited. All Rights reserved',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            wordSpacing: 1.0,
                            fontFamily: 'Condensed',
                          ),
                        ),
                        Text(
                          'Support: godtech@gmail.com, Phone:0814 260 5775',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Claredon',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

    path.lineTo(0, h * 0.75 );
    path.quadraticBezierTo(
      w * 0.25,
      h ,
      w * 0.6,
      h * 0.85,
    );
    path.quadraticBezierTo(
      w * 0.9,
      h * 0.7 ,
      w ,
      h * 0.85 ,
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
