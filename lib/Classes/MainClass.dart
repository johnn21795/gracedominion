
import 'dart:collection';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'DatabaseClass.dart';
import 'ModelClass.dart';
import 'TestData.dart';

class MainClass{
  static DateFormat databaseFormat = DateFormat('yyyy-MM-dd');
  static DateFormat userFormat = DateFormat('dd/MM/yyyy');
  static DateFormat fullDate = DateFormat('EEEE d MMM. yyyy');
  static List<String> periodList = <String>[];
  static List<Map<String, Object?>>? cardPackages =  <Map<String, Object>>[];

  static List<Map<String, dynamic>>? contributionPackages =  <Map<String, dynamic>>[];
  static List<Map<String, Object?>>? propertyPackages =  <Map<String, Object>>[];
  static List<Map<String, Object?>>? savingsPackages =  <Map<String, Object>>[];

  static List<Map<String, dynamic>>? selectedPackage =    <Map<String, dynamic>>[];

  static List<String> newContributionCards = <String>[];
  static List<String> newSavingsCards = <String>[];

  static Map<String,String> newCardList = HashMap<String,String>();

  static String branch = "Alaba";
  static String staff = "James";
  static int todayBalance = 0;
  static int todayCustomers = 0;

  static String? customerImagesPath = "";
  static String? oldCustomerImagesPath = "";

  static bool isCustomersLoaded = false;
  static bool reloadDashboard = false;


  static String returnTitleCase(String text){
    String result = "";
    try {
      List<String> words = text.split(" ");
      for(String x in words){
            String capital = x.substring(0, 1).toUpperCase();
            String small = x.substring(1, x.length).toLowerCase();
            result+= capital+small+" ";
          }
    } catch (e) {
      result = text;
    }
    return result;
  }



  static String returnCommaValue(String text){
    String result = "N";
    if(text.length == 3){
      return result += text;
    }
    try {
        String capital = text.substring(text.length-3, text.length);
        String small = text.substring(0, text.length-3).toLowerCase();
        result+= small+","+capital;

    } catch (e) {
      result += text;
    }

    return result;
  }
  static List<String> lastMarkList = <String>[
    "",
    "29/02/"+DateTime.now().year.toString()+"",
    "30/02/"+DateTime.now().year.toString()+"",
    "31/02/"+DateTime.now().year.toString()+"",
    "31/04/"+DateTime.now().year.toString()+"",
    "31/06/"+DateTime.now().year.toString()+"",
    "31/09/"+DateTime.now().year.toString()+"",
    "31/11/"+DateTime.now().year.toString()+"",
  ];

  static Future<void> getTodayBalance(DateTime selectedDate)async {
    // var result = await MainClass.readDB("SELECT SUM(Amount) FROM Printout WHERE Date = ?", [MainClass.format2.format(selectedDate)]);
    todayBalance =0;
    Future<List<ModelClassLarge>> callback =  MainClass.readDB("SELECT Amount FROM Printout WHERE Date = ?", [MainClass.databaseFormat.format(selectedDate)]);
    await callback.then((value)=>{

    if(value.isNotEmpty){
      todayCustomers = value.length,
      for(int x = 0; x < value.length; x++){
        todayBalance += int.parse(value.elementAt(x).col1.toString()),
      },

    }
  });
  }

  //Database Methods
  static MainDatabase currentDb = MainDatabase.instance;
  static Future<List<ModelClassLarge>> readDB(String sql,  List<Object> arguments) async {
    print(sql);
    List<Object> column = [];
    List<ModelClassLarge> data = [];
    int count = 0;
    var result = currentDb.readDB(sql, MainDatabase.customerDB!, arguments);
    await result.then((value) => value?.forEach((element) {
      column = [];
      count++;
      for(int x = 0; x < element.length; x++){
        String y = element.values.elementAt(x).toString();
        column.add((y));
      }
      if(column.length < 21 ){
        int y = 21 - column.length;
        for(int z =0; z < y; z++){
          column.add("");
        }
      }
      // print(element);
      ModelClassLarge modelClass =  ModelClassLarge(count, column.elementAt(0).toString(), column.elementAt(1).toString(), column.elementAt(2).toString(),
          column.elementAt(3).toString(), column.elementAt(4).toString(), column.elementAt(5).toString(), column.elementAt(6).toString(), column.elementAt(7).toString(), column.elementAt(8).toString(), column.elementAt(9).toString(),column.elementAt(10).toString(),column.elementAt(11).toString(),column.elementAt(12).toString(),column.elementAt(13).toString(),column.elementAt(14).toString(),column.elementAt(15).toString(),column.elementAt(16).toString(),column.elementAt(17).toString(),column.elementAt(18).toString(),column.elementAt(19).toString(),column.elementAt(20).toString());
      data.add(modelClass);

    }));
    return data;
  }
  static Future<int> insertDB(Map<String, Object?> data, String table) async{
    print(data);
    await currentDb.insertDB(table, MainDatabase.customerDB!, data);
    return 0;
  }
  static Future<int> updateDB(String sql,  List<Object?> arguments) async{
    await currentDb.updateDB(sql, MainDatabase.customerDB!, arguments);
    return 0;
  }
  static Future<bool> getBoolean(String sql, List<Object> arguments) async{
    var result =  await currentDb.readDB(sql, MainDatabase.customerDB!, arguments);
    bool isTrue = false;
    result == null ? isTrue = false: result.isEmpty?isTrue = false: isTrue = true;
    return isTrue;
  }
  // static Future<int> getInt(String sql, List<Object> arguments) async{
  //   var result =  await currentDb.readDB(sql, MainDatabase.customerDB!, arguments);
  //   bool isTrue = false;
  //   result == null ? isTrue = false: result.isEmpty?isTrue = false: isTrue = true;
  //   return isTrue;
  // }
  static Future<Map<String, String>> getString(String sql, List<Object> arguments) async{
    var callback =  await currentDb.readDB(sql, MainDatabase.customerDB!, arguments);
    Map<String, String>? result = HashMap<String,String>();
    if(callback != null && callback.isNotEmpty){
      result = callback.first.cast<String, String>();
    }
    return result;
  }

  //Load Data Methods
  static Future<void> loadStaffInformation() async {
    newContributionCards = ["2301302569","2175GH","2176GH","2177GH","2178GH","2179GH","2180GH","2181GH","2182GH","2183GH","2183GH","2184GH"];
    newSavingsCards = ["2174SAV","2175SAV","2176SAV","2177SAV","2178SAV","2179SAV"];
    periodList = ["4 Months", "6 Months", "1 Year", "Monthly"];
    newCardList.putIfAbsent("Contribution", () => newContributionCards[0]);
    newCardList.putIfAbsent("Savings", () => newSavingsCards[0]);
  }
  static Future<void> loadAppInformation() async {
    getExternalStorageDirectory().then((value) => {customerImagesPath = "${value?.parent.parent.parent.parent.path}/.GraceDominion/CustomerImages/" });
    await currentDb.database.then((value) => {
      if(currentDb.isNewDatabase){
        for (var element in MyTestData.randomData) {
          currentDb.initialInsertDB(value, element)
        },
        for (var element in MyTestData.defaultPackages) {
          currentDb.initialDefaultPackages(value, element)
        },
        currentDb.readDB("SELECT CardPackage,Amount FROM CardPackages WHERE CardType = 'CONTRIBUTION'",  MainDatabase.customerDB!, []).then((value) => {
          MainClass.contributionPackages = value,  MainClass.selectedPackage = value } ),
      }else{
        currentDb.readDB("SELECT CardPackage,Amount FROM CardPackages WHERE CardType = 'CONTRIBUTION'",  MainDatabase.customerDB!, []).then((value) => {
         MainClass.contributionPackages = value,  MainClass.selectedPackage = value } ),
        currentDb.readDB("SELECT CardPackage,Amount FROM CardPackages WHERE CardType = 'PROPERTY'",  MainDatabase.customerDB!, []).then((value) => MainClass.propertyPackages = value),
        currentDb.readDB("SELECT CardPackage,Amount FROM CardPackages WHERE CardType = 'SAVINGS'",  MainDatabase.customerDB!, []).then((value) => MainClass.savingsPackages = value),
      }
    });
  }

  static Future<List<Map<String, dynamic>>?> loadFireBaseAppInformation() async {
    // getExternalStorageDirectory().then((value) => {customerImagesPath = "${value?.parent.parent.parent.parent.path}/.GraceDominion/CustomerImages/" });

    final CollectionReference packages  = Firestore.instance.collection("packages");
    var firstValue = await packages.where("CardType", isEqualTo: "CONTRIBUTION").get();
    var secondValue = await  packages.document(firstValue.first.id).collection("Packages").orderBy("Name").get();

     for (var e in secondValue) {
          MainClass.contributionPackages?.add(e.map) ;
     }
    MainClass.selectedPackage = MainClass.contributionPackages;

    print("Selected ${ MainClass.selectedPackage}");

    loadPayment("card");

     return MainClass.selectedPackage;
  }

  static Future<List<Map<String, dynamic>>> loadPayment(String card) async{
    final CollectionReference payments  = Firestore.instance.collection("Customers").document("2301302569").collection("Payments");
    var thirdValue = await payments.get();
    List<Map<String, dynamic>> returnData = [];

    int count = 1;
    for (var element in thirdValue) {
      Map<String, dynamic> mapNew = {};
      mapNew.addAll(element.map);
      mapNew.putIfAbsent("index", () => count);
      returnData.add(mapNew);
      count+=1;
    }
    print(returnData);

    return returnData;

  }




  static Future<void> newCardsList() async {
    newCardList.putIfAbsent("Contribution", () => newContributionCards[0]);
    // for(int x =0; x < newContributionCards.length; x++){
    //   bool nextCard = true;
    //   newCardList.clear();
    //   await getBoolean("SELECT CardNo From Customers WHERE CardNo = ?", [newContributionCards[x]]).then((value) => nextCard = value);
    //   // print("New Card"+newContributionCards[x]);
    //   if(!nextCard){
    //     // print("New Card"+newContributionCards[x]);
    //     newCardList.putIfAbsent("Contribution", () => newContributionCards[x]);
    //     break;
    //   }
    // }
    newCardList.putIfAbsent("Savings", () => newSavingsCards[0]);
    // for(int x =0; x < newSavingsCards.length; x++){
    //   bool nextCard = true;
    //   await getBoolean("SELECT CardNo From Customers WHERE CardNo = ?", [newSavingsCards[x]]).then((value) => nextCard = value);
    //   if(!nextCard){
    //     newCardList.putIfAbsent("Savings", () => newSavingsCards[x]);
    //     break;
    //   }
    // }
  }


  // Image Processing Method
  static Future<XFile?> onImageButtonPressed(String cardNo ) async {
    XFile? _imageFile;
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 50,
      );
      _imageFile = pickedFile;
      (File(_imageFile!.path).copySync("${MainClass.customerImagesPath}$cardNo.png"));

    } catch (e) {
      print(e);
    }
    return _imageFile;
  }
  static Widget getProfilePic(int profile, String cardNo, BuildContext context){
    if(profile == 0){
      return  const Image(image: AssetImage('assets/images/profile.jpg',), fit: BoxFit.cover,);
    }else{
      if(File("${MainClass.customerImagesPath}$cardNo.png").existsSync()){
        return GestureDetector(
            onTap:(){
              showDialog<void>(
                barrierColor: Colors.black87,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0x00000000),
                    content: Container(
                      color: const Color(0x22FFFFFF),
                      height: 305,
                      width: 230,
                      child: Image.file(File("${MainClass.customerImagesPath}$cardNo.png"), ),
                    ),
                  );
                },
              );
            },
            child: Image.file(File("${MainClass.customerImagesPath}$cardNo.png"), fit: BoxFit.cover,)) ;
      }else{
        return const Image(image: AssetImage('assets/images/placeholder.jpg',), fit: BoxFit.cover,);
      }
    }
  }



}