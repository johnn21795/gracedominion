
import '../Classes/DatabaseClass.dart';
import '../Classes/ModelClass.dart';

class CustomerColumns{
   static  String cardNo = "" ;
   static  String name = 'Name';
   static  String address = 'Address';
   static  String phone = 'Phone';
   static  String branch = 'Branch';
   static  String dateOfReg = 'DateOfReg';
   static  String cardPackage = 'CardPackage';
   static  String staffReg = 'StaffReg';
   static  String cardType = 'CardType';
   static  String period = 'Period';
   static  String amount = 'Amount';
   static  String totalAmtPayable = 'TotalAmtPayable';
   static  String totalAmtPaid = 'TotalAmtPaid';
   static  String percentage = 'Percentage';
   static  String lastPayDate = 'LastPayDate';
   static  String lastPayAmount = 'LastPayAmount';
   static  String collectedBy = 'CollectedBy';
   static  String lastMark = 'LastMark';
   static  String status = 'Status';
   static  String photo = 'Photo';
   static  String allowSMS = 'AllowSMS';

   
}

class CustomerController {

  void customerFullInfo(ModelClassLarge element){
      CustomerColumns.cardNo = element.col1!;
      CustomerColumns.name = element.col2!;
      CustomerColumns.address = element.col3!;
      CustomerColumns.phone = element.col4!;
      CustomerColumns.branch = element.col5!;
      CustomerColumns.dateOfReg = element.col6!;
      CustomerColumns.cardPackage = element.col7!;
      CustomerColumns.staffReg = element.col8!;
      CustomerColumns.cardType = element.col9!;
      CustomerColumns.period = element.col10!;
      CustomerColumns.amount = element.col11!;
      CustomerColumns.totalAmtPayable = element.col12!;
      CustomerColumns.totalAmtPaid = element.col13!;
      CustomerColumns.percentage = element.col14!;
      CustomerColumns.lastPayDate = element.col15!;
      CustomerColumns.lastPayAmount = element.col16!;
      CustomerColumns.collectedBy = element.col17!;
      CustomerColumns.lastMark = element.col18!;
      CustomerColumns.status = element.col19!;
      CustomerColumns.photo = element.col20!;
      CustomerColumns.allowSMS = element.col21!;
  }

}