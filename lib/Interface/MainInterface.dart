
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Interface/Customers.dart';
import '../AppRoutes.dart';
import 'Inventory.dart';
import 'package:window_manager/window_manager.dart';

import '../Desktop/WidgetClass.dart';
import 'Orders.dart';
import 'Payments.dart';
import 'Sales.dart';
import 'Settings.dart';
import 'Supply.dart';
import 'SupplyRecords.dart';




class MainInterface extends StatefulWidget {

  const MainInterface({Key? key}) : super(key: key);




  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

String activePage = "Inventory";
Widget page = Container();
Color mainColor = const Color(0xff000055);
bool pageLoading = false;
String? username;
String? appName;
String? email;
List<String> locations = [];
class _MainInterfaceState extends State<MainInterface> {
  List<bool> isHover = List.generate(6, (index) => false);


  @override
  void initState() {
    var x = MySavedPreferences.getPreference("WarehouseList");
    locations = [];
    for(var y in x){
      locations.add(y.toString());
    }
    page = InventoryPage(myFunction: changeState);
    windowManager.setSize(const Size(1300, 700), animate: true);
    windowManager.center(animate: true);
    windowManager.focus();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var map = ModalRoute.of(context)?.settings.arguments as Map;
    mainColor = map["Color"];
    username = map["Name"];
    appName = map["App"];
    email = map["Email"];
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
                  SizedBox(height:50, child: MyCustomButton(text: "Orders", onPressed:  (){activePage = "Orders";  page = const OrderPage(); setState(() {});}, icon: FontAwesomeIcons.moneyCheckDollar, size: const Size(150, 42))),
                  const SizedBox(height: 1,),

                  appName! == "Warehouse"?
                  SizedBox(height:50, child: MyCustomButton(text: "Records", onPressed:  (){activePage = "Supply Records"; page = const SupplyRecord(); setState(() {});}, icon: FontAwesomeIcons.book, size: const Size(150, 42))):
                  SizedBox(height:50, child: MyCustomButton(text: "Customer", onPressed:  (){activePage = "Customers"; page =  CustomersPage(myFunction: changeState); setState(() {});}, icon: FontAwesomeIcons.peopleGroup, size: const Size(150, 42))),
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
                  SizedBox(height:50, child: MyCustomButton(text: "Records", onPressed:  (){activePage = "Supply Records"; page = const SupplyRecord(); setState(() {});}, icon: FontAwesomeIcons.book, size: const Size(150, 42))):
                  const SizedBox(height: 1,),
                  appName! == "Management"?
                  SizedBox(height:50, child: MyCustomButton(text: "Settings", onPressed:  (){activePage = "Settings"; page = const SettingsPage(); setState(() {});}, icon: FontAwesomeIcons.gears, size: const Size(150, 42))):
                  const SizedBox(height: 1,),



                  Expanded(child: Container()),

                  SizedBox(height:50, child: MyCustomButton(text: "Log Out", onPressed:  (){Navigator.pushReplacementNamed(context, AppRoutes.login);}, icon: Icons.exit_to_app, size: const Size(150, 42))),
                  const SizedBox(height: 10,),
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
                decoration:  BoxDecoration(
                    image: DecorationImage(
                        image:
                        appName! == "Warehouse"?
                        const AssetImage('assets/images/bluelogo.jpg'):
                        appName! == "Showroom"?
                        const AssetImage('assets/images/greenlogo.jpg'):
                        const AssetImage('assets/images/redlogo.jpg'),

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
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                username!, textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Claredon'),),
            ),
            Text(
              email!,  textAlign: TextAlign.end,
              style: const TextStyle( color: Colors.grey,
                fontSize: 13,),),
          ],
        ),
        const SizedBox(width: 10,),
        CircleAvatar(
            radius: 20,
            backgroundColor: mainColor,
            child: Container(
              decoration:  const BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)),

              ),
              child: Text(username!.characters.first),

            )
        ),
      ],
    );
  }
  Widget loadingDialog(BuildContext context)  {
    // Add this variable to track the editing state
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final dialog =  AlertDialog(
                title: const Text('Loading...'),
                content:  Padding( padding: const
                EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                  child: Container(
                    transform: Matrix4.translationValues(10, 5, 0),
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      color: mainColor,
                    ),
                  ),
                )


            );
            return dialog;
          },
        );
  }

  Widget selectedPage() {
    // return pageLoading? loadingDialog(context) : page;
    return pageLoading? const LoadingDialog(title: "Loading...",) : page;
  }
}


