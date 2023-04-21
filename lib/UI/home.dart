import 'package:gracedominion/Classes/MainClass.dart';
import 'package:gracedominion/UI/CollectPayment.dart';
import 'package:gracedominion/UI/Customers.dart';
import 'package:gracedominion/UI/Printout.dart';
import '../AppRoutes.dart';
import 'package:flutter/material.dart';

import 'NewCustomer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          //Wallet Area
          Column(
            children: [
              Stack(children: [
                ClipPath(
                  clipper: CustomClipPath(),
                  child: Container(
                    height: screenSize.height / 2.4,
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/backgrounds/greenDark.jpg'),
                            fit: BoxFit.fill,
                            opacity: 0.3,
                            colorFilter: ColorFilter.mode(
                                Colors.black, BlendMode.colorDodge))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: screenSize.height / 14,
                              width: screenSize.height / 14,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/profile.jpg')),
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                             Text(
                              "Welcome, ${MainClass.staff}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                  fontFamily: "BlackChy"),
                            ),
                            const Expanded(child: SizedBox( )),
                            //Menu Button not visible
                            IconButton(
                              icon: const Icon(Icons.menu),
                              color: Color(0x00ffffff),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        const Center(
                            child: Text(
                          "Today's Balance:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2.0,
                            fontSize: 20,
                            fontFamily: 'Condensed',
                          ),
                        )),
                         Center(
                            child:
                                Text(MainClass.returnCommaValue(MainClass.todayBalance.toString()) ,
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'majoris',
                          ),
                        )
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                         Center(
                          child: Text(
                            "Total Customers: ${MainClass.todayCustomers.toString()} ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(),
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                      ],
                    ),
                  ),
                ),
              ]),
              //Header Area
            ],
          ),
          Positioned(
              top: screenSize.height / 2.2,
              width: screenSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      menuButton( AppRoutes.collectPayment,
                          'assets/images/collectPayment.png', 'Collect Payment'),
                      menuButton( AppRoutes.newCustomer,
                          'assets/images/register.png', 'New Customer'),
                      menuButton( AppRoutes.upload,
                          'assets/images/bell.png', 'Upload Data'),
                    ],
                  ),
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      menuButton( AppRoutes.customers,
                          'assets/images/customers.png', 'Customers'),
                      menuButton( AppRoutes.printout,
                          'assets/images/printout.png', 'Printout'),
                      menuButton( AppRoutes.submitCard,
                          'assets/images/records.png', 'Submit Card'),
                    ],
                  ),

                ],
              )),

        ],
      ),
    );
  }
  Widget menuButton(String route, String image, String label) {
    Size screenSize = MediaQuery.of(context).size;
    double menuSize = screenSize.width / 5.2;
    return GestureDetector(
      onTap: () async {
        if(label == "Customers"){
          LoadCustomersList loadCustomersList = LoadCustomersList();
          if(!MainClass.isCustomersLoaded){
            await  loadCustomersList.loadCustomers();
          }
        };
        if(label == "Printout"){
          LoadPrintoutList loadPrintoutList = LoadPrintoutList();
          await  loadPrintoutList.selectPrintout(DateTime.now());
        }
        if(label == "Collect Payment"){
          await Navigator.push(context, MaterialPageRoute(
              builder:(context) =>
              const CollectPayment()
          ));
          if(MainClass.reloadDashboard){
            setState(() {

            });
          }
          return;
        }
        if(label == "New Customer"){
          await MainClass.newCardsList();
          await Navigator.push(context, MaterialPageRoute(
              builder:(context) =>
              const RegisterCustomer()
          ));
          if(MainClass.reloadDashboard){
            setState(() {

            });
          }
          return;
        };
        Navigator.pushNamed(context, route);
      },
      child: Column(
        children: [
          Container(
            height: menuSize,
            width: menuSize,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              image: DecorationImage(
                  image: AssetImage('assets/images/backgrounds/menuDark.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.colorDodge)),
            ),
            child: Stack(
              children: [
                Container(
                    height: screenSize.width / 3.1,
                    width: screenSize.width / 3.1,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                            colors: [Color(0x40ffffff), Color(0x10ffffff)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight))),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(image),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black, fontSize: 12),
            ),
          )
        ],
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

    path.lineTo(0, h * 0.7);
    path.quadraticBezierTo(
      w * 0.25,
      h * 0.9,
      w * 0.6,
      h * 0.8,
    );
    path.quadraticBezierTo(
      w * 0.85,
      h * 0.72,
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


