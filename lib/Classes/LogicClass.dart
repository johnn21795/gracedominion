
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:firebase_dart/storage.dart';
import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/generated/google/firestore/v1/query.pb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

}

class FirebaseClass{

  static Future<List<Map<String, dynamic>>> searchInventory(String query) async{
    List<Map<String, dynamic>> returnData = [];
    List<String> searchStrings = query.split(' ');
    int count = 1;
    try {
      var products  = await Firestore.instance.collection("Product").where("NameList", arrayContainsAny: searchStrings).get();
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
    } catch (e) {
      print(e);

    }




    // for (var element in products) {
    //   Map<String, dynamic> mapNew = {};
    //   mapNew.addAll(element.map);
    //   mapNew.putIfAbsent("index", () => count);
    //   returnData.add(mapNew);
    //   count+=1;
    // }
    return returnData;
  }


  static Future<bool> createNewProduct(Map<String, dynamic> productData) async{
    bool success= false;
    try {
      await Firestore.instance.collection("Product").document(productData["ProductID"]).set(
          {  "Name":productData["Name"],
            "Model":productData["Model"],
            "Category":productData["Category"],
            "Quantity":productData["Quantity"],
            "Showroom":0,
            "Warehouse":productData["Quantity"],
            "Comment":productData["Comment"],
            "ProductID": productData["ProductID"],
            "NameList":productData["Name"].toString().split(' '),
          });
      await Firestore.instance.collection("Product").document(productData["ProductID"]).collection("ProductHistory").document("${LogicClass.firebaseFormat.format(DateTime.now())} NewStock").set(
          {"Date":DateTime.now(),
            "Customer":"NewStock",
            "Order":"",
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

  static Future<List<Map<String, dynamic>>> loadInventory() async{
    List<Map<String, dynamic>> returnData = [];

    var  products  = Firestore.instance.collection("Product");
      var inventory =  await products.get(pageSize: 15);
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

  static Future<List<Map<String, dynamic>>> loadProductHistory(String productID) async{
    List<Map<String, dynamic>> returnData = [];
    var productHistory  = Firestore.instance.collection("Product").document(productID).collection("ProductHistory");
    var history =  await productHistory.get(pageSize: 15);
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
  static Future<List<Map<String, dynamic>>> loadNextPage(String nextPageToken) async{
    List<Map<String, dynamic>> returnData = [];
    var  products  = Firestore.instance.collection("Product");
    var documents = await products.get(
        pageSize: 10, nextPageToken: nextPageToken);
    print("inventory  data  Page 2 ${documents.asMap()} \n ");
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

  Stream<double> progressIsolate()  {
    final rp = ReceivePort();

    print("WidgetClass mainColor ${WidgetClass.mainColor}");
    return Isolate.spawn(_progressIsolate, rp.sendPort)
        .asStream()
        .asyncExpand((_) => rp)
        .takeWhile((element) => element is double)
        .cast();
  }

  void _progressIsolate(SendPort sendPort) async{
    double progress = 0.0;
    await for (final now in Stream.periodic(
        const Duration(milliseconds: 1000),(_) => {progress += 0.03}).takeWhile((element) => MySavedPreferences.getPreference("isLoading") != 66.6 )) {
      sendPort.send(now.last);
    }
    Isolate.exit(sendPort);
  }
}

