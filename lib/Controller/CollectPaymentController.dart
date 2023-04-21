


import 'package:flutter/foundation.dart';

import '../Classes/MainClass.dart';
import '../Classes/ModelClass.dart';

class CollectPaymentController{


  // DateTimeFormatter format2  = DateTimeFormatter.ofPattern("yyyy-MM-dd");
  // DateTimeFormatter format  = DateTimeFormatter.ofPattern("dd/MM/yyyy");

 static Future<List<String>> cardEntered(String card) async{
    List<String> result = [];
    String sql = "SELECT Name,Address,Phone,DateofReg,LastMark,LastPayAmount,LastPayDate,CollectedBy,CardPackage,TotalAmtPayable,TotalAmtPaid,Photo,Amount FROM Customers WHERE CardNo = ?";
    Future<List<ModelClassLarge>> callback =   MainClass.readDB(sql, [card]);
    await callback.then((value) => {
      if(value.isNotEmpty){
        result = [
          value.elementAt(0).col1!,
          value.elementAt(0).col2!,
          value.elementAt(0).col3!,
          value.elementAt(0).col4!,
          value.elementAt(0).col5!,
          value.elementAt(0).col6!,
          value.elementAt(0).col7!,
          value.elementAt(0).col8!,
          value.elementAt(0).col9!,
          value.elementAt(0).col9!,
          value.elementAt(0).col10!,
          value.elementAt(0).col11!,
          value.elementAt(0).col12!,
          value.elementAt(0).col13!,
        ],

  }
    });
    return result;

  }

 static String getLastMark(String cardType, int currAmt, int cardAmt, int Tpaid){
  //calculates and update the last mark
   //weekly not implemented yet
  String lastMark = "";
  if(cardType == "WEEKLY"){
  DateTime firstMark = DateTime.utc(DateTime.now().year);

  int mark = ((Tpaid + currAmt)/cardAmt).ceil();


  DateTime Monm = firstMark.add(Duration(days: (mark -1)*7));
  int dayOfMonth = Monm.day;

  int week =0;
  if(dayOfMonth == 2){
  week = 1;
  }else if(dayOfMonth > 2 && dayOfMonth < 9){
  week = 2;
  }else if(dayOfMonth >= 9 && dayOfMonth < 16){
  week = 3;
  }else if(dayOfMonth >= 16 && dayOfMonth < 23){
  week = 4;
  }else if(dayOfMonth >= 23 && dayOfMonth < 31){
  week = 5;
  }else if(dayOfMonth == 31){
  week = 5;
  }
  else{
  week = 0;
  }

  //todo generate name for months if weekly payment still active
  lastMark = ("0"+week.toString()+"/"+Monm.month.toString());

  }else{

  try{
   DateTime d = DateTime.utc(DateTime.now().year, 1, 1);
   DateTime firstMark = DateTime.utc(DateTime.now().year);
   // print("Tpaid $Tpaid currAmt $currAmt cardAmt $cardAmt ");
   int mark = ((Tpaid + currAmt)/cardAmt).ceil();
   // print("Mark "+mark.toString());

  if(mark == 60){
    return lastMark = "29/02/"+DateTime.now().year.toString()+"";
  }
  else if (mark == 61){
    return  lastMark = "30/02/"+DateTime.now().year.toString()+"";
  }
  else if (mark == 62){
    return lastMark = "31/02/"+DateTime.now().year.toString()+"";
  }
  else if (mark >= 63 && mark < 124 ){
  d = firstMark.add(Duration(days:(mark - 4) ));

  }else if (mark == 124){
    return lastMark = "31/04/"+DateTime.now().year.toString()+"";
  }
  else if (mark >= 125 && mark < 186 ){
   d = firstMark.add(Duration(days:(mark - 5) ));

  }
  else if (mark == 186){
    return lastMark = "31/06/"+DateTime.now().year.toString()+"";

  }
  else if (mark >= 187 && mark < 279 ){
    d = firstMark.add(Duration(days:(mark - 6) ));

  }
  else if (mark == 279){
    return lastMark = "31/09/"+DateTime.now().year.toString()+"";
  }
  else if (mark >= 280 && mark < 341 ){
    d = firstMark.add(Duration(days:(mark - 7) ));
  }
  else if (mark == 341){
    return lastMark = "31/11/"+DateTime.now().year.toString()+"";
  }
  else if (mark > 341 ){
    d = firstMark.add(Duration(days:(mark - 8) ));
  }
  else{
  d = firstMark.add(Duration(days:(mark - 1) ));
  }

   // d.Form(format2)
  lastMark = MainClass.userFormat.format(d);

  }catch(ex){
    if (kDebugMode) {
      print(ex);
    }
  }
  }

  return lastMark;
}


}