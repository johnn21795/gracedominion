import 'dart:collection';

import 'package:flutter/material.dart';

import '../Classes/MainClass.dart';
import '../Classes/ModelClass.dart';
import 'CustomerProfile.dart';

class PrintOut extends StatefulWidget {
  const PrintOut({Key? key}) : super(key: key);
  // static bool isPrintoutsLoaded = false;

  @override
  State<PrintOut> createState() => _PrintOutState();
}
class CustomerPrintout {
  final String card;
  final String name;
  final String phone;
  final String address;
  final String package;
  final String status;
  final int  photo;
  final int amount;


  CustomerPrintout(this.card,this.name, this.phone, this.address,this.package, this.status,  this.photo,this.amount,  );
}

class _PrintOutState extends State<PrintOut> {
  DateTime? selectedDate = DateTime.now();
  ScrollController scrollController = ScrollController();
  static late CustomerPrintout selectedPrintout ;
  static List<CustomerPrintout> selectedPrintoutList =<CustomerPrintout>[] ;
  static int printoutBalance = 0;
  String? sortBy = "Asc";


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        LoadPrintoutList lp = LoadPrintoutList();
         selectedDate = await showDatePicker(firstDate: DateTime.utc(2022), initialDate: DateTime.now(), lastDate:  DateTime.now(), context: context) ;
        lp.selectPrintout(selectedDate!).then((value) => {
        setState(() {



        })
        });

        },
        child: const Icon(Icons.calendar_month),
      ),
      body:   Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(children: [
          Padding(
            padding:  EdgeInsets.only(top:screenSize.height / 4),
            child: ListView.builder(itemCount:selectedPrintoutList.isEmpty ? 1 : selectedPrintoutList.length,
              controller: scrollController,
              itemBuilder: (context, index) {
              if(selectedPrintoutList.isNotEmpty){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical:5),
                  child: InkWell(
                    onTap: ()async {
                      LoadPrintoutList lp = LoadPrintoutList();
                      selectedPrintout = selectedPrintoutList[index];
                      Map<String, String> result =  await lp.loadCustomersInfo(selectedPrintout.card.toUpperCase());
                      Navigator.push(context, MaterialPageRoute(
                          builder:(context) =>
                              CustomerProfile(customerInfo:result))  );},
                    child: Container(
                      decoration: const BoxDecoration(
                          boxShadow:  [
                            BoxShadow(
                                color: Color(0x33000000),
                                offset: Offset(1.0, 2.0),
                                blurRadius: 1.0,
                                spreadRadius: 1.5
                            )
                          ],
                          borderRadius:  BorderRadius.all(Radius.circular(10)),
                          color:Color(0xfff0ffed)
                      ),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                                child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(width: 1.0, color:  const Color(0xfff0ffed), strokeAlign: BorderSide.strokeAlignOutside),
                                    ),
                                    child:  MainClass.getProfilePic(selectedPrintoutList[index].photo, selectedPrintoutList[index].card.toUpperCase(), context)
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment:  CrossAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.credit_card_rounded, color: Color(0xba000000),size: 15,),
                                    Icon(Icons.account_circle, color: Color(0xba000000), size: 15,),
                                    Icon(Icons.phone, color: Color(0xba000000), size: 15,),
                                    Icon(Icons.card_giftcard, color: Color(0xba000000), size: 15,),
                                    Icon(Icons.location_on_sharp, color: Color(0xba000000), size: 15,),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5,),
                              Expanded(
                                child: SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:  CrossAxisAlignment.start,
                                    children: [
                                      Text(selectedPrintoutList[index].card, style: const TextStyle( fontSize: 12, color: Color(0xff000000), fontFamily: 'Claredon', fontWeight: FontWeight.w600), ),
                                      Text(MainClass.returnTitleCase(selectedPrintoutList[index].name), style: const TextStyle( fontSize: 12,fontFamily: 'Claredon',), ),
                                      Text(selectedPrintoutList[index].phone, style: const TextStyle( fontSize: 12,fontFamily: 'Claredon',), ),
                                      Text(selectedPrintoutList[index].package, style: const TextStyle( fontSize: 12,fontFamily: 'Claredon',), ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(MainClass.returnTitleCase(selectedPrintoutList[index].address), style: TextStyle( fontSize: 12, fontFamily: 'Claredon',), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(right: 10, top: 5, child: Text(selectedPrintoutList[index].amount.toString(), style: const TextStyle( fontSize: 14, fontFamily: 'Claredon', fontWeight: FontWeight.bold, color:Color(0xff127b00)  ), ),),
                          // Positioned(right: 10, bottom: 23, child: Text(selectedCustomerList[index].percentage+"%", style: TextStyle( fontSize: 12, fontFamily: 'Claredon', fontWeight: FontWeight.bold, color: statusColor.putIfAbsent(selectedCustomerList[index].status.toUpperCase(), () => const Color(0xff000000))  ), ),),
                          Positioned(left: 6, top: 3, child: Text((index+1).toString()+".", style: const TextStyle( fontSize: 6,  fontWeight: FontWeight.bold, color:  Color(0x55000000)  ), ),)

                        ],
                      ),
                    ),
                  ),
                );
              }else{
                return  Center(child: Column(
                  children: const [
                    Icon( Icons.error, size: 30, color: Colors.grey,),
                    Text("No Records Found", style: TextStyle(fontSize: 18, color: Colors.grey),),
                  ],
                ),);
              }


              },
            ),
          ),
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: screenSize.height / 3,
              width: screenSize.width,
              decoration:   const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0x33000000),
                  image: DecorationImage(

                      image: AssetImage(
                          'assets/images/backgrounds/greenDark.jpg'),
                      fit: BoxFit.fill,
                      opacity: 0.3,

                      colorFilter: ColorFilter.mode(
                          Colors.black, BlendMode.colorDodge))),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Stack(children: [
                   Padding(
                     padding:  EdgeInsets.only(top: screenSize.height / 9),
                     child: Center(
                       child: Column(
                         children: [
                           Text(MainClass.fullDate.format(selectedDate!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600,  fontFamily: 'Claredon'),),
                           Text(MainClass.returnCommaValue( printoutBalance.toString()), style: const TextStyle(color: Colors.white, fontFamily: 'majoris', fontSize: 24),),

                         ],
                       ),
                     ),
                   ),

                    Positioned(
                        bottom: screenSize.height / 12,
                        right:15,
                        child: Text(selectedPrintoutList.length.toString()+" Customers", style: const TextStyle(color: Colors.white, fontFamily: 'Claredon'),)),

                    Positioned(
                      bottom: screenSize.height / 12,
                        left:15,
                        child:   DropdownButton(
                          iconEnabledColor: Colors.white,
                          dropdownColor: const Color(0xCC002200),
                          focusColor: Colors.white,
                          hint: const Text("Sort By", style: TextStyle(fontSize: 12, color: Colors.white),),
                          value: sortBy,
                          items: <String>["Asc","Desc"].map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status, style: const TextStyle(fontSize: 12, color: Colors.white),),
                          )).toList(),
                          onChanged: (String? value) {
                            sortBy = value;
                            setState(() {
                              _PrintOutState.selectedPrintoutList = _PrintOutState.selectedPrintoutList.reversed.toList();
                            });  },

                        ),),
                  ]),


                ],
              ),
            ),
          ),
          Container(
            height: 70,
            width: screenSize.width,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    'Printout',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Claredon'),
                  ),
                ),
              ],
            ),
          ),
        ]),
      )
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

class LoadPrintoutList{
  Future<void> selectPrintout(DateTime selectedDate) async{
    Future<List<ModelClassLarge>> callback =  MainClass.readDB("SELECT CardNo,Amount,LastMark,Collected FROM Printout WHERE Date = ?", [MainClass.databaseFormat.format(selectedDate)]);
    // Future<List<ModelClassLarge>> callback =  MainClass.readDB("SELECT CardNo,Amount FROM Printout ", []);
    List<Map<String,String>> data = [];
    _PrintOutState.printoutBalance = 0;
    await callback.then((value)=>
    {
      
      if(value.isNotEmpty){
        for(int x = 0; x < value.length; x++){

          data.add({"CardNo":value.elementAt(x).col1.toString(), "Amount":value.elementAt(x).col2.toString()}),
        },
        for(int z = 0; z < data.length; z++){
          _PrintOutState.printoutBalance += int.parse(data.elementAt(z).putIfAbsent( "Amount", () => "0")),
        },
      },

    },

    );
    callback =  MainClass.readDB("SELECT CardNo,Name,Phone,Address,CardPackage,Status,Photo FROM Customers WHERE CardNo IN (${List.generate(data.length, (index) => "?").join(",")}) ", data.map((e) => e.putIfAbsent("CardNo", () => "")).toList());
    await callback.then((value)=>
    {
      print(value.length),
      print(data),
      _PrintOutState.selectedPrintoutList.clear(),
      if(value.isNotEmpty){
        // print(value.elementAt(1).col1),
        // print(value.elementAt(1).col2),
        // print(value.elementAt(1).col3),
        // print(value.elementAt(1).col4),
        for(int x = 0; x < value.length; x++){
          print(value.elementAt(0).col1),
          print(value.elementAt(0).col2),
          print(value.elementAt(0).col3),
          print(value.elementAt(0).col4),
          _PrintOutState.selectedPrintoutList.add(CustomerPrintout(value.elementAt(x).col1!,value.elementAt(x).col2!,value.elementAt(x).col3!, value.elementAt(x).col4!,value.elementAt(x).col5!,value.elementAt(x).col6!, int.parse(value.elementAt(x).col7!), int.parse(data.elementAt(x).putIfAbsent("Amount", () => "0")))),
        },
      }

    }
    );
  }
  Future< Map<String,String>> loadCustomersInfo(String card) async{
    Map<String,String> customerDetails = HashMap<String,String>();
    customerDetails.putIfAbsent("CardNo", () => _PrintOutState.selectedPrintout.card);
    customerDetails.putIfAbsent("Name", () => _PrintOutState.selectedPrintout.name);
    customerDetails.putIfAbsent("Phone", () =>_PrintOutState.selectedPrintout.phone);
    customerDetails.putIfAbsent("Address", () => _PrintOutState.selectedPrintout.address);
    customerDetails.putIfAbsent("CardPackage", () => _PrintOutState.selectedPrintout.package);
    customerDetails.putIfAbsent("Status", () => _PrintOutState.selectedPrintout.status);
    customerDetails.putIfAbsent("Photo", () => _PrintOutState.selectedPrintout.photo.toString());


    String sql = "SELECT DateOfReg,CardType,Amount,Period,LastMark,TotalAmtPayable,TotalAmtPaid FROM Customers WHERE CardNo = ?";
    Future<List<ModelClassLarge>> callback =   MainClass.readDB(sql, [card]);
    await callback.then((value) => {
      if(value.isNotEmpty){
        customerDetails.putIfAbsent("DateOfReg", () => value.elementAt(0).col1.toString()),
        customerDetails.putIfAbsent("CardType", () => value.elementAt(0).col2.toString()),
        customerDetails.putIfAbsent("Amount", () => value.elementAt(0).col3.toString()),
        customerDetails.putIfAbsent("Period", () => value.elementAt(0).col4.toString()),
        customerDetails.putIfAbsent("LastMark", () => value.elementAt(0).col5.toString()),
        customerDetails.putIfAbsent("TotalAmtPayable", () => value.elementAt(0).col6.toString()),
        customerDetails.putIfAbsent("TotalAmtPaid", () => value.elementAt(0).col7.toString()),
      }
    });
    return customerDetails;

  }

  LoadPrintoutList();

}
