
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:data_table_2/data_table_2.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fast_image_resizer/fast_image_resizer.dart';
import 'package:grpc/grpc.dart';
import 'dart:async';


import 'DatabaseClass.dart';
import 'ModelClass.dart';
import 'TestData.dart';


String bigFile = "C:\\Users\\Public\\big.jpg";
String smallFile = "C:\\Users\\Public\\small.jpg";

class LogicClass{
  static DateFormat databaseFormat = DateFormat('yyyy-MM-dd');
  static DateFormat userFormat = DateFormat('dd/MM/yyyy');
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

  static Future<void> createNewProduct(Map<String, dynamic> productData, String cardType) async{
    try {
        await Firestore.instance.collection("Product").document(productData["Name"]).set(productData);

    } on GrpcError catch (e) {
      print('Caught normal error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
  }
  static Future<String> getNewProductID() async{
    String productID = "";
    try {
      var document = await Firestore.instance.collection("Other").document("Preferences").get();
      productID = document.map["ProductID"];
    } on GrpcError catch (e) {
      print('Caught GrpcError error: $e');
    } catch(e){
      print('Caught normal error: $e');
    }
    return productID;
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

      bigFile = File("C:\\Users\\Public\\${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
      bytes = await resizeImage(Uint8List.view(rawImage.buffer), height: 300, width: 300);
      input =  ImageFile(filePath: file, rawBytes: Uint8List.view(bytes!.buffer));
      var param = ImageFileConfiguration(input: input, config: config);
      var output = await compressor.compress(param);
      bigFile.writeAsBytesSync(output.rawBytes);

      bytes = await resizeImage(Uint8List.view(rawImage.buffer), height: 150, width: 150);
      input =  ImageFile(filePath: file, rawBytes: Uint8List.view(bytes!.buffer));
      param = ImageFileConfiguration(input: input, config: config);
      output = await compressor.compress(param);
      smallFile = File("C:\\Users\\Public\\${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
      smallFile.writeAsBytesSync(output.rawBytes);

    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);

    }
    return [smallFile, bigFile];
  }
}

