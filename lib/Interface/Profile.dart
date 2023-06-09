
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Interface/MainInterface.dart';
import 'package:intl/intl.dart';

import '../Classes/LogicClass.dart';
import '../Classes/TableClass.dart';
import '../Desktop/WidgetClass.dart';
import 'Customers.dart';


class Profile extends StatefulWidget {
  final Map<String, dynamic> data;
  const Profile({Key? key, required this.data}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}
Size? screenSize;
int ordersAmount = 0;
int transactionsAmount = 0;
String? reference;
String? method = "Cash";

class _ProfileState extends State<Profile> {
  bool newCustomer = false;
  bool isEditing = false;
  bool isLoading = false;
  bool loadingData = true;
  bool processingOrder = false;
  final List<FocusNode> focusNode = List.generate(3, (index) => FocusNode());
  Map<String, dynamic> customerData = {};
  List<Map<String, dynamic>> transactionData = [];
  Map<String, dynamic> newTransactionData = {};
  List<Map<String, dynamic>>  orderData = [];
  ScrollController transScrollController = ScrollController();
  ScrollController orderScrollController = ScrollController();




  @override
  void initState(){
    if(widget.data["Name"] == "" && widget.data["Phone"] == ""){
      isEditing = true;
      newCustomer = true;
    }

    customerData= widget.data;
    transScrollController.addListener(_scrollListener);
    orderScrollController.addListener(_scrollListener);
    checkTransactions();
    super.initState();
  }
  void checkTransactions()async {
    transactionData = await FirebaseClass.getCustomerTransactions(widget.data["CustomerID"]);
    orderData = await FirebaseClass.getCustomerOrders(widget.data["CustomerID"]);
    print("transactionData $transactionData \n\n\n" );
    print("orderData $orderData \n\n\n");

    ordersAmount = 0;
    for(var element in orderData){
      ordersAmount += element["Amount"]! as int;
    }
    transactionsAmount = 0;
    for(var element in transactionData){
      transactionsAmount += element["Amount"]! as int;
    }

    // if(activeOrder[1]){
    //   try {
    //     createOrder = true;
    //     var currentOrder= await updateCurrentOrder(false);
    //     customerData = currentOrder[0];
    //     currentOrder.removeAt(0);
    //     orderData = currentOrder;
    //   } catch (e) {
    //     createOrder = false;
    //     setState(() {});
    //   }
    // }
    // loadingOrder = false;
    loadingData = false;
    setState(() {});

  }

  @override
  void dispose() {
    transScrollController.removeListener(_scrollListener);
    orderScrollController.removeListener(_scrollListener);
    orderScrollController.dispose();
    transScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (transScrollController.position.pixels ==
        transScrollController.position.maxScrollExtent) {
      print("transScrollController Reached Bottom");
      loadMoreItems("Transactions");
    }
    if (orderScrollController.position.pixels ==
        orderScrollController.position.maxScrollExtent) {
      print("orderScrollController Reached Bottom");
      loadMoreItems("Orders");
    }
  }
  Future<void> loadMoreItems(String table) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      if (table == "Transactions") {
        transactionData.addAll(TableClass.addIndex(
            transactionData.length,
            await FirebaseClass.loadNextPage(
        MySavedPreferences.getPreference(
        "CustomerOrders.nextPageToken"), "Product")));
      }else{
        orderData.addAll(TableClass.addIndex(
            orderData.length,
            await FirebaseClass.loadNextPage(
                MySavedPreferences.getPreference(
                    "CustomerOrders.nextPageToken"), "Product")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      floatingActionButton: Visibility(
        visible: appName == "Management",
        child: MyFloatingActionButton(
          text: 'New Transaction',
          onPressed: () async {
            await addPaymentDialog(context) ?? false;
            setState(() {

            });


          },
        ),
      ),
      body:loadingData? AlertDialog(
          title: const Text('Loading Data...'),
          content: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
            child: Container(
              transform: Matrix4.translationValues(10, 5, 0),
              width: 200,
              height: 200,
              child: CircularProgressIndicator(strokeWidth: 5.0,color: mainColor,),
            ),
          )): Stack(
        children: [
          Positioned(
              top: 40,
              left:  screenSize!.width * 0.17,
              child: Row(
                children: [
                  Text("CustomerID:", style: TextStyle(fontSize: screenSize!.height * 0.016, fontWeight: FontWeight.bold, color: mainColor),),
                  const SizedBox(width:  10),
                  Text(customerData["CustomerID"], style: TextStyle(fontSize: screenSize!.height * 0.014, fontWeight: FontWeight.bold, ),),
                ],
              )),
          Positioned(
              top: 10,
              left: 15,
              child: Text("Customer Information", style: TextStyle(fontSize: screenSize!.height * 0.019, fontWeight: FontWeight.bold, color: mainColor),)),
          Positioned(
              top: screenSize!.height * 0.29,
              left: 15,
              child: Text("Current Balance:", style: TextStyle(fontSize: screenSize!.height * 0.019, fontWeight: FontWeight.bold, color: mainColor),)),
          Positioned(
              top: screenSize!.height * 0.294,
              left:  screenSize!.width * 0.1,
              child: Text(customerData["Balance"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.019, fontWeight: FontWeight.bold, ),)),
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
                  Text("${orderData.length} Orders", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, ),),
                ],
              )),
          Positioned(
              top: 25,
              right: screenSize!.width * 0.42,
              child: Row(
                children: [
                  Text("Total:", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, color: mainColor),),
                  const SizedBox(width:  10),
                  Text("${transactionData.length} Transaction", style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, ),),
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
                  Text(LogicClass.returnCommaValue(ordersAmount.toString()), style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, ),),
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
                  Text(LogicClass.returnCommaValue(transactionsAmount.toString()), style: TextStyle(fontSize: screenSize!.height * 0.017, fontWeight: FontWeight.bold, ),),
                  SizedBox(width:  screenSize!.width * 0.02),
                ],
              )),

          Positioned(
            top: screenSize!.height * 0.20 + 20,
            left:  screenSize!.width * 0.18,
            child: MyCustomButton(
                text:isEditing? !newCustomer ?"Update Customer": "Save Customer" :newCustomer ? "Add Customer": "Edit Customer",
                onPressed: () async{
                  if(!newCustomer && !isEditing){
                    nameTextController.text = customerData["Name"];
                    phoneTextController.text = customerData["Phone"];
                    addressTextController.text = customerData["Address"];
                  }
                  if(isEditing){
                    if (phoneTextController.text.isEmpty) {
                      FocusScope.of(context).requestFocus(focusNode[1]);
                      return;
                    }
                    var x =  await checkDuplicatePhone(context);
                    print('Check Duplicate X $x');
                    if(!x!){
                      await saveCustomerDialog(context);
                    }else{
                      SnackBar snackBar = SnackBar(backgroundColor: Colors.black87, content: Text("Duplicate Phone Number", style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white), ), duration:const Duration(milliseconds: 2000) ,);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      FocusScope.of(context).requestFocus(focusNode[0]);
                    }
                  }else{
                    isEditing = true;
                  }

                  setState(() {

                  });


                },
                icon:isEditing? FontAwesomeIcons.floppyDisk : newCustomer ?FontAwesomeIcons.plus : FontAwesomeIcons.penToSquare,
                size: const Size(130, 33)
            ),
          ),
          //Transaction History
          Positioned(
            //Transaction History
              top:50,
              right: 20,
              child: SizedBox(
                height: screenSize!.height * 0.85,
                width:  screenSize!.width * 0.5,
                child: ListView.builder(
                  controller: transScrollController,
                   itemCount:transactionData.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    width:  screenSize!.width * 0.49,
                    height: screenSize!.height * 0.06,
                    margin: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                    padding: EdgeInsets.zero,

                    decoration: BoxDecoration(
                      color: mainColor.withAlpha(7),
                      // color: const Color(0xFFF5FFF5),
                      border: Border.all(color:  mainColor.withOpacity(0.4), width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text((index+1).toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                        SizedBox( width: screenSize!.width * 0.08,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(dateFormat.format(DateTime.parse('${transactionData.elementAt(index)["Date"]}')), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),),
                                Text("Ref: ${transactionData.elementAt(index)["Reference"]}", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015,  fontWeight: FontWeight.w400),),
                              ],
                            )),
                        Text(transactionData.elementAt(index)["Description"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.018,  fontWeight: FontWeight.w400),),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(transactionData.elementAt(index)["Amount"].toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),),
                            Text(transactionData.elementAt(index)["Method"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.015,  fontWeight: FontWeight.w400),),
                          ],
                        ),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(transactionData.elementAt(index)["Account"].toString().split(" ")[0], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                            Text(transactionData.elementAt(index)["Account"].toString().split(" ")[1], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                          ],
                        ),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Text(transactionData.elementAt(index)["Status"], style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w600),),
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
                  itemCount:orderData.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    width:  screenSize!.width * 0.4,
                    height: screenSize!.height * 0.06,
                    margin: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                    padding: EdgeInsets.zero,

                    decoration: BoxDecoration(
                      color: mainColor.withAlpha(7),
                      // color: const Color(0xFFF5FFF5),
                      border: Border.all(color:  mainColor.withOpacity(0.4), width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text((index+1).toString(), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                        SizedBox( width: screenSize!.width * 0.08,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(dateFormat.format(DateTime.parse('${orderData.elementAt(index)["Date"]}')), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.bold),),
                                Text("Order:${orderData.elementAt(index)["Order"]}", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016,  fontWeight: FontWeight.w400),),
                              ],
                            )),
                        Text(LogicClass.returnCommaValue(orderData.elementAt(index)["Amount"].toString()), style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.019,  fontWeight: FontWeight.bold),),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Text("Items:${orderData.elementAt(index)["Items"]}", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.017,  fontWeight: FontWeight.w400),),
                        SizedBox(width: screenSize!.width * 0.01,),
                        Text("Ref:${orderData.elementAt(index)["Reference"]}", style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.016,  fontWeight: FontWeight.w400),),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
            top: 55,
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
                      child: accountInformation(isEditing),
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
                focusNode: focusNode[0],
                controller: nameTextController,
                style:  TextStyle(fontSize: screenSize!.height * 0.020, ),
                decoration:  InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: const Text("Name",),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(
              height: screenSize!.height * 0.025,
              child: TextField(
                focusNode: focusNode[1],
                controller: phoneTextController,
                style:  TextStyle(fontSize: screenSize!.height * 0.020, ),
                decoration:   InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: const Text("Phone"),
                ),

                textInputAction: TextInputAction.next,

              ),
            ),
            SizedBox(
              height: screenSize!.height * 0.025,
              child: TextField(
                focusNode: focusNode[2],
                controller: addressTextController,
                style:  TextStyle(fontSize: screenSize!.height * 0.020, ),
                decoration:   InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: const Text("Address"),
                ),
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
            LogicClass.returnTitleCase(stringify(customerData["Name"])),
            style: TextStyle(color: Colors.black, fontSize: screenSize!.height * 0.025 ),
          ),
          Text(
            stringify(customerData["Phone"]),
            style:  TextStyle(color: Colors.black, fontSize: screenSize!.height * 0.025),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                LogicClass.returnTitleCase( stringify(customerData["Address"])),
                style:  TextStyle(color: Colors.black, fontSize: screenSize!.height * 0.025),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
        ],
      );
    }
  }
  Future<bool?> checkDuplicatePhone(BuildContext context) async {
    if(!newCustomer){
      return false;
    }
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: isEditing,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final dialog =  AlertDialog(
                title: const Text('Connecting...'),
                content:  Padding( padding: const
                EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                  child: Container(
                    transform: Matrix4.translationValues(10, 5, 0),
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      color:mainColor,
                    ),
                  ),
                )

            );
            Future.delayed(const Duration(milliseconds: 100), () async {
               await FirebaseClass.getCustomerPhone(phoneTextController.text).then((value) =>  Navigator.of(context).pop(value));
            });
            return dialog;
          },
        );},);
  }
  Future<bool?> saveCustomerDialog(BuildContext context) async {
    // Add this variable to track the editing state
    if (nameTextController.text.isEmpty) {
      FocusScope.of(context).requestFocus(focusNode[0]);
      return null;
    }
    if (phoneTextController.text.isEmpty) {
      FocusScope.of(context).requestFocus(focusNode[1]);
      return null;
    }
    if(addressTextController.text.isEmpty){
      customerData["Address"] = "Lagos";
    }

    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: isEditing,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: newCustomer? const Text('Save Customer') :  const Text('Update'),
              content: !isEditing
                  ? Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
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
                  :  Text('Confirm ${newCustomer? 'Save':'Update'} Customer: \n${ widget.data["Name"]}'),
              actions: [
                TextButton(
                  onPressed: () {
                    // User clicked on the Cancel button
                    isEditing = true;
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    isEditing = false;
                    setState((){});

                      var success = await createNewCustomer(newCustomer);
                      String snack = success? "Customer Added Successfully!" : "Failed to Add Customer";
                      SnackBar snackBar = SnackBar(backgroundColor: Colors.black87, content: Text(snack, style:  TextStyle(fontSize: screenSize!.height * 0.022, color: Colors.white),), duration:const Duration(milliseconds: 2000) ,);
                      Navigator.of(context).pop(false);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);


                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<bool> createNewCustomer(bool update) async {
    customerData["Name"] = nameTextController.text.trim().toUpperCase().replaceAll("  ", " ");
    customerData["Phone"] = phoneTextController.text.trim().toUpperCase();
    customerData["Address"] = addressTextController.text.isEmpty? "Lagos": addressTextController.text.trim().toUpperCase();
    customerData["NameList"] = customerData["Name"].toString().split(' ');

    try {
      var success = await FirebaseClass.createNewCustomer(customerData, update);
      customerData["CustomerID"] = await FirebaseClass.getNewCustomerID();

      nameTextController.text = "";
      phoneTextController.text = "";
      addressTextController.text = "";

      return success;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }

  }


  final descController = TextEditingController();
  final amountController = TextEditingController();
  final bankController = TextEditingController();
  final accountController = TextEditingController();
  Future<bool?> addPaymentDialog(BuildContext context) async {
    // Add this variable to track the editing state
    descController.text= "Balance Payment for Order ";


    DateTime now = DateTime.now();
    String year = DateFormat('yy').format(now);
    String month = DateFormat('MM').format(now);
    String day = DateFormat('dd').format(now);
    String hour = DateFormat('HH').format(now);
    String minute = DateFormat('mm').format(now);
    String second = DateFormat('ss').format(now);
    reference = reference ??  year + month + day + hour + minute + second;



    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: !processingOrder,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title:const Text('Collect Payment') ,
              content: SizedBox(
                width: screenSize!.width * 0.3,
                height: screenSize!.height * 0.75,
                child:processingOrder?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                      child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 100, height:100,child: CircularProgressIndicator(strokeWidth: 3.0, color: mainColor, )),
                    ),
                    Text("Processing Order...Please Wait!",  style: TextStyle(fontFamily: "Claredon", fontSize: screenSize!.height * 0.03,  fontWeight: FontWeight.w400)),
                  ],
                ): Stack(children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Text(LogicClass.fullDate.format(DateTime.now()), style:  TextStyle(fontFamily: "claredon",fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.018,),),
                  ),
                  Positioned(
                    top: screenSize!.height * 0.03,
                    child:  Row(
                      children: [
                        Text("Reference: ", style: TextStyle(fontSize: screenSize!.height * 0.018),),
                        Text(reference!,
                            style:  TextStyle(fontWeight: FontWeight.bold, fontFamily: "claredon",fontSize: screenSize!.height * 0.018,)),
                      ],
                    ),
                  ),

                  Positioned(
                      top:  screenSize!.height * 0.09,
                      right: 20,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Customer:", style: TextStyle(fontSize: screenSize!.height * 0.018,),),
                          Text(customerData["Name"],
                              style:  TextStyle(fontWeight: FontWeight.bold, fontFamily: "claredon", fontSize: screenSize!.height * 0.018,)),
                          Text("ID:${customerData["CustomerID"]}", style: TextStyle(fontSize: screenSize!.height * 0.016,),),
                        ],
                      )),

                  Positioned(
                      top: screenSize!.height * 0.17,
                      child:  Text(
                        "Description:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.018,),
                      )),
                  Positioned(
                      top: screenSize!.height * 0.2,
                      child: SizedBox(
                        width: screenSize!.width * 0.3,
                        child: TextField(
                            controller: descController,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                              ),
                            )),
                      )),
                  Positioned(
                      top:  screenSize!.height * 0.30,
                      child:  Text("Payment Method:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.018,))),
                  Positioned(
                    top: screenSize!.height * 0.33,
                    child: DropdownButton(
                        isExpanded: false,
                        value: method,
                        items: ["Cash", "Transfer", "Cheque", "Debit"]
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                            .toList(),
                        onChanged: (string) {
                          method = string;
                          setState(() {});
                        }),
                  ),
                  // Positioned(
                  //     top: screenSize!.height * 0.42,
                  //     child:  Text("Bank Details:",
                  //         style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.018,))),
                  //
                  Positioned(
                    top: screenSize!.height * 0.42,
                    child: Visibility(
                      visible: method == "Transfer" || method == "Cheque",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("Bank Details:",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenSize!.height * 0.018,)),
                          Row(
                            children: [
                              SizedBox(
                                  width:   screenSize!.width * 0.07,
                                  child: TextField(
                                      controller: bankController,
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: mainColor, width: 2.0),
                                          ),
                                          label:  Text("Bank Name", style: TextStyle(color: mainColor),)
                                      ))),
                              const SizedBox(width: 10),
                              SizedBox(
                                  width:   screenSize!.width * 0.1,
                                  child: TextField(
                                      controller: accountController,
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: mainColor, width: 2.0),
                                          ),
                                          label:  Text("Account Number", style: TextStyle(color: mainColor),)
                                      ))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: screenSize!.height * 0.53,
                      left: screenSize!.width * 0.1,
                      child: Column(
                        children: [
                          Text("Grand Total:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize!.height * 0.025)),
                          Text(LogicClass.returnCommaValue(amountController.text.toString()), style: TextStyle(fontFamily: 'Majoris', fontSize: screenSize!.height * 0.03)),
                        ],
                      )),
                  Positioned(
                    top:  screenSize!.height * 0.61,
                    left: 20,
                    child: SizedBox(
                        width:   screenSize!.width * 0.15,
                        child: TextField(
                            controller: amountController,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: mainColor, width: 2.0),
                                ),
                                label:  Text("Amount Paid", style: TextStyle(color: mainColor),)
                            ))),),
                  Positioned(
                      top:  screenSize!.height * 0.63,
                      left: screenSize!.width * 0.15 + 25,
                      child:MyCustomButton(
                          text: "Collect Payment",
                          onPressed: () async {
                            if(amountController.text.isEmpty){
                              return;
                            }
                            processingOrder = true;
                            updateCustomerData();
                            newTransactionData = createTransactionData();
                            await processOrder(customerData, newTransactionData);


                          },
                          icon: FontAwesomeIcons.handHoldingDollar,
                          size:  const Size(120,40)
                      )
                  ),

                ]),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // User clicked on the Cancel button
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),

              ],
            );
          },
        );
      },
    );
  }
  String stringify(dynamic data){
    String string = data.toString();
    return string;
  }
  void updateCustomerData(){
    print("Previous Customer Data $customerData \n");

    if(customerData["TransactionList"] == null){
      customerData["TransactionList"] = [reference];
    }else{
      List<dynamic> transactions = customerData["TransactionList"].toList();
      transactions.add(reference);
      customerData["TransactionList"] = transactions;
    }
    //update balance
    int currentBal = customerData["Balance"];
    customerData["Balance"] = (currentBal - int.tryParse(amountController.text)!);


    //TotalTransactions
    customerData["TotalTransactions"] = customerData["TotalTransactions"] + 1;
    //TransactionsAmount
    customerData["TransactionsAmount"] = customerData["TransactionsAmount"] + int.tryParse(amountController.text)!;

    print("Current Customer Data $customerData");

  }

  Map<String, dynamic> createTransactionData(){
    Map<String, dynamic> transactionData = {};
    //Date
    transactionData["Date"] = DateTime.now();
    //Reference
    transactionData["Reference"] = reference;
    //Description
    transactionData["Description"] = descController.text;
    //Amount
    transactionData["Amount"] = int.tryParse(amountController.text);
    //Method
    transactionData["Method"] = method;
    //Account
    transactionData["Account"] = "${bankController.text.toUpperCase().trim()} ${accountController.text}";
    //Status
    transactionData["Status"] = "Unconfirmed";
    //CustomerID
    transactionData["CustomerID"] = customerData["CustomerID"];
    //CustomerName
    transactionData["Name"] = customerData["Name"];
    //Order
    // transactionData["Order"] = activeOrder[0];
    print("Previous transaction Data $transactionData \n");
    return transactionData;
  }
  Future<bool> processOrder(Map<String, dynamic> customerData, Map<String, dynamic> transactionData) async{
    var result = false;
    await FirebaseClass.newTransaction(customerData,transactionData).then((value) => {
      Navigator.of(context).pop(value),
    });

    return result;
  }
}
