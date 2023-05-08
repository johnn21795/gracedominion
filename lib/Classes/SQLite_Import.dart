
import 'package:firedart/firestore/firestore.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SQLiteDatabase {
  static final SQLiteDatabase instance = SQLiteDatabase();
  bool isNewDatabase = false;

  static String? branchPath;
  static SQLiteDatabase currentDb = SQLiteDatabase.instance;


  SQLiteDatabase() {
    branchPath = "C:\\Users\\Public\\Database\\GDS_Alaba Database\\";
    sqfliteFfiInit();
  }

  Future<Database> getDatabase(String name) async{
    var databaseFactory = databaseFactoryFfi;
    return  await databaseFactory.openDatabase("$branchPath$name.sqlite");
  }

  static Future<void> loadSQLCustomerInformation(String branch) async {
    print(' calling CustomerInformation element: ');
    await instance.getDatabase("Customers").then((database) => {
    print(' received CustomerInformation database: $database '),
      instance.readDB("SELECT * FROM Customers WHERE CardNo != '' ",  database, []).then((value) => {
         addCustomersFromSql(value!,branch) } ),
    });
  }

  static Future<void> addCustomersFromSql(List<Map<String, dynamic>> packages, String branch) async {
    try {
      for (var element in packages) {
        final mapData = Map<String, dynamic>.from(element);
        mapData['Branch'] = branch;
        await Firestore.instance.collection('Customers').document(mapData['CardNo'].toString()).set(mapData);
      }
    } catch (e, stackTrace) {
      print('Caught error: $e');
      print('Stack trace: $stackTrace');
    }
  }
  // static Future<void> addCustomersFromSql(List<Map<String, dynamic>> packages,String branch ) async{
  //   print(' Received CustomerInformation packages: ');
  //   try {
  //     for(var element in packages){
  //       print('CustomerInformation element: $element');
  //       Map<String, dynamic> mapData = element;
  //       mapData.putIfAbsent("Branch", () => branch);
  //       print('CustomerInformation element: $mapData');
  //       await Firestore.instance.collection("Customers").document(mapData["CardNo"]).set( mapData );
  //     }
  //   } catch(e){
  //     print('Caught normal error: $e');
  //   }
  // }

  static Future<void> loadSQLPackageInformation(String branch) async {
    await instance.getDatabase("Packages").then((database) => {
      instance.readDB("SELECT Distinct Name,Amount,Total FROM Contribution", database, []).then((value) => {
        addPackageFromSql(value!, "CONTRIBUTION", database,branch) } ),
      currentDb.readDB("SELECT Distinct Name,Amount,Total FROM PROPERTY",  database, []).then((value) => {
         addPackageFromSql(value!, "PROPERTY", database,branch) } ),
      currentDb.readDB("SELECT Distinct Name,Amount,Total FROM SAVINGS", database, []).then((value) => {
         addPackageFromSql(value!, "SAVINGS", database,branch) } ),

    });
  }
  static Future<void> addPackageFromSql(List<Map<String, dynamic>> packages, String cardType, Database db, String branch) async{
    try {
      for(var element in packages){
        await Firestore.instance.collection("packages").document(cardType).collection("packages").document(element["Name"]).set(element);
      }
      currentDb.readDB("SELECT Name,Item,Quantity,Value FROM $cardType WHERE Item != '' ",  db, []).then((value) => {
        for(var element in value!){
          Firestore.instance.collection("packages").document(cardType).collection("packages").document(element["Name"].toString()).collection("PackingList").document(element["Item"].toString()).set(
              {"Item": element["Item"],"Quantity": element["Quantity"],"Value": element["Value"] })
        },
      } );

    }  catch(e){
      print('Caught normal error: $e');
    }
  }
  static Future<void> loadSQLIncomeInformation(String branch) async {
    try {
      final database = await instance.getDatabase("Income");
      print('Received Income database: $database');
      final tables = ["CurrentRound"];
      // final tables = ["CurrentRound", "ContributionClearedCards2023", "PropertyClearedCards2023", "SavingsClearedCards2023"];
      for (final table in tables) {
        final value = await instance.readDB("SELECT * FROM $table", database, []);
        addIncomeFromSql(value!, branch);
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }

  static Future<void> addIncomeFromSql(List<Map<String, dynamic>> packages,String branch ) async{
    try {

      for(var element in packages){
        final mapData = Map<String, dynamic>.from(element);
        mapData['Branch'] = branch;
        mapData['Round'] = "CurrentRound";
        // await Firestore.instance.collection("Customers").document(element["CardNo"].toString()).collection("Payments").document(element["Date"].toString()).set( mapData );
        await Firestore.instance.collection("Income").document("CurrentRound").collection("Customers").document(element["CardNo"].toString()).set(
            {"CardNo":element["CardNo"], "CurrentBal":element["CurrentBal"], "CardType":element["CardType"], "CardPackage":element["CardPackage"]});
      }
      print('Finished: ');
    } catch(e, stackTrace){
      print('Caught normal error: $e');
      print('Stack trace: $stackTrace');
    }
  }
  static Future<void> loadSQLStaffInformation(String branch) async {
    await instance.getDatabase("Staff").then((database) => {
      instance.readDB("SELECT * FROM Staff", database, []).then((value) => {
        addStaffFromSql(value!,branch) } ),
    });
  }
  static Future<void> addStaffFromSql(List<Map<String, dynamic>> packages,String branch ) async{
    try {
      for(var element in packages){
        final mapData = Map<String, dynamic>.from(element);
        mapData['Branch'] = branch;
        await Firestore.instance.collection("Users").document(mapData["Names"]).set( mapData );
      }
    } catch(e){
      print('Caught normal error: $e');
    }
  }

  static Future<void> loadSQLPrintoutInformation2(String branch) async {
    final database = await instance.getDatabase("Printouts");
    try {
      for (int x = DateTime.now().month; x > 0; x--) {
        var month = DateFormat.MMMM().format(DateTime(DateTime.now().year, x));
        try {
          final value = await instance.readDB("SELECT * FROM ${month}2023 WHERE Card not null order by Date ", database, []);
          addPrintoutFromSql(value!, branch,month );
        } catch (e) {
          print(e);
        }
      }
      print('Finished 1 :');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addPrintoutFromSql(List<Map<String, dynamic>> packages,String branch, String month ) async {
    try {
      for (var element in packages) {
        final mapData = Map<String, dynamic>.from(element);
        mapData['Branch'] = branch;
        await Firestore.instance.collection("Printouts")
            .document(mapData["Staff"].toString())
            .collection("2023")
            .document(month.toUpperCase())
            .collection(mapData["Date"])
            .document(mapData["Card"].toString())
            .set(mapData);
        print('Finished 2 :');
      }
    } catch (e) {
      print('Caught addPrintoutFromSql error: $e');
    }
  }

  static Future<void> loadSQLOtherInformation(String branch) async {
    await instance.getDatabase("Other").then((database) => {
      instance.readDB("SELECT * FROM CollectedItems",  database, []).then((value) => {
        addOtherFromSql(value!,branch) } ),
    });
  }
  static Future<void> addOtherFromSql(List<Map<String, dynamic>> packages,String branch ) async{
    try {
      for(var element in packages){
        element.putIfAbsent("Branch", () => branch);
        await Firestore.instance.collection("Others").document(element["CardNo"].toString()).set( element );
      }
    } catch(e){
      print('Caught normal error: $e');
    }
  }
  static Future<void> loadSQLHistoryInformation(String branch) async {
      final database = await instance.getDatabase("Staff");
      for (int x = 12; x > 0; x--) {
        try {
        final value = await instance.readDB("SELECT * FROM Round$x", database, []);
        addHistoryFromSql(value!, branch, x);
        } catch (e) {
          print('Caught Round error: $e');
        }
      }

  }
  static Future<void> addHistoryFromSql(List<Map<String, dynamic>> packages,String branch, int round ) async{
    try {
      for(var element in packages){

        await Firestore.instance.collection("History").document(element["CardNo"]).set( element );
        final mapData = Map<String, dynamic>.from(element);
        mapData['Branch'] = branch;
        mapData['Round'] = round;
        await Firestore.instance.collection("Customers").document(element["CardNo"].toString()).collection("Payments").document(element["Date"].toString()).set( mapData );
      }
    } catch(e){
      print('Caught normal error: $e');
    }
  }

  Future<List<Map<String, Object?>>?> readDB(String sql, Database db, List<Object?> arguments) async{
    final result = await db.rawQuery(sql, arguments);
    if(result.isNotEmpty){
      return result;
    }
    return null;
  }

}