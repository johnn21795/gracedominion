
import 'dart:io';
import 'dart:isolate';


import 'package:firebase_dart/auth.dart';
import 'package:firebase_dart/storage.dart';
import 'package:firedart/firedart.dart' hide FirebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Interface/MainInterface.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fast_image_resizer/fast_image_resizer.dart';
import 'package:grpc/grpc.dart';
import 'dart:async';


import '../Desktop/WidgetClass.dart';


String bigFile = "C:\\Users\\Public\\big.jpg";
String smallFile = "C:\\Users\\Public\\small.jpg";

class LogicClass{
  static DateFormat databaseFormat = DateFormat('yyyy-MM-dd');
  static DateFormat userFormat = DateFormat('dd/MM/yyyy');
  static DateFormat firebaseFormat = DateFormat('dd-MM-yyyy:HH:mm');
  static DateFormat fullDate = DateFormat('EEEE d MMM. yyyy');

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
  static String returnCommaValue(dynamic text){
    String result = "N";
    final format = NumberFormat('#,###');
    return result+= format.format(int.tryParse(text)??0);
  }

}

class FirebaseClass{
  //FOR INVENTORY AND PRODUCT
  static Future<List<Map<String, dynamic>>> searchInventory(String query) async{
    List<Map<String, dynamic>> returnData = [];
    List<String> searchStrings = query.split(' ');
    int count = 1;
    try {
      List<Document> products;

      products = query.startsWith("MK")?
      await Firestore.instance.collection("Product").where("ProductID", isEqualTo: query).get():
      await Firestore.instance.collection("Product").where("NameList", arrayContainsAny: searchStrings).get();

      if(query.startsWith("MK")){
        Map<String, dynamic> mapNew = {};
        mapNew.addAll(products.first.map);
        mapNew.putIfAbsent("index", () => count);
        returnData.add(mapNew);
      }else{
        for (var element in products) {
          Map<String, dynamic> mapNew = {};
          List<dynamic> nameList = element.map["NameList"];
          bool containsAll = searchStrings.every((element) => nameList.contains(element));
          if(containsAll){
            mapNew.addAll(element.map);
            mapNew.putIfAbsent("index", () => count);
            returnData.add(mapNew);
            count+=1;
          }
        }
      }



    } catch (e) {
      print(e);

    }
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> loadInventory() async{
    List<Map<String, dynamic>> returnData = [];

    var  products  = Firestore.instance.collection("Product");
    var inventory =  await products.get(pageSize: 20);
    MySavedPreferences.addPreference("inventory.nextPageToken", inventory.nextPageToken);

    int count = 1;
    inventory.sort((a, b) => a.map["Name"].compareTo(b.map["Name"]));

    for (var element in inventory) {
      Map<String, dynamic> mapNew = {};
      mapNew.addAll(element.map);
      mapNew.putIfAbsent("index", () => count);
      returnData.add(mapNew);
      count+=1;
    }
    return returnData;
  }
  static Future<bool> createNewProduct(Map<String, dynamic> productData, String location) async{
    bool success= false;
    try {
      await Firestore.instance.collection("Product").document(productData["ProductID"]).set(productData);
      await Firestore.instance.collection("Product").document(productData["ProductID"]).collection("ProductHistory").document("${LogicClass.firebaseFormat.format(DateTime.now())} NewStock").set(
          {"Date":DateTime.now(),
            "Customer":"NewStock",
            "CustomerID":"",
            "Order":"1st Entry",
            "Previous": 0,
            "Sold":"+${productData["Quantity"]}",
            "Balance":"${productData["Quantity"]}"
          });
      await Firestore.instance.collection("Product").document(productData["ProductID"]).collection("${LogicClass.returnTitleCase(location).trim()}History").document("${LogicClass.firebaseFormat.format(DateTime.now())} NewStock").set(
          {"Date":DateTime.now(),
            "Customer":"NewStock",
            "CustomerID":"",
            "Order":"1st Entry",
            "Previous": 0,
            "Sold":"+${productData["Quantity"]}",
            "Balance":"${productData["Quantity"]}"
          });
      if(productData.keys.contains("Image")){
        success = await uploadProductImage(productData);
      }
      await updateProductID(productData["ProductID"]);
      success = true;
      return success;
    } on GrpcError catch (e) {
      print('Caught normal error: $e');
      return success;
    } catch(e, stacktrace){
      print('Caught normal error: $e');
      print('stacktrace: $stacktrace');
      return success;
    }
  }
  static Future<bool> updateProduct(Map<String, dynamic> productData) async{
    bool success= false;
    try {
      await Firestore.instance.collection("Product").document(productData["ProductID"]).update(
          { "Name":productData["Name"],
            "Model":productData["Model"],
            "Category":productData["Category"],
            "Comment":productData["Comment"],
            "NameList":productData["Name"].toString().split(' '),
          });
      if(productData.keys.contains("Image")){
        await uploadProductImage(productData);
      }
      success = true;
      return success;
    } on GrpcError catch (e) {
      print('Caught normal error: $e');
      return success;
    } catch(e, stacktrace){
      print('Caught normal error: $e');
      print('stacktrace: $stacktrace');
      return success;
    }
  }
  static Future<bool> uploadProductImage(Map<String, dynamic> productData) async{
    bool success = false;
    try {
      File file = productData["Image"];
      var productImage = FirebaseStorage.instance.ref().child('Images').child(productData["ProductID"]);
      await productImage.putData(file.readAsBytesSync(), SettableMetadata(contentType: 'image/jpeg'));

      File file2 = productData["Thumbnail"];
      productImage = FirebaseStorage.instance.ref().child('Thumbnail').child(productData["ProductID"]);
      await productImage.putData(file2.readAsBytesSync(), SettableMetadata(contentType: 'image/jpeg'));

      success = true;
      return success;
    } on GrpcError catch (e) {
      return success;
    } catch(e, stacktrace){
      print('Caught normal error: $e');
      print('stacktrace: $stacktrace');
      return success;
    }
  }
  static Future<Widget> getProductImage(String productId, String imageType) async {

    final String? userProfile = Platform.environment['USERPROFILE'];
    final String imageFolderPath = '$userProfile\\AppData\\Local\\CachedImages\\${imageType == "Images" ? "Images" : "Thumbnails"}';
    final File imageFile = File('$imageFolderPath\\$productId.jpg');


    if (imageFile.existsSync()) {
      return Image.file(imageFile);
    } else {
      var productImageRef = FirebaseStorage.instance.ref().child(imageType).child(productId);
      final String temporaryImagePath = await productImageRef.getDownloadURL();
      final httpClient = HttpClient();

      try {
        final request = await httpClient.getUrl(Uri.parse(temporaryImagePath));
        final response = await request.close();
        final bytes = await consolidateHttpClientResponseBytes(response);
        await imageFile.writeAsBytes(bytes);
        return Image.file(imageFile);
      } catch (error, stacktrace) {
        print('Error: $error');
        print('Stacktrace: $stacktrace');
      }

      return Image.network(temporaryImagePath);
    }
  }
  static Future<bool> getProductName(String name)async{
    try {
      var document = await Firestore.instance.collection("Product").where("Name", isEqualTo: name.toUpperCase()).get();
      if(document.isEmpty){
        return false;
      }else{
        return true;
      }
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return true;
  }
  static Future<String> getNewProductID() async{
    String productID = "";
    try {
      var document = await Firestore.instance.collection("Other").document("Preferences").get();
      productID = document.map["ProductID"];
    } on GrpcError catch (e) {
      productID = "GrpcError";
      print('Caught GrpcError error: $e');
    } catch(e){
      productID = "normalError";
      print('Caught normal error: $e');
    }
    return productID;
  }
  static Future<bool> checkAddStock( ) async{
    bool exists = false;
    try {
      exists = await Firestore.instance.collection("Other").document("AddStock").exists;
      print('document exists: $exists');
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return exists;
  }
  static Future<Map<String, dynamic>> getAddStock( ) async{
    Map<String, dynamic>  returnData ={} ;
    try {
      var document = await Firestore.instance.collection("Other").document("AddStock").get();
      returnData = document.map;
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return returnData;
  }
  static Future<bool> addNewStock(Map<String, dynamic> stockList, String shippingRef) async{
    //recording Transaction and order
    try {
      await Firestore.instance.collection("StockRecord").document("${LogicClass.firebaseFormat.format(DateTime.now())} $shippingRef").set(stockList);
      stockList.forEach((key, value) async {
        // Perform operations with key and value
        print('Field: $key, Value: $value');
        int balance = int.tryParse(value["Location"].toString())??0;
        int stock = int.tryParse(value["NewStock"].toString())??0;
        await Firestore.instance.collection("Product").document(
            value["ProductID"]).collection("ProductHistory")
            .document(
            "${LogicClass.firebaseFormat.format(DateTime.now())} $shippingRef")
            .set(
            {
              "Balance": value["Current"],
              "Customer": "NewStock",
              "CustomerID": "",
              "Date": DateTime.now(),
              "Order": shippingRef,
              "Previous": value["Quantity"],
              "Sold": "+${value["NewStock"]}",
            });
        await Firestore.instance.collection("Product").document(
            value["ProductID"])
            .collection("${LogicClass.returnTitleCase(value["Location"]).trim()}History")
            .document(
            "${LogicClass.firebaseFormat.format(DateTime.now())} $shippingRef")
            .set(
            {
              "Balance": balance + stock,
              "Customer": "NewStock",
              "CustomerID": "",
              "Date": DateTime.now(),
              "Order": shippingRef,
              "Previous": value["Location"],
              "Sold": "+${value["NewStock"]}",
            });
        await Firestore.instance.collection("Product").document(
            value["ProductID"]).update(
            {
              "Quantity": value["Current"],
              value["Location"]: (balance + stock)
            });

        await Firestore.instance.collection("Other")
            .document("AddStock")
            .delete();
      });
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }

    return true;
  }
  static Future<void> updateAddStock( Map<String, dynamic> productID, [bool delete = false]) async{
    try {
      delete?
      await Firestore.instance.collection("Other").document("AddStock").delete():
      await Firestore.instance.collection("Other").document("AddStock").update(productID);
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
  }
  static Future<void> updateProductStock( Map<String, dynamic> productID) async{
    try {
      await Firestore.instance.collection("Other").document("AddStock").set(productID);
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }

  }
  static Future<bool> updateProductID(String productId) async{
    String newProductID;
    bool success = false;
    try {
      int id = int.parse(productId.replaceAll("MK", ""));
      id = id+1;
      newProductID = "MK$id";
      await Firestore.instance.collection("Other").document("Preferences").update({"ProductID": newProductID});
      success = true;
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
      return success;
    } catch(e){
      print('Caught normal error: $e');
      return success;
    }
    return success;
  }
  static Future<List<Map<String, dynamic>>> loadProductHistory(String productID, String locationHistory) async{
    List<Map<String, dynamic>> returnData = [];
    var productHistory  = Firestore.instance.collection("Product").document(productID).collection(locationHistory);
    var history =  await productHistory.get(pageSize: 20);
    MySavedPreferences.addPreference("product.nextPageToken", history.nextPageToken);
    int count = 1;
    for (var element in history) {
      Map<String, dynamic> mapNew = {};
      mapNew.addAll(element.map);
      mapNew.putIfAbsent("index", () => count);
      returnData.add(mapNew);
      count+=1;
    }
    return returnData;
  }

  //FOR ORDERS
  static Future<List> getOrderNo([bool isActive = true, bool set = false]) async{
    List<dynamic> orderID = [];
    try {
      var document  = await Firestore.instance.collection("Other").document("Preferences").get();
      orderID = document.map["OrderNo"];
      if(set){
        await Firestore.instance.collection("Other").document("Preferences").update({"OrderNo":[orderID[0], isActive]});
        if(!isActive){
          var products = await Firestore.instance.collection("Other").document("CurrentOrder").collection("OrderData").get();
          for(var element in products){
            element.reference.delete();
          }
          await Firestore.instance.collection("Other").document("CurrentOrder").delete();
        }
      }
    } on GrpcError catch (e) {
      orderID = ["GrpcError"];
      print('Caught GrpcError error: $e');
    } catch(e){
      orderID = ["normalError"];
      print('Caught normal error: $e');
    }

    return orderID;

  }
  static Future<bool> processOrder(List<Map<String, dynamic>> combinedData) async{

    //recording Transaction and order
    Firestore.instance.collection("Transactions").document(combinedData.elementAt(0)["Reference"].toString()).set(combinedData.elementAt(0));
    Firestore.instance.collection("Sales").document(combinedData.elementAt(1)["Order"].toString()).set(combinedData.elementAt(1));
    // updating customer information
    Firestore.instance.collection("Customers").document(combinedData.elementAt(2)["CustomerID"]).set(combinedData.elementAt(2));
    await adjustQuantities(combinedData.elementAt(1)["Products"], combinedData.elementAt(1)["Name"],combinedData.elementAt(1)["CustomerID"], combinedData.elementAt(1)["Order"]);
    // updating customer information
    var document  = await Firestore.instance.collection("Other").document("Preferences").get();
    var orderNo = document.map["OrderNo"][0] +1;
    await Firestore.instance.collection("Other").document("Preferences").update({"OrderNo":[orderNo, false]});
    var products = await Firestore.instance.collection("Other").document("CurrentOrder").collection("OrderData").get();
    for(var element in products){
      element.reference.delete();
    }
    await Firestore.instance.collection("Other").document("CurrentOrder").delete();


    return true;
  }
  static Future<bool> adjustQuantities(List<Map<String, dynamic>> productList, String customer,String customerID, int orderNo) async{
    //recording Transaction and order
    for(var product in productList){
      try {
        var document = await Firestore.instance.collection("Product").document(product["ProductID"]).collection("ProductHistory").orderBy("Date", descending: true).limit(1).get();
        int? balance = int.tryParse(document.first.map["Balance"].toString());
        num newBalance = balance! - product["Qty"];
        await Firestore.instance.collection("Product").document(product["ProductID"]).collection("ProductHistory").document("${LogicClass.firebaseFormat.format(DateTime.now())} $orderNo").set(
            {
              "Balance": newBalance,
              "Customer": customer,
              "CustomerID":customerID,
              "Date": DateTime.now(),
              "Order": orderNo,
              "Previous": balance,
              "Sold": product["Qty"],
            });
        await Firestore.instance.collection("Product").document(product["ProductID"]).update(
            {"Quantity":newBalance});
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
      }
    }
    return true;
  }
  static Future<void> updateCurrentOrder( Map<String, dynamic> productID, [bool orderData = false,]) async{
    try {
      orderData?
      await Firestore.instance.collection("Other").document("CurrentOrder").collection("OrderData").document(productID["ProductID"]).set(productID):
      await Firestore.instance.collection("Other").document("CurrentOrder").set(productID);

    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
  }
  static Future<List<Map<String, dynamic>>> getCurrentOrder() async{
    List<Map<String, dynamic>> returnData = [];
    try {
      var customerDetails = await Firestore.instance.collection("Other").document("CurrentOrder").get();
      returnData.add(customerDetails.map);
      var productDetails = await Firestore.instance.collection("Other").document("CurrentOrder").collection("OrderData").get();
      for(var product in productDetails){
        returnData.add(product.map);
      }

    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return returnData;
  }
  static Future<void> deleteCurrentOrder(String productID) async{
    try {
      await Firestore.instance.collection("Other").document("CurrentOrder").collection("OrderData").document(productID).delete();
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
  }

  //FOR CUSTOMERS
  static Future<List<Map<String, dynamic>>> loadCustomers() async{
    List<Map<String, dynamic>> returnData = [];

    var  customers  = Firestore.instance.collection("Customers");
    var people =  await customers.get(pageSize: 20);
    MySavedPreferences.addPreference("customers.nextPageToken", people.nextPageToken);

    int count = 1;
    people.sort((a, b) => a.map["Name"].compareTo(b.map["Name"]));


    for (var person in people) {
      Map<String, dynamic> mapNew = {};
      mapNew.addAll(person.map);
      mapNew["index"] = count;
      returnData.add(mapNew);
      count+=1;
    }
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> searchCustomers(String query) async{
    List<Map<String, dynamic>> returnData = [];
    List<String> searchStrings = query.split(' ');
    int count = 1;
    try {
      List<Document> people;
      print(query);

      people = query.startsWith("CS")?
      await Firestore.instance.collection("Customers").where("CustomerID", isEqualTo: query).get():
      await Firestore.instance.collection("Customers").where("NameList", arrayContainsAny: searchStrings).get();


      if(query.startsWith("CS")){
        Map<String, dynamic> mapNew = {};
        mapNew.addAll(people.first.map);
        mapNew.putIfAbsent("index", () => count);
        returnData.add(mapNew);
      }else{
        for (var person in people) {
          Map<String, dynamic> mapNew = {};
          List<dynamic> nameList = person.map["NameList"];
          bool containsAll = searchStrings.every((element) => nameList.contains(element));
          if(containsAll){
            mapNew.addAll(person.map);
            mapNew.putIfAbsent("index", () => count);
            returnData.add(mapNew);
            count+=1;
          }
        }
      }

    } catch (e) {
      print(e);

    }
    return returnData;
  }
  static Future<bool> createNewCustomer(Map<String, dynamic> customerData, bool update) async{
    bool success= false;
    try {
      if(!update){
        await Firestore.instance.collection("Customers").document(customerData["CustomerID"]).update(
            { "Name":customerData["Name"],
              "Phone":customerData["Phone"],
              "Address":customerData["Address"],
              "NameList":customerData["Name"].toString().split(' '),
            });
        success = true;
        return success;
      }
      await Firestore.instance.collection("Customers").document(customerData["CustomerID"]).set(
          {  "Name":customerData["Name"],
            "Phone":customerData["Phone"],
            "Address":customerData["Address"],
            "CustomerID":customerData["CustomerID"],
            "LastOrder":"",
            "LastOrderNo":"",
            "Balance":0,
            "TotalOrders":0,
            "OrdersAmount":0,
            "TotalTransactions":0,
            "TransactionsAmount":0,
            "NameList":customerData["Name"].toString().split(' '),
          });
      Firestore.instance.collection("Customers").document(customerData["CustomerID"]).collection("OrderHistory");
      Firestore.instance.collection("Customers").document(customerData["CustomerID"]).collection("TransactionHistory");

      await updateCustomerID(customerData["CustomerID"]);

      success = true;
      return success;
    } on GrpcError catch (e) {
      print('Caught normal error: $e');
      return success;
    } catch(e, stacktrace){
      print('Caught normal error: $e');
      print('stacktrace: $stacktrace');
      return success;
    }
  }
  static Future<bool> getCustomerPhone(String name)async{
    try {
      var document = await Firestore.instance.collection("Customers").where("Phone", isEqualTo: name.toUpperCase()).get();
      if(document.isEmpty){
        return false;
      }else{
        return true;
      }
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return true;
  }
  static Future<String> getNewCustomerID() async{
    String customerID = "";
    try {
      var document = await Firestore.instance.collection("Other").document("Preferences").get();
      customerID = document.map["CustomerID"];
    } on GrpcError catch (e) {
      customerID = "GrpcError";
      print('Caught GrpcError error: $e');
    } catch(e){
      customerID = "normalError";
      print('Caught normal error: $e');
    }
    return customerID;
  }
  static Future<bool> updateCustomerID(String customerId) async{
    String newCustomerID;
    bool success = false;
    try {
      int id = int.parse(customerId.replaceAll("CS", ""));
      id = id+1;
      newCustomerID = "CS$id";
      await Firestore.instance.collection("Other").document("Preferences").update({"CustomerID": newCustomerID});
      success = true;
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
      return success;
    } catch(e){
      print('Caught normal error: $e');
      return success;
    }
    return success;
  }

  //FOR CUSTOMER PROFILE
  static Future<List<Map<String, dynamic>>> getCustomerOrders(String customerID) async{
    List<Map<String, dynamic>> returnData = [];
    try {
      var customerDetails = await Firestore.instance.collection("Sales").where("CustomerID", isEqualTo: customerID).get();
      int count=0;
      for (var element in customerDetails) {
        Map<String, dynamic> mapNew = {};
          mapNew.addAll(element.map);
          mapNew.putIfAbsent("index", () => count);
          returnData.add(mapNew);
          count+=1;
      }
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> getCustomerTransactions(String customerID) async{
    List<Map<String, dynamic>> returnData = [];
    try {
      var customerDetails = await Firestore.instance.collection("Transactions").where("CustomerID", isEqualTo: customerID).get();
      int count=0;
      for (var element in customerDetails) {
        Map<String, dynamic> mapNew = {};
        mapNew.addAll(element.map);
        mapNew.putIfAbsent("index", () => count);
        returnData.add(mapNew);
        count+=1;
      }
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return returnData;
  }
  static Future<bool> newTransaction(Map<String, dynamic> customerData, Map<String, dynamic> transactionData) async{
    //recording Transaction and order
    Firestore.instance.collection("Transactions").document(transactionData["Reference"].toString()).set(transactionData);
    Firestore.instance.collection("Customers").document(customerData["CustomerID"]).set(customerData);
    return true;
  }

  //FOR SALES RECORDS
  static Future<List<Map<String, dynamic>>> searchSales(String query, [bool supply = false]) async{
    List<Map<String, dynamic>> returnData = [];
    int count = 1;
    try {
      List<Document>  searchResult = [];

      if(query.startsWith("CS")){
        var customerData = await Firestore.instance.collection("Sales").where("CustomerID", isEqualTo: query).get();
        searchResult.addAll(customerData);
      }else{
        var customerData = await Firestore.instance.collection("Sales").where("Name", isGreaterThanOrEqualTo: query).where("Name", isLessThanOrEqualTo: '$query\uf8ff').get();
        searchResult.addAll(customerData);
        customerData = await Firestore.instance.collection("Sales").where("Order", isEqualTo: int.tryParse(query)).get();
        searchResult.addAll(customerData);
        customerData = await Firestore.instance.collection("Sales").where("Amount", isEqualTo: query).get();
      }

        for (var person in searchResult) {
          Map<String, dynamic> mapNew = {};
          if (person.map["Supplied"] == "Supplied" || !supply) {
            mapNew.addAll(person.map);
            mapNew.putIfAbsent("index", () => count);
            returnData.add(mapNew);
            count += 1;
          }
        }


    } catch (e) {
      print(e);

    }
    return returnData;
  }



  static Future<List<Map<String, dynamic>>> filterSales(DateTime startDate, DateTime endDate, [bool supply = false]) async{
    List<Map<String, dynamic>> returnData = [];
    print("Start Date $startDate  $endDate" );
    int count = 1;
    try {
      List<Document>  searchResult = [];
      var customerData = await Firestore.instance.collection("Sales").where("Date", isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate.add(const Duration(days: 1))).get();
      searchResult.addAll(customerData);
      for (var person in searchResult) {
        Map<String, dynamic> mapNew = {};
        if (person.map["Supplied"] == "Supplied" || !supply) {
          mapNew.addAll(person.map);
          mapNew.putIfAbsent("index", () => count);
          returnData.add(mapNew);
          count += 1;
        }
      }
    } catch (e) {
      print(e);

    }
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> loadSales([bool supply = false]) async{
    List<Map<String, dynamic>> returnData = [];

    var  products  = Firestore.instance.collection("Sales");
    var sales =  await products.get(pageSize: 20);
    MySavedPreferences.addPreference("sales.nextPageToken", sales.nextPageToken);

    int count = 1;
    sales.sort((a, b) => a.map["Order"].compareTo(b.map["Order"]));

    for (var element in sales) {
      Map<String, dynamic> mapNew = {};
      if (element.map["Supplied"] == "Supplied" || !supply) {
        mapNew.addAll(element.map);
        mapNew.putIfAbsent("index", () => count);
        returnData.add(mapNew);
        count += 1;
      }
    }
    return returnData;
  }


  //FOR PAYMENTS
  static Future<List<Map<String, dynamic>>> loadPayments() async{
    List<Map<String, dynamic>> returnData = [];

    var  products  = Firestore.instance.collection("Transactions");
    var sales =  await products.get(pageSize: 20);
    MySavedPreferences.addPreference("transaction.nextPageToken", sales.nextPageToken);

    int count = 1;
    for (var element in sales) {
      Map<String, dynamic> mapNew = {};
      mapNew.addAll(element.map);
      mapNew.putIfAbsent("index", () => count);
      returnData.add(mapNew);
      count+=1;
    }
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> searchPayments(String query) async{
    List<Map<String, dynamic>> returnData = [];
    int count = 1;
    try {
      List<Document>  searchResult = [];

      if(query.startsWith("CS")){
        var customerData = await Firestore.instance.collection("Transactions").where("CustomerID", isEqualTo: query).get();
        searchResult.addAll(customerData);
      }else{
        var customerData = await Firestore.instance.collection("Transactions").where("Name", isGreaterThanOrEqualTo: query).where("Name", isLessThanOrEqualTo: '$query\uf8ff').get();
        searchResult.addAll(customerData);
        customerData = await Firestore.instance.collection("Transactions").where("Order", isEqualTo: int.tryParse(query)).get();
        searchResult.addAll(customerData);
        customerData = await Firestore.instance.collection("Transactions").where("Amount", isEqualTo: query).get();
      }



      // await Firestore.instance.collection("Sales").where("NameList", arrayContainsAny: searchStrings).get();

      for (var person in searchResult) {
        Map<String, dynamic> mapNew = {};
        mapNew.addAll(person.map);
        mapNew.putIfAbsent("index", () => count);
        returnData.add(mapNew);
        count+=1;
      }


    } catch (e) {
      print(e);

    }
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> filterPayments(DateTime startDate, DateTime endDate) async{
    List<Map<String, dynamic>> returnData = [];
    print("Start Date $startDate  $endDate" );
    int count = 1;
    try {
      List<Document>  searchResult = [];
      var customerData = await Firestore.instance.collection("Transactions").where("Date", isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate.add(const Duration(days: 1))).get();
      searchResult.addAll(customerData);
      for (var person in searchResult) {
        Map<String, dynamic> mapNew = {};
        mapNew.addAll(person.map);
        mapNew.putIfAbsent("index", () => count);
        returnData.add(mapNew);
        count+=1;
      }
    } catch (e) {
      print(e);

    }
    return returnData;
  }

  //FOR SUPPLY
  static Future<Map<String, dynamic>> loadOrder(String order) async{
    Map<String, dynamic> returnData = {};
    try {
      var customerDetails = await Firestore.instance.collection("Sales").document(order).get();
      returnData = customerDetails.map;
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return returnData;
  }
  static Future<bool> processSupply(List<dynamic> products, String order, String customer, String customerID) async{
    try {
      List<dynamic> updatedArray =[];
      for (var product in products) {
        List<Document> document;
        int? balance = 0;
        try {
           document = await Firestore.instance.collection("Product").document(product["ProductID"]).collection("${LogicClass.returnTitleCase(product["Location"]).trim()}History").orderBy("Date", descending: true).limit(1).get();
           balance = int.tryParse(document.first.map["Balance"].toString());
           num newBalance = balance! - product["Qty"];
           if(newBalance >= 0){
             await Firestore.instance.collection("Product").document(product["ProductID"]).collection("${LogicClass.returnTitleCase(product["Location"]).trim()}History").document("${LogicClass.firebaseFormat.format(DateTime.now())} $order").set(
                 {
                   "Balance": newBalance,
                   "Customer": customer,
                   "CustomerID":customerID,
                   "Date": DateTime.now(),
                   "Order": order,
                   "Previous": balance,
                   "Sold": product["Qty"],
                 });
             await Firestore.instance.collection("Product").document(product["ProductID"]).update(
                 {
                   product["Location"].toString(): newBalance,
                 });
             var doc = await Firestore.instance.collection("Sales").document(order).get();
             var productMap = doc.map["Products"].elementAt(products.indexOf(product));
             productMap["Location"] = product["Location"];
            updatedArray = [...updatedArray, productMap];

             await Firestore.instance.collection("Sales").document(order).update(
                 {'Products': updatedArray});
           }
        } catch (e, stack) {
          print("No Previous Entry $e, $stack");
          return false;
        }
      }
      await Firestore.instance.collection("Sales").document(order).update(
          {
            "Supplied": "Supplied",
            "SuppliedDate": DateTime.now(),
          });

    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
      return false;
    } catch(e){
      return false;
    }
    return true;

  }
  static Future<String> moveProduct(Map<String, dynamic> product, String fromLocation,  String toLocation) async{
    try {
        List<Document> document;
        int? balance = 0;
        try {
          document = await Firestore.instance.collection("Product").document(product["ProductID"]).collection("${LogicClass.returnTitleCase(fromLocation).trim()}History").orderBy("Date", descending: true).limit(1).get();
          print("${LogicClass.returnTitleCase(fromLocation)}History \n");
          print("$document History \n");
          balance = int.tryParse(document.first.map["Balance"].toString());
          num newBalance = balance! - product["Qty"];
          if(newBalance >= 0){
            await Firestore.instance.collection("Product").document(product["ProductID"]).collection("${LogicClass.returnTitleCase(fromLocation).trim()}History").document("${LogicClass.firebaseFormat.format(DateTime.now())} $username").set(
                {
                  "Balance": newBalance,
                  "Customer": "To $toLocation",
                  "CustomerID":"",
                  "Date": DateTime.now(),
                  "Order": username,
                  "Previous": balance,
                  "Sold": product["Qty"],
                });
            await Firestore.instance.collection("Product").document(product["ProductID"]).update(
                {
                  fromLocation: newBalance,
                });

            document = await Firestore.instance.collection("Product").document(product["ProductID"]).collection("${LogicClass.returnTitleCase(toLocation).trim()}History").orderBy("Date", descending: true).limit(1).get();
            if(document.isNotEmpty){
              balance = int.tryParse(document.first.map["Balance"].toString());
              newBalance = balance! + product["Qty"];
            }else{
              newBalance = product["Qty"];
              balance = 0;
            }
            await Firestore.instance.collection("Product").document(product["ProductID"]).collection("${LogicClass.returnTitleCase(toLocation).trim()}History").document("${LogicClass.firebaseFormat.format(DateTime.now())} $username").set(
                {
                  "Balance": newBalance,
                  "Customer": "From $fromLocation",
                  "CustomerID":"",
                  "Date": DateTime.now(),
                  "Order": username,
                  "Previous": balance,
                  "Sold": product["Qty"],
                });
            await Firestore.instance.collection("Product").document(product["ProductID"]).update(
                {
                  toLocation: newBalance,
                });


          }else{
            return "Not Enough Quantity";
          }
        } catch (e, stacktrace) {
          print("No Previous Entry $e $stacktrace" );
          return "Not Enough Quantity";
        }



    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
      return "Network Error";
    } catch(e){
      return "Unknown Error";
    }
    return "Successful";
  }
  static Future<List<Map<String, dynamic>>> loadSupply() async{
    List<Map<String, dynamic>> returnData = [];

    var  products  = Firestore.instance.collection("Sales");
    var sales =  await products.get(pageSize: 20);
    MySavedPreferences.addPreference("supply.nextPageToken", sales.nextPageToken);

    int count = 1;
    sales.sort((a, b) => a.map["Order"].compareTo(b.map["Order"]));

    for (var element in sales) {
      Map<String, dynamic> mapNew = {};
      if(element.map["Supplied"] =="Supplied"){
        mapNew.addAll(element.map);
        mapNew.putIfAbsent("index", () => count);
        returnData.add(mapNew);
        count+=1;
      }
    }
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> filterSupply(DateTime startDate, DateTime endDate) async{
    List<Map<String, dynamic>> returnData = [];
    print("Start Date $startDate  $endDate" );
    int count = 1;
    try {
      List<Document>  searchResult = [];
      var customerData = await Firestore.instance.collection("Sales").where("Date", isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate.add(const Duration(days: 1))).get();
      searchResult.addAll(customerData);
      for (var element in searchResult) {
        Map<String, dynamic> mapNew = {};
        if(element.map["Supplied"] =="Supplied"){
          mapNew.addAll(element.map);
          mapNew.putIfAbsent("index", () => count);
          returnData.add(mapNew);
          count+=1;
        }
      }
    } catch (e) {
      print(e);

    }
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> searchSupply(String query) async{
    List<Map<String, dynamic>> returnData = [];
    int count = 1;
    try {
      List<Document>  searchResult = [];

      if(query.startsWith("CS")){
        var customerData = await Firestore.instance.collection("Sales").where("CustomerID", isEqualTo: query).get();
        searchResult.addAll(customerData);
      }else{
        var customerData = await Firestore.instance.collection("Sales").where("Name", isGreaterThanOrEqualTo: query).where("Name", isLessThanOrEqualTo: '$query\uf8ff').get();
        searchResult.addAll(customerData);
        customerData = await Firestore.instance.collection("Sales").where("Order", isEqualTo: int.tryParse(query)).get();
        searchResult.addAll(customerData);
        customerData = await Firestore.instance.collection("Sales").where("Amount", isEqualTo: query).get();
      }

      for (var element in searchResult) {
        Map<String, dynamic> mapNew = {};
        if(element.map["Supplied"] =="Supplied"){
          mapNew.addAll(element.map);
          mapNew.putIfAbsent("index", () => count);
          returnData.add(mapNew);
          count+=1;
        }
      }


    } catch (e) {
      print(e);

    }
    return returnData;
  }


  static Future<List<Map<String, dynamic>>> loadStock() async{
    List<Map<String, dynamic>> returnData = [];

    var  products  = Firestore.instance.collection("StockRecord");
    var sales =  await products.get(pageSize: 20);
    MySavedPreferences.addPreference("supply.nextPageToken", sales.nextPageToken);

    int count = 1;
    sales.sort((a, b) => a.map["Order"].compareTo(b.map["Order"]));

    for (var element in sales) {
      Map<String, dynamic> mapNew = {};
      if(element.map["Supplied"] =="Supplied"){
        mapNew.addAll(element.map);
        mapNew.putIfAbsent("index", () => count);
        returnData.add(mapNew);
        count+=1;
      }
    }
    return returnData;
  }


  //FOR STAFF

  //FOR GENERAL USE
  static Future<dynamic> getDynamic(String collection, String document, [String field = ""]) async{
    dynamic data = "";
    try {
      var result = await Firestore.instance.collection(collection).document(document).get();
      // print('getDynamic result : $result');

      data = field == ""?result.map : result.map[field];
      // print('getDynamic data : $data');
    } on GrpcError catch (e) {
      data = "GrpcError";
      print('Caught GrpcError error: $e');
    } catch(e){
      data = "normalError";
      print('Caught normal error: $e');
    }
    return data;
  }
  static Future<dynamic> updateDynamic(String collection, String document, Map<String, dynamic> data) async {
    try {
      await Firestore.instance.collection(collection).document(document).update(
          data);
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
      return false;
    } catch (e) {
      print('Caught normal error: $e');
      return false;
    }
    return true;
  }

  static Future<dynamic> setDynamic(String collection, String document, Map<String, dynamic> data) async{
    try {
      await Firestore.instance.collection(collection).document(document).set(data);
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
      return false;
    } catch(e){
      print('Caught normal error: $e');
      return false;
    }
    return true;
  }

  static Future<void> addPasswordUser(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      final user = await auth.createUserWithEmailAndPassword(email:email, password:password);
    } catch (e) {
      // Handle any errors that occur during the user creation process
      print('Failed to add password user: $e');
    }
  }

  static Future<Map<String, dynamic>> signInUser(String email, String password) async {
    Map<String, dynamic> map = {};
    try {
      if(!email.contains("@")){
        var doc = await Firestore.instance.collection("Staff").where(email.toUpperCase().startsWith("ST")? "StaffID": "Name", isEqualTo: email.toUpperCase()).get();
        email = doc.first.map["Email"];
      }
      final auth = FirebaseAuth.instance;
       await auth.signInWithEmailAndPassword(email:email, password:password);
      var loc = await Firestore.instance.collection("Other").document("Preferences").get();
      MySavedPreferences.addPreference("WarehouseList", loc.map["Locations"]);
      var doc = await Firestore.instance.collection("Staff").where("Email", isEqualTo: email).get();
      map = doc.first.map;
      map["Successful"] = true;
      return map;
    } catch (e) {
      // Handle any errors that occur during the user creation process
      map["Successful"] = false;
      map["Error"] = e;
      return map;
    }
  }


  static Future<String> updateSoftware() async{

      var productImageRef = FirebaseStorage.instance.ref().child("Software").child("mightykens.exe");
      return await productImageRef.getDownloadURL();

  }



  static Future<List<Map<String, dynamic>>> loadNextPage(String nextPageToken, String collection) async{
    List<Map<String, dynamic>> returnData = [];
    var  products  = Firestore.instance.collection(collection);
    var documents = await products.get(
        pageSize: 20, nextPageToken: nextPageToken);
    print("$collection  data  Page 2 ${documents.asMap()} \n ");
    int count = 1;
    documents.sort((a, b) => a.map["Name"].compareTo(b.map["Name"]));
    for (var element in documents) {
      Map<String, dynamic> mapNew = {};
      mapNew.addAll(element.map);
      mapNew.putIfAbsent("index", () => count);
      returnData.add(mapNew);
      count+=1;
    }

    return returnData;
  }

}


class CalculateClass{
  Future<List<File?>> selectImage(String file) async {
    ImageFile input;
    Configuration config = const Configuration(
      outputType: ImageOutputType.jpg,
      useJpgPngNativeCompressor: true,
      quality: 80,
    );
    ByteData? bytes;
    File? smallFile;
    File? bigFile;
    try {
      final rawImage =  File(file).readAsBytesSync();

      bigFile = File("C:\\Users\\Public\\TempImages\\${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
      bytes = await resizeImage(Uint8List.view(rawImage.buffer), height: 300, width: 300);
      input =  ImageFile(filePath: file, rawBytes: Uint8List.view(bytes!.buffer));
      var param = ImageFileConfiguration(input: input, config: config);
      var output = await compressor.compress(param);
      bigFile.writeAsBytesSync(output.rawBytes);

      bytes = await resizeImage(Uint8List.view(rawImage.buffer), height: 150, width: 150);
      input =  ImageFile(filePath: file, rawBytes: Uint8List.view(bytes!.buffer));
      param = ImageFileConfiguration(input: input, config: config);
      output = await compressor.compress(param);
      smallFile = File("C:\\Users\\Public\\TempImages\\${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
      smallFile.writeAsBytesSync(output.rawBytes);

    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);

    }
    return [smallFile, bigFile];
  }

  static List<Map<String, dynamic>> addIndex(List<Map<String, dynamic>> returnData ){
    List<Map<String, dynamic>> newData = [];
    try {
      newData = returnData.asMap().map((index, item) {
        item['index'] = (index+1).toString();
        return MapEntry(index, item);
      }).values.toList();
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    return newData;
  }


}

