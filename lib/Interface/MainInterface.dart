
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Showroom/Customers.dart';
import 'Inventory.dart';
import 'package:gracedominion/Showroom/Payments.dart';
import 'package:gracedominion/Showroom/Sales.dart';
import 'package:window_manager/window_manager.dart';

import '../Desktop/WidgetClass.dart';
import 'Orders.dart';
import 'Supply.dart';




class MainInterface extends StatefulWidget {

  const MainInterface({Key? key}) : super(key: key);




  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

String activePage = "Dashboard";
Widget page = Container();
Color mainColor = const Color(0xff000055);
class _MainInterfaceState extends State<MainInterface> {
  List<bool> isHover = List.generate(6, (index) => false);


  @override
  void initState() {

    windowManager.setSize(const Size(1300, 700), animate: true);
    windowManager.center(animate: true);
    windowManager.focus();
    super.initState();
  }
  String? username;
  String? appName;

  @override
  Widget build(BuildContext context) {
    var map = ModalRoute.of(context)?.settings.arguments as Map;
    mainColor = map["Color"];
    username = map["Name"];
    appName = map["App"];
    WidgetClass.mainColor = mainColor;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              color:mainColor,
              width: 125,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color:mainColor,
                    height: 50,
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text(appName!, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Copper", fontSize: 18, color: Colors.white),),
                        // Text("James", textAlign: TextAlign.center, style: TextStyle(fontFamily: "claredon", fontSize: 15, color: Colors.white54),),
                      ],
                    )),
                  ),
                  Container(height: 5, color: Colors.white60,),
                  SizedBox(height:50, child: MyCustomButton(text: "Inventory", onPressed:  (){activePage = "Inventory"; page =  InventoryPage(myFunction: changeState); setState(() {});}, icon: FontAwesomeIcons.listCheck, size: const Size(150, 42))),
                  const SizedBox(height: 1,),

                  appName! == "Warehouse"?
                  SizedBox(height:50, child: MyCustomButton(text: "Supply", onPressed:  (){activePage = "Supply"; page = const SupplyPage(); setState(() {});}, icon: FontAwesomeIcons.vanShuttle, size: const Size(150, 42))):
                  SizedBox(height:50, child: MyCustomButton(text: "Orders", onPressed:  (){activePage = "Orders"; page = const OrderPage(); setState(() {});}, icon: FontAwesomeIcons.moneyCheckDollar, size: const Size(150, 42))),
                  const SizedBox(height: 1,),

                  appName! == "Warehouse"?
                  SizedBox(height:50, child: MyCustomButton(text: "Records", onPressed:  (){activePage = "Records"; page = const SalesPage(); setState(() {});}, icon: FontAwesomeIcons.book, size: const Size(150, 42))):
                  SizedBox(height:50, child: MyCustomButton(text: "Customer", onPressed:  (){activePage = "Customers"; page = const CustomersPage(); setState(() {});}, icon: FontAwesomeIcons.peopleGroup, size: const Size(150, 42))),
                  const SizedBox(height: 1,),

                  appName! != "Warehouse"?
                  SizedBox(height:50, child: MyCustomButton(text: "Sales", onPressed:  (){activePage = "Sales"; page = const SalesPage(); setState(() {});}, icon: FontAwesomeIcons.checkToSlot
                      , size: const Size(150, 42))):
                  const SizedBox(height: 1,),

                  appName! != "Warehouse"?
                  SizedBox(height:50, child: MyCustomButton(text: "Payments", onPressed:  (){activePage = "Payments"; page = const PaymentPage(); setState(() {});}, icon: FontAwesomeIcons.moneyBillWave, size: const Size(150, 42))):
                  const SizedBox(height: 1,),

                  appName! == "Management"?
                  SizedBox(height:50, child: MyCustomButton(text: "Supply", onPressed:  (){activePage = "Supply"; page = const SupplyPage(); setState(() {});}, icon: FontAwesomeIcons.vanShuttle, size: const Size(150, 42))):
                  const SizedBox(height: 1,),

                  appName! == "Management"?
                  SizedBox(height:50, child: MyCustomButton(text: "Records", onPressed:  (){activePage = "Supply Records"; page = const SalesPage(); setState(() {});}, icon: FontAwesomeIcons.book, size: const Size(150, 42))):
                  const SizedBox(height: 1,),

                  appName! == "Management"?
                  SizedBox(height:50, child: MyCustomButton(text: "Authorize", onPressed:  (){activePage = "Authorization"; page = const SalesPage(); setState(() {});}, icon: Icons.done_all_outlined, size: const Size(150, 42))):
                  const SizedBox(height: 1,),



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
                        child:   Divider( height: 10, color: mainColor, thickness: 5,)),
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
                            'assets/images/logo2.jpg')
                    )
                ),

              ),
              const SizedBox(width: 6,),
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
          children:  [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                username!, textAlign: TextAlign.start,
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


