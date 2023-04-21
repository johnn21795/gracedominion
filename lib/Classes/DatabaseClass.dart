
import 'package:sqflite/sqflite.dart';



class MainDatabase{
  static final MainDatabase instance = MainDatabase();
   bool isNewDatabase = false ;

  static Database? customerDB;

  Future<Database> get database async{
    if(customerDB != null) return customerDB!;
    customerDB = await _initDB('test14.db');
    return customerDB!;
  }
  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = dbPath+filePath;
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async{
    instance.isNewDatabase = true;
    String sql = "CREATE TABLE IF NOT EXISTS Customers (CardNo STRING UNIQUE NOT NULL ON CONFLICT REPLACE,Name,Address,Phone INTEGER,Branch,DateOfReg,CardPackage,StaffReg,CardType,Period,Amount INTEGER,TotalAmtPayable INTEGER,TotalAmtPaid INTEGER,Percentage,LastPayDate,LastPayAmount INTEGER,CollectedBy,LastMark,Status,Photo,AllowSMS)";
    db.execute(sql);
    sql = "CREATE TABLE IF NOT EXISTS CardPackages (CardType STRING,CardPackage STRING UNIQUE NOT NULL ON CONFLICT REPLACE ,Amount INTEGER,TotalAmountPayable INTEGER)";
    db.execute(sql);
    sql = "CREATE TABLE IF NOT EXISTS AwayCustomers (CardNo STRING UNIQUE NOT NULL ON CONFLICT REPLACE,Reason String,StartDate String,EndDate String)";
    db.execute(sql);
    sql = "CREATE TABLE IF NOT EXISTS Printout (Date String,CardNo String, Amount INTEGER, LastMark STRING, Collected STRING)";
    await db.execute(sql);
  }
  Future<int> initialInsertDB(Database db, Map<String, Object?> data) async{
    await db.insert("Customers", data);
    return 0;
  }
  Future<int> initialDefaultPackages(Database db, Map<String, Object?> data) async{
    await db.insert("CardPackages", data);
    return 0;
  }

  Future<int> insertDB(String table, Database db, Map<String, Object?> data) async{
    await db.insert(table, data);
    return 0;
  }
  Future<List<Map<String, Object?>>?> readDB(String sql, Database db, List<Object?> arguments) async{
    final result = await db.rawQuery(sql, arguments);
    if(result.isNotEmpty){
      return result;
    }
    return null;
  }
  Future<int> updateDB(String sql, Database db, List<Object?> arguments) async{
    await db.rawUpdate(sql, arguments);
    return 0;
  }
  Future<int> deleteDB(String sql, Database db, List<Object?> arguments) async{
    await db.rawDelete(sql, arguments);
    return 0;
  }



}


