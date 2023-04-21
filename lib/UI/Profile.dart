import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipPath(
              clipper: CustomClipPath()
              ,
              child: Container(
                height: screenSize.height / 2.5,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,

                    image: DecorationImage(image: AssetImage('assets/images/backgrounds/greenYellow.jpg'), fit: BoxFit.fill, opacity: 0.3, colorFilter: ColorFilter.mode(Colors.black, BlendMode.colorDodge))
                ),
                child: Stack(
                  children: [
                    const Positioned(top: 35,  left: 25, child: Text('Profile', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Claredon'),)),
                    Positioned(
                      top: screenSize.height /12,
                        left: screenSize.width /3,
                        child:  Container(
                          height: screenSize.width / 3.3,
                          width: screenSize.width / 3.2,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,

                            image: DecorationImage(
                              fit: BoxFit.scaleDown,
                                image: AssetImage('assets/images/profile.jpg')),

                            color: Colors.grey,),),
                    ),
                    Positioned(top:screenSize.height /3.5 -20,  left: screenSize.width /2.9, child: Text('Chukwuedo James ', style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.0, wordSpacing: 1.0, fontWeight: FontWeight.w600, fontFamily: 'BlackChy'),)),
                    Positioned(top:screenSize.height /3.5, left: screenSize.width /2.4 ,  child: Text('ID: GD001', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400, ),)),
                    Positioned( top:screenSize.height /4.8, left: screenSize.width /1.9,child: Container( height: 40, width: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green[700]), child: IconButton(icon: Icon(Icons.camera_alt, color: Colors.white, size: 18,), highlightColor: Colors.blue, onPressed: () {  },)),)
                  ],
                ),

              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: Text('Personal Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Claredon'),),
                  ),
                  SizedBox(height: 10,),
                  Row(children: [SizedBox(width: 10,), Icon(Icons.account_box),SizedBox(width: 20,), Text('Chukwuedo James') ],),
                  SizedBox(height: 10,),
                  Row(children: [SizedBox(width: 10,), Icon(Icons.phone),SizedBox(width: 20,), Text('0814 260 5775') ],),
                  SizedBox(height: 10,),
                  Row(children: [SizedBox(width: 10,), Icon(Icons.email),SizedBox(width: 20,), Text('johnn21795@gmail.com') ],),
                  SizedBox(height: 10,),
                  Row(children: [SizedBox(width: 10,), Icon(Icons.location_on_sharp),SizedBox(width: 20,), Text('CS 50 CornerStone Plaza Alaba') ],),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10.0, bottom: 10),
                    child: Text('Account Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Claredon'),),
                  ),
                  Row(children: [SizedBox(width: 10,), Icon(Icons.business_sharp),SizedBox(width: 20,), Text('Alaba Branch') ],),
                  SizedBox(height: 10,),
                  Row(children: [SizedBox(width: 10,), Icon(Icons.badge),SizedBox(width: 20,), Text('Senior Marketer') ],),
                  SizedBox(height: 10,),
                  Row(children: [SizedBox(width: 10,), Icon(Icons.radar_rounded),SizedBox(width: 20,), Text('100 Customers') ],),

                ],
              ),)
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


    path.lineTo(0, h -70);
    path.quadraticBezierTo(w * 0.5, h , w, h-70,);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;

  }
}
