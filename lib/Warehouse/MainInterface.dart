
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Interface/Customers.dart';
import 'package:gracedominion/Warehouse/Inventory.dart';
import 'package:gracedominion/Showroom/Payments.dart';
import 'package:gracedominion/Showroom/Sales.dart';
import 'package:window_manager/window_manager.dart';

import '../Desktop/WidgetClass.dart';
import 'Supply.dart';




class MainInterface extends StatefulWidget {
  const MainInterface({Key? key}) : super(key: key);

  static const Color mainColor = Color(0xff000055);

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

String activePage = "Dashboard";
Widget page = Container();
class _MainInterfaceState extends State<MainInterface> {
  List<bool> isHover = List.generate(6, (index) => false);


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
                        Text("Warehouse", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Copper", fontSize: 18, color: Colors.white),),
                        // Text("James", textAlign: TextAlign.center, style: TextStyle(fontFamily: "claredon", fontSize: 15, color: Colors.white54),),
                      ],
                    )),
                  ),
                  Container(height: 5, color: Colors.white60,),
                  // MainNavigation.mainNavigationButton(isHover[0], "Inventory", FontAwesomeIcons.desktop,
                  //         (state) { isHover[0] = state;setState(() {});},
                  //         (){activePage = "Inventory"; page = const InventoryPage(); setState(() {});}
                  // ),
                  SizedBox(height:50, child: MyCustomButton(text: "Inventory", onPressed:  (){activePage = "Inventory"; page =  InventoryPage(myFunction: changeState); setState(() {});}, icon: FontAwesomeIcons.desktop, size: const Size(150, 42))),
                  const SizedBox(height: 1,),
                  SizedBox(height:50, child: MyCustomButton(text: "Supply", onPressed:  (){activePage = "Supply"; page = const SupplyPage(); setState(() {});}, icon: FontAwesomeIcons.moneyCheckDollar, size: const Size(150, 42))),
                  const SizedBox(height: 1,),
                  // SizedBox(height:50, child: MyCustomButton(text: "Customers", onPressed:  (){activePage = "Customers"; page = const CustomersPage(); setState(() {});}, icon: FontAwesomeIcons.user, size: const Size(150, 42))),
                  const SizedBox(height: 1,),
                  SizedBox(height:50, child: MyCustomButton(text: "Records", onPressed:  (){activePage = "Records"; page = const SalesPage(); setState(() {});}, icon: FontAwesomeIcons.book, size: const Size(150, 42))),


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
  void changeState(){

    setState(() {
    print("Testing Page");
  });


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
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/bluelogo.jpg')
                    )
                ),

              ),
               SizedBox(width: 6,),
               Text(
                "MightyKens International", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30,
                    color: WidgetClass.mainColor,
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


