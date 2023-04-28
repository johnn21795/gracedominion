
import 'package:firedart/firestore/firestore.dart';
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

  static Future<void> loadSQLCustomerInformation() async {
    await instance.getDatabase("Customers").then((database) => {
      instance.readDB("SELECT * FROM Customers",  database, []).then((value) => {
         addCustomersFromSql(value!) } ),
    });
  }
  static Future<void> addCustomersFromSql(List<Map<String, dynamic>> packages, ) async{
    try {
      for(var element in packages){
        print("Setting element  ${element["Name"]}");
        await Firestore.instance.collection("Customers").document(element["CardNo"]).set( element );
      }
    } catch(e){
      print('Caught normal error: $e');
    }
  }

  static Future<void> loadSQLPackageInformation() async {
    await instance.getDatabase("Packages").then((database) => {
      instance.readDB("SELECT Distinct Name,Amount,Total FROM Contribution", database, []).then((value) => {
        addPackageFromSql(value!, "CONTRIBUTION", database) } ),
      currentDb.readDB("SELECT Distinct Name,Amount,Total FROM PROPERTY",  database, []).then((value) => {
         addPackageFromSql(value!, "PROPERTY", database) } ),
      currentDb.readDB("SELECT Distinct Name,Amount,Total FROM SAVINGS", database, []).then((value) => {
         addPackageFromSql(value!, "SAVINGS", database) } ),

    });
  }
  static Future<void> addPackageFromSql(List<Map<String, dynamic>> packages, String cardType, Database db) async{
    try {
      for(var element in packages){
        print("Setting element  ${element["Name"]}");
        await Firestore.instance.collection("packages").document(cardType).collection("packages").document(element["Name"]).set(element);
      }
      currentDb.readDB("SELECT Name,Item,Quantity,Value FROM $cardType WHERE Item != '' ",  db, []).then((value) => {
        for(var element in value!){
          print("updating element  ${element["Name"]}"),
          Firestore.instance.collection("packages").document(cardType).collection("packages").document(element["Name"].toString()).collection("PackingList").document(element["Item"].toString()).set(
              {"Item": element["Item"],"Quantity": element["Quantity"],"Value": element["Value"] })
        },
        print("Finished")
      } );

    }  catch(e){
      print('Caught normal error: $e');
    }
  }
  static Future<void> loadSQLIncomeInformation() async {
    await instance.getDatabase("Income").then((database) => {
      instance.readDB("SELECT * FROM CurrentRound", database, []).then((value) => {
        addIncomeFromSql(value!) } ),
      currentDb.readDB("SELECT Distinct Name,Amount,Total FROM PROPERTY",  database, []).then((value) => {
        addPackageFromSql(value!, "PROPERTY", database) } ),
      currentDb.readDB("SELECT Distinct Name,Amount,Total FROM SAVINGS", database, []).then((value) => {
        addPackageFromSql(value!, "SAVINGS", database) } ),

    });
  }
  static Future<void> addIncomeFromSql(List<Map<String, dynamic>> packages, ) async{
    try {
      for(var element in packages){
        print("Setting element  ${element["Name"]}");
        await Firestore.instance.collection("Income").document("CurrentRound").collection("Customers").document(element["CardNo"]).set( element );
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