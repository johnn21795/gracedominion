
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Desktop/Operator/Dashboard.dart';
import 'package:gracedominion/Desktop/Operator/Income.dart';
import 'package:gracedominion/Desktop/Operator/Printout.dart';
import 'package:gracedominion/Desktop/WidgetClass.dart';
import 'package:gracedominion/Desktop/Operator/Settings.dart';
import 'package:window_manager/window_manager.dart';

class MainInterface extends StatefulWidget {
  const MainInterface({Key? key}) : super(key: key);

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
              color: Colors.purple[400],
              width: 125,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Grace Dominion Success", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12,
                          color: Colors.purple[800],
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontFamily: 'BlackChy'),),
                  ),
                  const SizedBox(height: 5,),
                  WidgetClass.mainNavigationButton(isHover[0], "Dashboard", FontAwesomeIcons.desktop,
                          (state) { isHover[0] = state;setState(() {});},
                          (){activePage = "Dashboard"; page = const OperatorDashboard(); setState(() {});}
                  ),
                  const SizedBox(height: 1,),
                  WidgetClass.mainNavigationButton(isHover[1], "\t\t Income",FontAwesomeIcons.moneyCheckDollar,
                          (state) {isHover[1] = state;setState(() {});},
                          (){activePage = "Income    "; page = const Income();setState(() { });}
                  ),
                  const SizedBox(height: 1,),
                  WidgetClass.mainNavigationButton(isHover[2], "\t\t\t\t Printout",
                      FontAwesomeIcons.sheetPlastic, (state) {isHover[2] = state;setState(() {});},
                          (){activePage = "Printout ";page = const Printout(); setState(() {});}
                  ),
                  const SizedBox(height: 1,),
                  WidgetClass.mainNavigationButton(
                      isHover[3], "\t\t Settings", FontAwesomeIcons.gears,
                      (state) { isHover[3] = state;setState(() {});},
                      (){activePage = "Settings "; page = const Printout(); setState(() {});
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
                        child:  Divider( height: 10, color: Colors.purple[800], thickness: 5,)),
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
              Text(
                "Grace Dominion Success", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30,
                    color: Colors.purple[800],
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
              "Operator",  textAlign: TextAlign.end,
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


