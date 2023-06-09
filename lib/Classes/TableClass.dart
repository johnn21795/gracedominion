
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Classes/LogicClass.dart';
import 'package:gracedominion/Interface/Profile.dart';
import 'package:gracedominion/Interface/Sales.dart';
import 'package:intl/intl.dart';

import '../Desktop/WidgetClass.dart';
import '../Interface/MainInterface.dart';
import '../Interface/Payments.dart' hide totalAmount;
import '../Interface/Product.dart';

class TableClass extends StatefulWidget {
  final Map<String, dynamic> tableColumns;
  final String tableName;
  final Function() myFunction;
  final dynamic searchQuery;
  const TableClass(
      {super.key,
      required this.tableColumns,
      required this.tableName,
      required this.myFunction,
      this.searchQuery = ""});

  static List<Map<String, dynamic>> returnData = [];

  static Future<List<Map<String, dynamic>>> loadProductTable(String productID, String locationHistory) async {
    returnData = [];
    returnData = await FirebaseClass.loadProductHistory(productID, locationHistory);
    return returnData;
  }

  static Future<List<Map<String, dynamic>>> loadCustomerTable() async {
    returnData = [];
    returnData = await FirebaseClass.loadCustomers();
    return returnData;
  }
  
  static Future<List<Map<String, dynamic>>> loadInventoryTable() async {
    returnData = [];
    returnData = await FirebaseClass.loadInventory();
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> loadSalesTable(bool isSupply) async {
    returnData = [];
    returnData = await FirebaseClass.loadSales(isSupply);
    return returnData;
  }


  static Future<List<Map<String, dynamic>>> loadStockTable() async {
    returnData = [];
    returnData = await FirebaseClass.loadStock();
    return returnData;
  }
  static Future<List<Map<String, dynamic>>> loadPaymentTable() async {
    returnData = [];
    returnData = await FirebaseClass.loadPayments();
    return returnData;
  }

  static List<Map<String, dynamic>> addIndex(
      int start, List<Map<String, dynamic>> returnData) {
    List<Map<String, dynamic>> newData = [];
    try {
      newData = returnData
          .asMap()
          .map((index, item) {
            item['index'] = (index + start + 1).toString();
            return MapEntry(index, item);
          })
          .values
          .toList();
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    return newData;
  }

  @override
  State<TableClass> createState() => _TableClassState();
}

Map<String, int> lastIndex = {"Inventory": 20, "Customers": 20};

class _TableClassState extends State<TableClass> {
  bool isLoading = false;
  int pageCount = 1;
  ScrollController _scrollController = ScrollController();

  List<DataColumn> availableColumns = [];

  List<DataCell> availableCells = [];
  late Future<List<Map<String, dynamic>>>? futureData;
  static late Future<List<Map<String, dynamic>>>? inventoryData;
  static late Future<List<Map<String, dynamic>>>? customerData;
  static late Future<List<Map<String, dynamic>>>? salesData;
  static late Future<List<Map<String, dynamic>>>? supplyData;
  static late Future<List<Map<String, dynamic>>>? paymentData;
  late Future<List<Map<String, dynamic>>>? searchData;

  @override
  void initState() {
    print("_TableClassState  initializing...${widget.tableName}");

    if (widget.tableName.contains("Product:")) {
      futureData = TableClass.loadProductTable(
       widget.tableName.replaceAll("Product:", "").split(" ")[0], widget.tableName.replaceAll("Product:", "").split(" ")[1] );
      lastIndex.putIfAbsent(widget.tableName, () => 20);
    }
    if (widget.tableName.contains("Customers")) {
      var offset = _restoreScrollOffset('customerOffset');
      if (offset < 1) {
        customerData = TableClass.loadCustomerTable();
      }
      _scrollController = ScrollController(
        initialScrollOffset: offset,
      );
    }
    if (widget.tableName == "Inventory") {
      var offset = _restoreScrollOffset('inventoryOffset');
      if (offset < 1) {
        futureData = inventoryData = TableClass.loadInventoryTable();
      }
      _scrollController = ScrollController(
        initialScrollOffset: offset,
      );
    }
    if (widget.tableName == "Sales" || widget.tableName == "Supply") {
      var offset = _restoreScrollOffset(widget.tableName == "Sales" ? 'salesOffset':'supplyOffset');
      if (offset < 1) {
        futureData = salesData = TableClass.loadSalesTable(widget.tableName == "Sales" ? false : true);
      }
      _scrollController = ScrollController(
        initialScrollOffset: offset,
      );
    }


    if (widget.tableName == "Payments") {
      var offset = _restoreScrollOffset('paymentOffset');
      if (offset < 1) {
        futureData = paymentData = TableClass.loadPaymentTable();
      }
      _scrollController = ScrollController(
        initialScrollOffset: offset,
      );
    }

    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  double _restoreScrollOffset(String pref) {
    return MySavedPreferences.getPreference(pref) ?? 0.0;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print("Reached Bottom ${widget.tableName}");
      loadMoreItems(widget.tableName);
    }
    if (_scrollController.hasClients) {
      if (widget.tableName == "Inventory") {
        MySavedPreferences.addPreference(
            'inventoryOffset', _scrollController.offset);
      }
      if (widget.tableName  == "Customers") {
        MySavedPreferences.addPreference(
            'customerOffset', _scrollController.offset);
      }
    }
  }

  void loadMoreItems(String table) {
    if (!isLoading) {
      // setState(() {
      //   isLoading = true;
      // });


      if (widget.tableName == "Inventory") {
        Map<String, dynamic> data = widget.searchQuery;
        print("Inventory data $data");
        if (data["Search"].isEmpty) {
          inventoryData?.then((value) async => {
                value.addAll(TableClass.addIndex(
                    value.length,
                    await FirebaseClass.loadNextPage(
                        MySavedPreferences.getPreference(
                            "inventory.nextPageToken"), "Product"))),
                inventoryData?.then((value2) => {
                      lastIndex[table] = value2.length,
                      setState(() {
                        isLoading = false;
                      })
                    })
              });
        }
      }
      if (widget.tableName == "Customers") {
        if (widget.searchQuery.isEmpty) {
          try {

          } catch (e) {
            print(e);
          }
        }
      }
    }
  }

  static String lastQuery = "";
  static String startDate = "";
  static String endDate = "";
  static bool reloaded = false;
  Future<List<Map<String, dynamic>>> searchInventory(String query) async {
    return FirebaseClass.searchInventory(query.trim().toUpperCase());
  }
  Future<List<Map<String, dynamic>>> searchCustomers(String query) async {
    return FirebaseClass.searchCustomers(query.trim());
  }
  Future<List<Map<String, dynamic>>> searchSales(String query, bool isSupply) async {
    return FirebaseClass.searchSales(query.trim(),isSupply);
  }
  Future<List<Map<String, dynamic>>> filterSales(DateTime startDate,DateTime endDate, bool isSupply) async {
    return FirebaseClass.filterSales(startDate, endDate, isSupply);
  }
  Future<List<Map<String, dynamic>>> searchPayments(String query) async {
    return FirebaseClass.searchPayments(query.trim());
  }
  Future<List<Map<String, dynamic>>> filterPayments(DateTime startDate,DateTime endDate) async {
    return FirebaseClass.filterPayments(startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    lastIndex.putIfAbsent(widget.tableName, () => 20);
    setAvailableColumns();
    loadTable();



    return FutureBuilder(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AlertDialog(
              title: const Text('Searching...'),
              content: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                child: Container(
                  transform: Matrix4.translationValues(10, 5, 0),
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(strokeWidth: 5.0,color: mainColor,),
                ),
              ));
        } else if (snapshot.hasError) {
          return  Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Icon(Icons.wifi_off_sharp, size: size.height * 0.13, color: mainColor,),
              Text("          Error in Connecting to Database\nCheck your Internet Connection and Try again",  style: TextStyle(fontFamily: "Claredon", fontSize: size.height * 0.03,  fontWeight: FontWeight.w400)),
            ],
          ));
        } else if (!snapshot.hasData) {
          return const Text("No Data Available");
        } else {
          if(widget.tableName == "Sales"){
            totalSales = snapshot.data!.length;
            totalAmount = 0;
           snapshot.data?.forEach((element) {
             totalAmount += element["Amount"]! as int;
           }) ;

          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 30),
                    child: bodyData3(snapshot.data!, size)),
              )
            ],
          );
        }
      },
    );
  }

  Future<void> loadTable() async {
    if (widget.tableName == "Inventory") {
      print(" inventoryData $inventoryData ");
      Map<String, dynamic> data = widget.searchQuery;
      print(" Search last query $lastQuery ${data["Search"]} ");
      if(data["Search"].isNotEmpty && lastQuery != data["Search"] ){
        print(" Searching ${data["Search"]} ");
        futureData =inventoryData = searchInventory(data["Search"].toString());
        lastQuery = data["Search"].toString();
        reloaded = false;
      }
      else if(data["Reload"] && !reloaded){
        futureData =inventoryData = TableClass.loadInventoryTable();
        lastQuery = data["Search"].toString();
        reloaded = true;
      }
      else{
        try {
          futureData = inventoryData;
        } catch (e) {
          print(e);
          futureData = inventoryData = TableClass.loadInventoryTable();
        }
      }
    }

    if (widget.tableName.contains("Product:")) {
      futureData = TableClass.loadProductTable(
          widget.tableName.replaceAll("Product:", "").split(" ")[0], widget.tableName.replaceAll("Product:", "").split(" ")[1]
      );
      lastQuery = widget.searchQuery;
    }


    if (widget.tableName == "Customers") {
      Map<String, dynamic> data = widget.searchQuery;
      if(data["Search"].isNotEmpty && lastQuery != data["Search"] ){
        futureData =customerData = searchInventory(data["Search"].toString());
        lastQuery = data["Search"].toString();
        reloaded = false;
      }
      else if(data["Reload"] && !reloaded){
        futureData =customerData = TableClass.loadInventoryTable();
        lastQuery = data["Search"].toString();
        reloaded = true;
      }
      else{
        try {
          futureData = customerData;
        } catch (e) {
          print(e);
          futureData = customerData = TableClass.loadInventoryTable();
        }
      }
    }

    if (widget.tableName == "Sales" || widget.tableName == "Supply") {
      Map<String, dynamic> data = widget.searchQuery;
      if(data["Search"].isNotEmpty && lastQuery != data["Search"] ){
        print(" Search last query $lastQuery ${data["Search"]} ");
        futureData = searchSales(data["Search"].toString(), widget.tableName == "Supply");
        lastQuery = data["Search"].toString();
      }else if(data["StartDate"].toString() != "" || data["EndDate"].toString() != endDate ){
        print("MATCH $startDate = StartDate ${data["StartDate"]} endDate $endDate = EndDate ${data["EndDate"]}");
        futureData = filterSales(data["StartDate"], data["EndDate"], widget.tableName == "Supply");
        startDate = data["StartDate"].toString();
        endDate = data["EndDate"].toString();
        lastQuery = data["Search"].toString();
      }
      else{
        futureData = salesData;
      }
    }





    if (widget.tableName == "Payments") {
      Map<String, dynamic> data = widget.searchQuery;
      if(data["Search"].isNotEmpty && lastQuery != data["Search"] ){
        print(" Search Payments last query $lastQuery ${data["Search"]} ");
        futureData = searchPayments(data["Search"].toString());
        lastQuery = data["Search"].toString();
      }else if(data["StartDate"].toString() != "" || data["EndDate"].toString() != endDate ){
        print("Payments MATCH $startDate = StartDate ${data["StartDate"]} endDate $endDate = EndDate ${data["EndDate"]}");
        futureData = filterPayments(data["StartDate"], data["EndDate"]);
        startDate = data["StartDate"].toString();
        endDate = data["EndDate"].toString();
        lastQuery = data["Search"].toString();
      }
      else{
        futureData = paymentData;
      }
    }

  }

  Widget bodyData3(List<Map<String, dynamic>> payment, Size size) {
    dataTableShowLogs = false;
    return SizedBox(
      width: size.width * 0.9,
      child: DataTable2(
          scrollController: _scrollController,
          headingTextStyle: TextStyle(backgroundColor: WidgetClass.mainColor),
          headingRowColor: MaterialStateProperty.all(WidgetClass.mainColor),
          border: TableBorder(
            left: BorderSide(color: WidgetClass.mainColor),
            right: BorderSide(color: WidgetClass.mainColor),
          ),
          horizontalMargin: 0,
          headingRowHeight: 40,
          empty: Center(
              child: Text(
            "No Data in Table",
            style: TextStyle(
                fontFamily: "Claredon",
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.022),
          )),
          dataRowHeight: 70,
          dividerThickness: 3,
          columnSpacing: 0,
          showCheckboxColumn: false,
          showBottomBorder: true,
          smRatio: 0.4,
          lmRatio: 2,
          columns: availableColumns,
          rows: payment
              .take(lastIndex[widget.tableName]!)
              .map((e) => DataRow(cells:setTableCells(e, payment.indexOf(e), widget.tableName)))
              .toList()),
    );
  }
  final dateFormat = DateFormat('dd-MM-yyyy');
  //FUNCTIONS
  void setAvailableColumns() {
    availableColumns = [];
    for (var element in widget.tableColumns.keys) {
      availableColumns.add(element == "No"
          ? DataColumn2(label: Center(child: Text(element)),fixedWidth: 50,)
          : DataColumn2(label: Center(child: Text(element)), size: widget.tableColumns[element]));
    }
  }
  //RETURN DATA
  void productData(Map<String, dynamic> data) {
    activePage = "Product";
    page = ProductPage(data: data);
    widget.myFunction.call();
  }
  void customersData(Map<String, dynamic> data) {
    activePage = "Profile";
    page = Profile(data: data);
    widget.myFunction.call();
  }
  void orderData(Map<String, dynamic> data) {
    selectedOrderData = data;
    widget.myFunction.call();
  }
  void referenceData(Map<String, dynamic> data) {
    selectedRefData = data;
    widget.myFunction.call();
  }


  int countIndex = 0;
  // TABLE CESS
  List<DataCell> setTableCells(e, int indexOf, String table) {
    availableCells = [];
    if (table.contains("Product:")) {
      availableCells = setProductCells(e, indexOf);
    }
    if (table.contains("Inventory")) {
      availableCells = setInventoryCells(e, indexOf);
    }
    if (table.contains("Customers")) {
      availableCells = setCustomerCells(e, indexOf);
    }
    if (table.contains("Sales")) {
      availableCells = setSalesCells(e, indexOf);
    }
    if (table.contains("Supply")) {
      availableCells = setSupplyCells(e, indexOf);
    }
    if (table.contains("Payments")) {
      availableCells = setPaymentCells(e, indexOf);
    }
    return availableCells;
  }

  List<DataCell> setProductCells(e, int indexOf) {
    availableCells = [];
    for (var element in widget.tableColumns.keys) {
      element == "No" ? element = "index" : element;
      indexOf + 1 == lastIndex[widget.tableName]
          ? availableCells.add(loadingDataCell(e))
          : availableCells.add(
          element == "Customer"
              ? productCustomerDataCell(e)
              : defaultDataCell(e, element == "Supplied"? "Sold": element));
    }
    return availableCells;
  }
  List<DataCell> setInventoryCells(e, int indexOf) {
    availableCells = [];
    for (var element in widget.tableColumns.keys) {
      element == "No" ? element = "index" : element;
      indexOf + 1 == lastIndex[widget.tableName]
          ? availableCells.add(loadingDataCell(e))
          : availableCells.add(element == "Image"
              ? imageDataCell(e)
              : element == "Name"
                  ? productNameDataCell(e)
                  : element == "Quantity"
                      ? productQtyDataCell(e)
                      : defaultDataCell(e, element));
    }
    return availableCells;
  }
  List<DataCell> setCustomerCells(e, int indexOf) {
    availableCells = [];
    for (var element in widget.tableColumns.keys) {
      element == "No" ? element = "index" : element;
      availableCells.add(element == "Name"? customerNameDataCell(e):element == "LastOrder"? customerOrderDataCell(e): defaultDataCell(e, element));
    }
    return availableCells;
  }
  List<DataCell> setSalesCells(e, int indexOf) {
    availableCells = [];
    for (var element in widget.tableColumns.keys) {
      element == "No" ? element = "index" : element;
      availableCells.add(salesDataCell(e, element));
    }
    return availableCells;
  }
  List<DataCell> setSupplyCells(e, int indexOf) {
    availableCells = [];
    for (var element in widget.tableColumns.keys) {
      element == "No" ? element = "index" : element;
      availableCells.add(salesDataCell(e, element));
    }
    return availableCells;
  }
  List<DataCell> setPaymentCells(e, int indexOf) {
    availableCells = [];
    for (var element in widget.tableColumns.keys) {
      element == "No" ? element = "index" : element;
      availableCells.add(paymentDataCell(e, element));
    }
    return availableCells;
  }

  //Data Cells
  DataCell imageDataCell(e) {
    return DataCell(
      StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () async{
            print(' enabled ${e["Order"]}');
            if(widget.tableName == "Sales"){
              return;
            }
            Map<String,dynamic> data = {};
            data = await FirebaseClass.getDynamic("Product", e["ProductID"]);
            data["Offset"] = MySavedPreferences.getPreference("inventoryOffset");
            productData(data);
          },
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: InventoryImage(productId: "${e["ProductID"]}",imageType: "Thumbnail", )
                ),
          ),
        );
      }),
    );
  }


  //GENERAL
  DataCell loadingDataCell(e) {
    return DataCell(
      StatefulBuilder(builder: (context, setState) {
        return Center(
          child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: CircularProgressIndicator(
                color: mainColor,
              )),
        );
      }),
    );
  }


  //Inventory DataCells
  DataCell productNameDataCell(e) {
    return DataCell(StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () async {
          print(' enabled ${e["Order"]}');
          if(widget.tableName == "Sales"){
            return;
          }
          Map<String,dynamic> data = {};
          data = await FirebaseClass.getDynamic("Product", e["ProductID"]);
          data["Offset"] = MySavedPreferences.getPreference("inventoryOffset");
          productData(data);

        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${e["Name"]}',style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text('Product ID: ${e["ProductID"]}',style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      );
    }), showEditIcon: false);
  }
  DataCell productQtyDataCell(e) {
    return DataCell(StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          print(' enabled ${e["Name"]}');

        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${e["Quantity"]}',style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), ),
              Text( '${widget.searchQuery["SelectedLocation"]??""}: ${e[widget.searchQuery["SelectedLocation"]]??"0"}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic), ),
            ],
          ),
        ),
      );
    }), showEditIcon: false);
  }
  DataCell productCustomerDataCell(e) {
    return DataCell(StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () async{
          print(' enabled ${e["Order"]}');
          selectedProductOrder = await FirebaseClass.getDynamic("Sales", e["Order"].toString());
          selectedProductOrder["Phone"]= await FirebaseClass.getDynamic("Customers", e["CustomerID"].toString(), "Phone");
          selectedProductOrder["Address"]= await FirebaseClass.getDynamic("Customers", e["CustomerID"].toString(), "Address");

          widget.myFunction.call();

        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${e["Customer"]}',style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
              Text( '${e["Customer"]}' == 'NewStock'? 'Ref: ${e["Order"]}': 'Order: ${e["Order"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
            ],
          ),
        ),
      );
    }), showEditIcon: false);
  }

    //CUSTOMERS
  DataCell customerNameDataCell(e) {
    return DataCell(StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () async{
          if(widget.tableName == "Sales"){
            return;
          }
          Map<String,dynamic> data = {};
          data = await FirebaseClass.getDynamic("Customers", e["CustomerID"]);
          customersData(data);


        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${e["Name"]}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children:  [
                      const Text('ID:', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                      Text(
                        '${e["CustomerID"]}',style: const TextStyle(color: Colors.black54,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox()
                ],
              ),
            ],
          ),
        ),
      );
    }), showEditIcon: false);
  }
  DataCell customerOrderDataCell(e) {
    return DataCell(StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onDoubleTap: () {
          setState(() {});
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${e["LastOrder"]}' == "" ? '${e["LastOrder"]}' : dateFormat.format(DateTime.parse('${e["LastOrder"]}')),
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children:  [
                       Text('${e["LastOrder"]}' == "" ?"":'Order:', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                      Text(
                        '${e["LastOrder"]}' == "" ? "" :  '${e["LastOrderNo"]}',
                        style: const TextStyle(color: Colors.black54,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox()
                ],
              ),
            ],
          ),
        ),
      );
    }), showEditIcon: false);
  }

  //SALES

  DataCell salesDataCell(e, element) {
    final Map<String, TextStyle> textStyles = {
      "Date": const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      "Name": const TextStyle(fontWeight: FontWeight.bold),
      "Amount": const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
      "Paid": const TextStyle(fontWeight: FontWeight.bold),
      "Balance": const TextStyle(fontWeight: FontWeight.bold),
      "Status": const TextStyle(fontWeight: FontWeight.bold),
    };

    final Map<String, List<Widget>> childWidgets = {
      "Date": [
        GestureDetector(
          onTap: ()async{
            orderData(
                {"Order": e["Order"],
                  "Name": e["Name"],
                  "Phone": await FirebaseClass.getDynamic("Customers", e["CustomerID"].toString(), "Phone"),
                  "Address": await FirebaseClass.getDynamic("Customers", e["CustomerID"].toString(), "Address"),
                  "Products": e["Products"],
                  "Amount": e["Amount"],
                  "Paid": e["Paid"],
                  "Method": e["Method"],
                  "Reference": e["Reference"],
                  "Date": e["Date"],
                }
            );

          },
            child: Column(
              children: [
                Text(dateFormat.format(DateTime.parse('${e["Date"]}')), style:textStyles[element]),
                Text( 'Order: ${e["Order"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
              ],
            ))
        ,
      ],
      "Name": [
        Text(e["Name"].toString(), style: textStyles[element]),
        Text('ID: ${e["CustomerID"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
      ],
      "Amount": [
        Text(LogicClass.returnCommaValue('${e["Amount"]}'), style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
      "Paid": [
        Text( '${e["Paid"]}', style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
        Text( '${e["Method"]}' == 'Cash'? 'Cash':'${e["Account"]}', ),
      ],
      "Balance": [
        Text(e["Balance"].toString(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
      ],
      "Status": [
        appName == "Management"?
        PaymentConfirm(status:e["Status"], ref:e["Order"].toString(), collection: "Sales",):
        Text(e["Status"], style: TextStyle(color:e["Status"] == "Unconfirmed"? Colors.red: Colors.green , fontWeight: FontWeight.bold)),
      ],
    };

    final child = Column(
      crossAxisAlignment: element== "Name"?CrossAxisAlignment.stretch: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: childWidgets[element] ?? [
        Text('${e[element]}', style: textStyles[element]),
      ],
    );

    return DataCell(Center(child: child));
  }

  DataCell supplyDataCell(e, element) {
    final Map<String, TextStyle> textStyles = {
      "Date": const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      "Name": const TextStyle(fontWeight: FontWeight.bold),
      "Items": const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
      "SuppliedDate": const TextStyle(fontWeight: FontWeight.bold),
      "Status": const TextStyle(fontWeight: FontWeight.bold),
    };

    final Map<String, List<Widget>> childWidgets = {
      "Date": [
        GestureDetector(
            onTap: ()async{
              orderData(
                  {"Order": e["Order"],
                    "Name": e["Name"],
                    "Phone": await FirebaseClass.getDynamic("Customers", e["CustomerID"].toString(), "Phone"),
                    "Address": await FirebaseClass.getDynamic("Customers", e["CustomerID"].toString(), "Address"),
                    "Products": e["Products"],
                    "Amount": e["Amount"],
                    "Paid": e["Paid"],
                    "Method": e["Method"],
                    "Reference": e["Reference"],
                    "Date": e["Date"],
                  }
              );

            },
            child: Column(
              children: [
                Text(dateFormat.format(DateTime.parse('${e["Date"]}')), style:textStyles[element]),
                Text( 'Order: ${e["Order"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
              ],
            ))
        ,
      ],
      "Name": [
        Text(e["Name"].toString(), style: textStyles[element]),
        Text('ID: ${e["CustomerID"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
      ],
      "Items": [
        Text('${e["Items"]}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
      "SuppliedDate": [
        Text(e["SuppliedDate"].toString(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
      ],
      "Status": [
        appName == "Management"?
        PaymentConfirm(status:e["Status"], ref:e["Order"].toString(), collection: "Sales",):
        Text(e["Status"], style: TextStyle(color:e["Status"] == "Unconfirmed"? Colors.red: Colors.green , fontWeight: FontWeight.bold)),
      ],
    };

    final child = Column(
      crossAxisAlignment: element== "Name"?CrossAxisAlignment.stretch: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: childWidgets[element] ?? [
        Text('${e[element]}', style: textStyles[element]),
      ],
    );

    return DataCell(Center(child: child));
  }

  DataCell paymentDataCell(e, element) {
    final Map<String, TextStyle> textStyles = {
      "Date": const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      "Name": const TextStyle(fontWeight: FontWeight.bold),
      "Description": const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
      "Paid": const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
      "Account": const TextStyle(fontWeight: FontWeight.bold),
      "Status": const TextStyle(fontWeight: FontWeight.bold),
    };

    final Map<String, List<Widget>> childWidgets = {
      "Date": [
        Text(dateFormat.format(DateTime.parse('${e["Date"]}')), style:textStyles[element]),
        Text('Ref: ${e["Reference"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
      ],
      "Name": [
        Text(e["Name"].toString(), style: textStyles[element]),
        Text('ID: ${e["CustomerID"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
      ],
      "Description": [
        Text(e["Description"].toString(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        GestureDetector( onTap: ()async{
          referenceData(
                  {"Order": e["Order"],
                  "Name": e["Name"],
                  "Phone": await FirebaseClass.getDynamic("Customers", e["CustomerID"].toString(), "Phone"),
                  "Address": await FirebaseClass.getDynamic("Customers", e["CustomerID"].toString(), "Address"),
                  "Products": await FirebaseClass.getDynamic("Sales", e["Order"].toString(), "Products"),
                  "Amount": e["Amount"],
                  "Paid": e["Paid"],
                  "Method": e["Method"],
                  "Reference": e["Reference"],
                  "Date": e["Date"],
                  }
                  );

    },child: Text('OD:${e["Order"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
      ],

      "Paid": [
        Text(LogicClass.returnCommaValue('${e["Amount"]}').replaceAll("N", ""), style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(e["Method"], style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
      ],
      "Account": [
        Text(e["Account"].toString().split(" ")[0], style: textStyles[element]),
        Text(e["Account"].toString().split(" ")[1], style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
      ],
      "Status": [
        appName == "Management"?
        PaymentConfirm(status:e["Status"], ref:e["Reference"].toString(),  collection: "Transactions"):
        Text(e["Status"], style: TextStyle(color:e["Status"] == "Unconfirmed"? Colors.red: Colors.green , fontWeight: FontWeight.bold)),
      ],
    };

    final child = Column(
      crossAxisAlignment: element== "Name" || element== "Description"?CrossAxisAlignment.stretch: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: childWidgets[element] ?? [
        Text('${e[element]}', style: textStyles[element]),
      ],
    );

    return DataCell(Center(child: child));
  }


  DataCell defaultDataCell(e, element) {
    return DataCell(Center(
        child:  Text(element == "Date"
            ? dateFormat.format(DateTime.parse('${e["Date"]}'))
            : '${e[element]}')));
  }
}
