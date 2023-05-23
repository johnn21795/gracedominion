
import 'package:flutter/material.dart';
import 'package:gracedominion/Interface/MainInterface.dart';

import '../Classes/LogicClass.dart';
import '../Desktop/WidgetClass.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}
Size? screenSize;
class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 10,
              left: 15,
              child: Text("Customer Information", style: TextStyle(fontSize: screenSize!.height * 0.019, fontWeight: FontWeight.bold, color: mainColor),)),
          Positioned(
              top: screenSize!.height * 0.29,
              left: 15,
              child: Text("Current Balance:", style: TextStyle(fontSize: screenSize!.height * 0.019, fontWeight: FontWeight.bold, color: mainColor),)),
          Positioned(
              top: screenSize!.height * 0.291,
              left:  screenSize!.width * 0.1,
              child: Text("N100,000", style: TextStyle(fontSize: screenSize!.height * 0.019, fontWeight: FontWeight.bold, ),)),
          Positioned(
              top: screenSize!.height * 0.35,
              left: screenSize!.width * 0.17,
              child: Text("Order History", style: TextStyle(fontSize: screenSize!.height * 0.019, fontWeight: FontWeight.bold, color: mainColor),)),
          Positioned(
              top: 5,
              right:  screenSize!.width * 0.2,
              child: Text("Transaction History", style: TextStyle(fontSize: screenSize!.height * 0.019, fontWeight: FontWeight.bold, color: mainColor),)),
          Positioned(
              top: screenSize!.height * 0.39,
              left: 20,
              child: Row(
                children: [
                  Text("Total:", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, color: mainColor),),
                  const SizedBox(width:  10),
                  Text("25 Orders", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, ),),
                ],
              )),
          Positioned(
              top: 25,
              right: screenSize!.width * 0.39,
              child: Row(
                children: [
                  Text("Total:", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, color: mainColor),),
                  const SizedBox(width:  10),
                  Text("25 Transactions", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, ),),
                ],
              )),
          Positioned(
              top: screenSize!.height * 0.4,
              left: screenSize!.width * 0.29,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Amount:", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, color: mainColor),),
                  const SizedBox(width:  10),
                  Text("300,000,000", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, ),),
                  SizedBox(width:  screenSize!.width * 0.02),
                ],
              )),
          Positioned(
              top: 25,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Amount:", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, color: mainColor),),
                  const SizedBox(width:  10),
                  Text("250,000,000", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, ),),
                  SizedBox(width:  screenSize!.width * 0.02),
                ],
              )),

          Positioned(
            top: screenSize!.height * 0.20,
            left:  screenSize!.width * 0.17,
            child: MyCustomButton(
                text: "Save Customer",
                onPressed: (){
                },
                icon: Icons.add,
                size: const Size(130, 33)
            ),
          ),
          Positioned(
            //Transaction History
              top:50,
              right: 20,
              child: SizedBox(
                height: screenSize!.height * 0.85,
                width:  screenSize!.width * 0.5,
                child: ListView.builder(
                  itemCount:25,
                  itemBuilder: (BuildContext context, int index) => Container(
                    width:  screenSize!.width * 0.49,
                    height: screenSize!.height * 0.06,
                    margin: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                    padding: EdgeInsets.zero,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FFF5),
                      border: Border.all(color:  const Color(0x33005500), width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/placeholder.jpg'),
                          fit: BoxFit.cover,
                        ),
                        SizedBox( width: screenSize!.width * 0.27,
                            child: Text("ELECTRIC GRIDDLE STANDING WITH CABINET HALF GROOVED HALF SMOOTH BIG", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),
                        Text("300,000", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Text("4", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Text("1,200,000", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
            //Order History
              top: screenSize!.height * 0.44,
              left: 15,
              child: SizedBox(
                height: screenSize!.height * 0.46,
                width:  screenSize!.width * 0.38,
                child: ListView.builder(
                  itemCount:25,
                  itemBuilder: (BuildContext context, int index) => Container(
                    width:  screenSize!.width * 0.4,
                    height: screenSize!.height * 0.06,
                    margin: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                    padding: EdgeInsets.zero,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FFF5),
                      border: Border.all(color:  const Color(0x33005500), width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        SizedBox( width: screenSize!.width * 0.23,
                            child: Text("ELECTRIC GRIDDLE STANDING WITH CABINET HALF GROOVED HALF SMOOTH BIG", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),)),
                        Text("300,000", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Text("4", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Text("1,200,000", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
            top: 35,
            left: screenSize!.width * 0.02,
            child: SizedBox(
              width: screenSize!.width * 0.25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: screenSize!.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Icon(Icons.account_circle, color: mainColor, size: screenSize!.height * 0.025,),
                        Icon(Icons.phone, color: mainColor, size: screenSize!.height * 0.025,),
                        Icon(Icons.location_on_sharp,color: mainColor, size: screenSize!.height * 0.025,),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: SizedBox(
                      height: screenSize!.height * 0.15,
                      child: accountInformation(true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      ),

    );
  }
  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final addressTextController = TextEditingController();
  Widget accountInformation(bool editable) {
    if (editable) {
      return FocusScope(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize!.height * 0.025,
              child: TextField(
                controller: nameTextController,
                style:  TextStyle(fontSize: screenSize!.height * 0.020, ),
                decoration:  InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text("Name",),
                ),
                onChanged: (string){
                  CustomerInformation.data["Name"] = string.toLowerCase();
                },
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(
              height: screenSize!.height * 0.025,
              child: TextField(
                controller: phoneTextController,
                style:  TextStyle(fontSize: screenSize!.height * 0.020, ),
                decoration:   InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text("Phone"),
                ),
                onChanged: (string){
                  CustomerInformation.data["Phone"] = string.toLowerCase();
                },
                textInputAction: TextInputAction.next,

              ),
            ),
            SizedBox(
              height: screenSize!.height * 0.025,
              child: TextField(
                controller: addressTextController,
                style:  TextStyle(fontSize: screenSize!.height * 0.020, ),
                decoration:   InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text("Address"),
                ),
                onChanged: (string){
                  CustomerInformation.data["Address"] = string.toLowerCase();
                },
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LogicClass.returnTitleCase(stringify(CustomerInformation.data["Name"])),
            style: TextStyle(color: Colors.black, fontSize: screenSize!.height * 0.025 ),
          ),
          Text(
            stringify(CustomerInformation.data["Phone"]),
            style:  TextStyle(color: Colors.black, fontSize: screenSize!.height * 0.025),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                LogicClass.returnTitleCase( stringify(CustomerInformation.data["Address"])),
                style:  TextStyle(color: Colors.black, fontSize: screenSize!.height * 0.025),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
        ],
      );
    }
  }
  String stringify(dynamic data){
    String string = data.toString();
    return string;
  }
}
