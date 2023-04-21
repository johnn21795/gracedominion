
import 'dart:collection';

import 'package:gracedominion/Classes/ModelClass.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Classes/MainClass.dart';
import 'dart:io';

class CustomerProfile extends StatefulWidget {
    final Map<String,String> customerInfo;
   const CustomerProfile({Key? key, required this.customerInfo}) : super(key: key);

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  late Image profile ;
  bool isSet = false;
  int isProfile = 0 ;
  double progress = 0;
  TextStyle payStyle2 = const TextStyle(fontWeight: FontWeight.w400, color: Colors.green);
  bool isChangeImage = false;

  XFile? imageFile;
  bool SMS = false;
  double dialogHeight = 150;
  late List<ModelClassLarge> allPaymentList;
  @override
  Widget build(BuildContext context) {
    isProfile = isSet ? isProfile : int.parse(widget.customerInfo.putIfAbsent("Photo", () => "0"));
    isSet = true;
    progress = ((int.parse(widget.customerInfo.putIfAbsent("TotalAmtPaid", () => "0"))
        /  int.parse(widget.customerInfo.putIfAbsent("TotalAmtPayable", () => "0"))));

    TextStyle textStyle1 = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
    Size screenSize = MediaQuery.of(context).size;
    return
      Scaffold(
        body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: CustomClipPath(),
              child:
              Container(
                height: screenSize.height / 2.4,
                decoration:  const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/backgrounds/greenDark.jpg'),
                        fit: BoxFit.fill,
                        opacity: 0.3,
                        colorFilter: ColorFilter.mode(
                            Colors.black, BlendMode.colorDodge))),
                child: Stack(
                  children: [
                    const Positioned(
                        top: 40,
                        left: 50,
                        child: Text(
                          'Customer Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Claredon'),
                        )),
                    Positioned(
                        top: screenSize.height / 13,
                        child: Row(
                          children: [
                            Container(
                              height: screenSize.height / 4,
                              width: screenSize.width * 0.95,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  gradient: LinearGradient(
                                      colors: [Color(0x00aeffa4), Color(0x00ffffff)],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, top: 10.0, bottom: 5.0),
                                    child: Text(
                                      "",
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenSize.width,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0, top: 5.0),
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            width:  screenSize.width / 3.9,
                                            height:  screenSize.width / 3.9,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1.0, color: const Color(0x99ffFFFF), strokeAlign: BorderSide.strokeAlignOutside),
                                              borderRadius:
                                              const BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Stack(children: [
                                                  Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    width:  screenSize.width / 3,
                                                    height:  screenSize.width / 3,
                                                    decoration:  BoxDecoration(
                                                      border: Border.all(width: 2.0, color: const Color(0x77ffFFFF), strokeAlign: BorderSide.strokeAlignOutside),
                                                      borderRadius:const BorderRadius.all(Radius.circular(20)),
                                                    ),
                                                    child: MainClass.getProfilePic(isProfile, widget.customerInfo.putIfAbsent("CardNo", () => ""), context),
                                                  ),
                                                  Positioned(
                                                    child: Visibility(
                                                      visible: isProfile > 0 ? false : true,
                                                      child: Container(
                                                        width:  screenSize.width / 3,
                                                        height:  screenSize.width / 3,
                                                        decoration: BoxDecoration(color: Colors.black26, ),
                                                        child: Center(
                                                          child: IconButton(
                                                            color: Colors.white,
                                                            onPressed: () {
                                                              SnackBar snackBar = SnackBar(action: SnackBarAction(label: "Save Image", onPressed: (){
                                                                MainClass.updateDB("UPDATE Customers SET Photo = 1 WHERE CardNo = ?", [ widget.customerInfo.putIfAbsent("CardNo", () => "")]).then((value) =>
                                                                {
                                                                  File(imageFile!.path).copySync("${MainClass.customerImagesPath}${widget.customerInfo.putIfAbsent("CardNo", () => "")}.png"),
                                                                  MainClass.isCustomersLoaded= false,

                                                                }
                                                                );

                                                              }), content: const Text("Image Capture Successful ", style: TextStyle(fontSize: 11),), duration:const Duration(milliseconds: 5000) ,);
                                                              MainClass.onImageButtonPressed(widget.customerInfo.putIfAbsent("CardNo", () => "")).then((value) =>
                                                                  setState(() {
                                                                    imageFile = value;
                                                                    if(value != null){
                                                                      isProfile = 1;
                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                    } } )
                                                              );

                                                            },
                                                            icon:  const Icon(Icons.camera_alt),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ]),


                                              ],
                                            ),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                          child: SizedBox(
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: const [
                                                Icon(Icons.account_circle, color: Colors.white, size: 18,),
                                                Icon(Icons.phone, color: Colors.white, size: 18,),
                                                Icon(Icons.location_on_sharp, color: Colors.white, size: 18,),
                                                Icon(Icons.calendar_month, color: Colors.white, size: 18,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: 200,
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  MainClass.returnTitleCase(widget.customerInfo.putIfAbsent("Name", () => "0")) , style: const TextStyle(color: Colors.white),
                                                ),
                                                Text(
                                                    widget.customerInfo.putIfAbsent("Phone", () => "0"), style: TextStyle(color: Colors.white),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Text(    MainClass.returnTitleCase(widget.customerInfo.putIfAbsent("Address", () => "0")),
                                                        style: const TextStyle(color: Colors.white),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                ),
                                                Text(
                                                    widget.customerInfo.putIfAbsent("DateOfReg", () => "0"), style: const TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Positioned(
                      top: 40,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {
                           String newFName = "",newLName= "",newPhone= "",newAddress= "";

                           void updateProfile() async{
                             newFName = newFName == "" ? widget.customerInfo.putIfAbsent("Name", () => "") : newFName;
                             newPhone = newPhone == "" ? widget.customerInfo.putIfAbsent("Phone", () => "") : newPhone;
                             newAddress = newAddress == "" ? widget.customerInfo.putIfAbsent("Address", () => "") : newAddress;

                             widget.customerInfo.update("Name", (value) => newFName+" "+newLName);
                             widget.customerInfo.update("Phone", (value) => newPhone);
                             widget.customerInfo.update("Address", (value) => newAddress);

                             await MainClass.updateDB("UPDATE Customers SET Name = ?, Phone = ?, address = ? WHERE CardNo = ?", [
                               widget.customerInfo.putIfAbsent("Name", () => ""),
                               widget.customerInfo.putIfAbsent("Phone", () => ""),
                               widget.customerInfo.putIfAbsent("Address", () => ""),
                               widget.customerInfo.putIfAbsent("CardNo", () => "")
                             ]);
                             MainClass.isCustomersLoaded = false;
                           }
                           bool? x  = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              Widget inputWidget(BuildContext context, String text, Icon icon, TextEditingController controller, String result){
                                return TextField(
                                  onChanged: (value){
                                   switch(text){
                                     case "First Name":
                                       newFName = value;
                                       break;
                                     case "Last Name":
                                       newLName = value;
                                       break;
                                     case "Phone":
                                       newPhone = value;
                                       break;
                                     case "Address":
                                       newAddress = value;
                                       break;

                                   }
                                  },
                                  controller: controller,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.green, width: 1.5)),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      prefixIcon:  icon,
                                      floatingLabelStyle: TextStyle(
                                          textBaseline: TextBaseline.alphabetic,
                                          color: Colors.green[900]),
                                      label: Text(
                                        text,
                                        style: const TextStyle(
                                            textBaseline: TextBaseline.alphabetic),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                );
                              }

                             return StatefulBuilder(builder: (context, setState){
                                return AlertDialog(
                                 content: SizedBox(
                                   height: 400,
                                   child: SingleChildScrollView(
                                     child: Column(
                                       children: [

                                         const Text("Update Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Claredon'),),
                                         const SizedBox(
                                           height: 10,
                                         ),
                                         inputWidget(context, "First Name", const Icon(Icons.account_circle, size: 14,), TextEditingController(), newFName),
                                         const SizedBox(
                                           height: 10,
                                         ),
                                         inputWidget(context, "Last Name", const Icon(Icons.account_circle_outlined, size: 14,), TextEditingController(), newLName),
                                         const SizedBox(
                                           height: 10,
                                         ),
                                         inputWidget(context, "Phone", const Icon(Icons.phone, size: 14,), TextEditingController(), newPhone),
                                         const SizedBox(
                                           height: 10,
                                         ),
                                         inputWidget(context, "Address", const Icon(Icons.location_on, size: 14,), TextEditingController(), newAddress),
                                         Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: CheckboxListTile(  value: SMS, onChanged: (bool? value) {
                                             setState(() {
                                               SMS = !SMS;
                                             });
                                           }, title: const Text('Allow Sms Notifications \n  @ N100 per Month', style: TextStyle(fontSize: 12),),

                                           ),
                                         ),
                                         Center(
                                           child: SizedBox(
                                             width: screenSize.width * 0.8,
                                             height: 40,
                                             child: ElevatedButton(
                                               onPressed: () {
                                                 Navigator.pop(context, true);

                                               },
                                               child: const Text("Update Customer"),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               );
                              });
                            
                            },
                          );
                           if(x ?? false){
                             updateProfile();
                           }

                           // MainClass.returnTitleCase(widget.customerInfo.update("Address", (value) => newAddress));

                           setState(() {

                           });



                        },
                      ),
                    ),
                    Positioned(
                      top: 28,
                      left: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Container(
              transform: Matrix4.translationValues(20, -40, 0),
              child: const Text(
                "Card Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0, -30, 0),
              height:  screenSize.height / 4.7,
              child: PageView.builder(
                itemCount: 1,
                controller: PageController(viewportFraction: 0.95),
                itemBuilder: (BuildContext context, int itemIndex) {
                  return _buildCarouselItem(context,  itemIndex,  widget.customerInfo);
                },
              )
            ),
             Container(
               transform: Matrix4.translationValues(20, -30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Payment Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:30.0),
                    child: TextButton.icon(onPressed: (){
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          double height = 150;
                          bool isPassword = false;
                          Color color = Colors.white;
                          return StatefulBuilder(builder: (context, setState){
                            return AlertDialog(
                              backgroundColor:  color,
                              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              content: SizedBox(
                                height: height,
                                width: 500,
                                child: Container(
                                  color:const Color(0x00BEBEBE),
                                  child:
                                  isPassword ? FutureBuilder(
                                              future:  allPayments(widget.customerInfo.putIfAbsent("CardNo", () => "")),
                                              builder: (context, snapshot) {

                                                return paymentHistory();
                                              })
                                          : Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        const Text("Administrator Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Claredon'),),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                                          child: TextField(
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.key),
                                              hintText: "Password",
                                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                                              label: Text(
                                                "Password",
                                                style: TextStyle(
                                                  textBaseline: TextBaseline.alphabetic,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: SizedBox(
                                            height: 40,
                                            width: 200,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPassword = true;
                                                  height = 350;
                                                  color = const Color(0xBBFFFFFF);
                                                });


                                              },
                                              child: const Text("Show Payments"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );},
                          );
                        },
                      );


                    }, icon:
                    const Icon(Icons.visibility, size: 16,),
                      label: const Text("All Payments", style: TextStyle(fontSize: 11, decoration: TextDecoration.underline),),
                    ),
                  ),



                ],
              ),
            ),
            Container(
              transform: Matrix4.translationValues(10, -35, 0),
              height: screenSize.height / 4,
              width: screenSize.width * 0.95,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x15000000),
                        offset: Offset(1.0, 2.0),
                        blurRadius: 1.0,
                        spreadRadius: 2.0
                    )
                  ],

                  gradient: LinearGradient(
                      colors: [Color(0xffffffff), Color(0xccffffff)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft)
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenSize.width,
                      height: screenSize.height / 6,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              child: Column(

                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Amount",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Paid:   ",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Last Mark: ",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Balance:  ",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Progress: ",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 180,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.customerInfo.putIfAbsent("TotalAmtPayable", () => "0"),
                                      style: textStyle1,
                                    ),
                                    Text(
                                      widget.customerInfo.putIfAbsent("TotalAmtPaid", () => "0"),
                                      style: textStyle1,
                                    ),
                                    Text(
                                      widget.customerInfo.putIfAbsent("LastMark", () => "0"),
                                      style: textStyle1,
                                    ),
                                    Text(
                                      ((int.parse(widget.customerInfo.putIfAbsent("TotalAmtPayable", () => "0"))
                                          -  int.parse(widget.customerInfo.putIfAbsent("TotalAmtPaid", () => "0")))).toString()
                                      ,
                                      style: textStyle1,
                                    ),
                                    Stack(
                                        children:[
                                          LinearProgressIndicator(
                                            value: progress,
                                            color: progress == 1.0? Colors.green[800] :Colors.lightBlue[800],
                                            minHeight: 13,
                                          ),
                                          Center(child: Text((progress*100).floor().toString()+"%", style: TextStyle(color: Colors.white, fontSize: 12),))
                                        ]
                                    )
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ]),
            ),

          ],
        ),
    ),
      );
  }

  Widget paymentHistory()   {
    return ListView.builder(itemCount: allPaymentList.length,
      // controller: scrollController,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical:5),
          child: Container(
            decoration: const BoxDecoration(
              color:Color(0xFFFCFFFB),
              boxShadow: [
                BoxShadow(
                    color: Color(0x55000000),
                    offset: Offset(1.0, 2.0),
                    blurRadius: 1.0,
                    spreadRadius: 1.5
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SizedBox(
              height: 45,
              child: Stack(
                children:  [
                  Positioned(
                    top: 3,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 13, ),
                        const SizedBox(width: 5,),
                        Text(allPaymentList[index].col1!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,fontFamily: 'claredon', ),),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top:3,
                    child: Row(
                      children: [
                        const Icon(Icons.attach_money_outlined, size: 15,),
                        Text(allPaymentList[index].col2!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,  fontFamily: 'claredon', letterSpacing: 1.5),),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 10,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 9,),
                        Text(allPaymentList[index].col4!, style: const TextStyle(fontSize: 8),),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 5,
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle, size: 11,),
                        const SizedBox(width: 5,),
                        Text(allPaymentList[index].col3!, style: const TextStyle(fontSize: 11, fontFamily: 'claredon',),),
                      ],
                    ),
                  ),

                ],
              ),
            ),

          ),
        );

      },
    );
  }

  Future<List<ModelClassLarge>> allPayments (String card) async {
    allPaymentList = [];
    allPaymentList= await MainClass.readDB("SELECT Date,Amount,Collected,LastMark FROM Printout WHERE CardNo = ? ", [card]);

      // if(data.isNotEmpty){
      //   for(int x=0; x < data.length; x ++){
      //     queryResult.add(CustomerStatus(data.elementAt(x).col1!,data.elementAt(x).col2!,data.elementAt(x).col3!, data.elementAt(x).col4!,data.elementAt(x).col5!,data.elementAt(x).col6!, int.parse(data.elementAt(x).col7!),data.elementAt(x).col8!,data.elementAt(x).col9!)),
      //   }
      // }});
    // Future.delayed(const Duration(milliseconds: 300));
    // queryResult.add(CustomerStatus("2180GH", "James", "1234567", "Alaba", "Stage 3", "ACTIVE", 1, "31000", "10000"));
    // queryResult.add(CustomerStatus("519E", "John", "1234567", "Ojo", "Stage 4", "AWAY", 1, "31000", "10000"));
    // queryResult.add(CustomerStatus("831J", "Mike", "1234567", "Alaba", "Stage 5", "INACTIVE", 0, "31000", "10000"));
    // queryResult.add(CustomerStatus("235J", "Athena", "1234567", "Alaba", "Stage 6", "NEGLECTED", 0, "31000", "10000"));
    return allPaymentList;
  }

  // Image getProfilePic(int profile, String cardNo){
  //   if(profile == 0){
  //     return  const Image(image: AssetImage('assets/images/placeholder.jpg',), fit: BoxFit.cover,);
  //   }else{
  //     if(File("${MainClass.customerImagesPath}$cardNo.png").existsSync()){
  //       return Image.file(File("${MainClass.customerImagesPath}$cardNo.png"), fit: BoxFit.cover,) ;
  //     }else{
  //       isProfile = 0;
  //       return const Image(image: AssetImage('assets/images/placeholder.jpg',), fit: BoxFit.cover,);
  //     }
  //   }
  // }
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

Widget _buildCarouselItem(BuildContext context,  int itemIndex, Map<String,String> customerInfo) {
  Map<String,Color> statusColor = HashMap<String,Color>();
  statusColor.addAll({'INACTIVE':  const Color(0xffa5a500)});
  statusColor.addAll({'ACTIVE':  const Color(0xff127b00)});
  statusColor.addAll({'NEGLECTED':  const Color(0xffc50000)});
  statusColor.addAll({'AWAY': const Color(0xff484f5f)});
  String status=  customerInfo.putIfAbsent("Status", () => "")  ;
  TextStyle textStyle1 = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

  Size screenSize = MediaQuery.of(context).size;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Color(0x15000000),
              offset: Offset(1.5, 2.5),
              blurRadius: 0.5,
              spreadRadius: 2.5
          )
        ],

        gradient: LinearGradient(
            colors: [Color(0xffffffff), Color(0xccffffff)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft)
    ),
    child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              height: screenSize.height / 5.8,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "CardNo:",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Card Type: ",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Package:",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Amount:",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Period:  ",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),


                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerInfo.putIfAbsent("CardNo", () => "0"),
                              style: textStyle1,
                            ),
                            Text(
                              MainClass.returnTitleCase(customerInfo.putIfAbsent("CardType", () => "0")),
                              style: textStyle1,
                            ),
                            Text(
                              customerInfo.putIfAbsent("CardPackage", () => ""),
                              style: textStyle1,
                            ),
                            Text(
                              customerInfo.putIfAbsent("Amount", () => "0"),
                              style: textStyle1,
                            ),
                            Text(
                              MainClass.returnTitleCase(customerInfo.putIfAbsent("Period", () => "0")),
                              style: textStyle1,
                            ),


                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ]),
        Positioned(
          right: 0,
          top: -10,
          child: TextButton.icon(
            label: Text(MainClass.returnTitleCase(status),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Claredon',
                fontWeight: FontWeight.bold,
                color: statusColor.putIfAbsent(status.toUpperCase(), () => const Color(0xff000000))
              ),    ),
            onPressed: () {
              if(status != "NEGLECTED"){
               return;
              }
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  String reason = "";
                  TextEditingController controller  = TextEditingController();
                  return AlertDialog(
                    content: SizedBox(
                      height: 150,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text("Change Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Claredon'),),
                            const SizedBox(
                              height: 10,
                            ),
                          TextField(
                    onChanged: (value){
                      reason = value;
                    },
                    controller: controller,
                    style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.5)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon:  const Icon(Icons.note_alt_rounded, size: 14,),
                    floatingLabelStyle: TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                    color: Colors.green[900]),
                    hintText: "Reason",
                    label: const Text(
                      "Reason",
                    style: TextStyle(
                    textBaseline: TextBaseline.alphabetic, ),
                    ),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    )),
                    ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: SizedBox(
                                width: screenSize.width * 0.8,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {

                                  },
                                  child: Text("Set to Away"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon:  Visibility(
                visible: status == "NEGLECTED"? true : false,
                child: Icon(
                  Icons.edit,
                  size: 14,
                    color: statusColor.putIfAbsent(status.toUpperCase(), () => const Color(0xff000000))
                )), ),),
      ],

    ),
  );
}

Widget inputWidget(BuildContext context, String text, Icon icon, TextEditingController controller, String result){
  return TextField(
    onChanged: (value){
      result = value;
    },
    controller: controller,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 1.5)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon:  icon,
        floatingLabelStyle: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            color: Colors.green[900]),
        label: Text(
          text,
          style: const TextStyle(
              textBaseline: TextBaseline.alphabetic),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )),
  );
}
