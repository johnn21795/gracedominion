
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Showroom/Customers.dart';
import 'package:gracedominion/Showroom/Inventory.dart';
import 'package:gracedominion/Showroom/Payments.dart';
import 'package:gracedominion/Showroom/Sales.dart';
import 'package:window_manager/window_manager.dart';

import '../Desktop/WidgetClass.dart';
import 'Orders.dart';




class MainInterface extends StatefulWidget {
  const MainInterface({Key? key}) : super(key: key);

  static const Color mainColor = Color(0xff005500);

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  List<bool> isHover = List.generate(6, (index) => false);
  String activePage = "Dashboard";

  Widget page = Container();

  @override
  void initState() {
    windowManager.setSize(const Size(1300, 700), animate: true);
    windowManager.center(animate: true);
    windowManager.focus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              color:MainInterface.mainColor,
              width: 125,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color:MainInterface.mainColor,
                    height: 50,
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("ShowRoom", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Copper", fontSize: 18, color: Colors.white),),
                        // Text("James", textAlign: TextAlign.center, style: TextStyle(fontFamily: "claredon", fontSize: 15, color: Colors.white54),),
                      ],
                    )),
                  ),
                  Container(height: 5, color: Colors.white60,),
                  MainNavigation.mainNavigationButton(isHover[0], "Inventory", FontAwesomeIcons.desktop,
                          (state) { isHover[0] = state;setState(() {});},
                          (){activePage = "Inventory"; page = const InventoryPage(); setState(() {});}
                  ),
                  const SizedBox(height: 1,),
                  MainNavigation.mainNavigationButton(isHover[1], "\t\t Orders",FontAwesomeIcons.moneyCheckDollar,
                          (state) {isHover[1] = state;setState(() {});},
                          (){activePage = "Orders    "; page = const OrderPage();setState(() { });}
                  ),
                  const SizedBox(height: 1,),
                  MainNavigation.mainNavigationButton(isHover[2], "\t Customers",
                      FontAwesomeIcons.sheetPlastic, (state) {isHover[2] = state;setState(() {});},
                          (){activePage = "Customers ";page = const CustomersPage(); setState(() {});}
                  ),
                  const SizedBox(height: 1,),
                  MainNavigation.mainNavigationButton(
                      isHover[3], "Payments", FontAwesomeIcons.gears,
                      (state) { isHover[3] = state;setState(() {});},
                      (){activePage = "Payments "; page = const PaymentPage(); setState(() {});
                  }),
                  MainNavigation.mainNavigationButton(
                      isHover[4], "\t\t Sales", FontAwesomeIcons.gears,
                          (state) { isHover[4] = state;setState(() {});},
                          (){activePage = "Sales "; page = const SalesPage(); setState(() {});
                      }),

                ],
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(width: MediaQuery
                  .of(context)
                  .size
                  .width - 125),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerRow(),
                    Container(height: 18, alignment: Alignment.bottomCenter,
                        child:  const Divider( height: 10, color: MainInterface.mainColor, thickness: 5,)),
                    Expanded(
                        child: Container(
                          color:  const Color(0xFFEFEFEF),
                          child: selectedPage(),
                        )),
                  ],
                ),
              ),
            ),


          ],
        ),
      ),

    );
  }

  Widget headerRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5),
          child: Text(activePage, style: const TextStyle(
              fontSize: 30, fontFamily: 'Claredon'),),
        ),
        // Expanded(child: Container()),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                width: 45,
                height: 40,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(8)),
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/dominion2.jpg')

                    )
                ),

              ),
              const SizedBox(width: 6,),
              const Text(
                "MightyKens International", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30,
                    color: Color(0xff005500),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: 'Claredon'),),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                "James Chukwuedo", textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Claredon'),),
            ),
            Text(
              "Junior Manager",  textAlign: TextAlign.end,
              style: TextStyle( color: Colors.grey,
                fontSize: 13,),),
          ],
        ),
        const SizedBox(width: 10,),
        CircleAvatar(
            radius: 20,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)),
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/profile.jpg')

                  )
              ),

            )
        ),
      ],
    );
  }

  Widget selectedPage(){
    return page;
  }
}


