import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Classes/LogicClass.dart';
import 'package:intl/intl.dart';

import '../Desktop/WidgetClass.dart';
import '../Interface/MainInterface.dart';
import '../Interface/Product.dart';

class TableClass extends StatefulWidget {
  final Map<String, dynamic> tableColumns;
  final String tableName;
  final Function() myFunction;
  final String searchQuery;
  const TableClass(
      {super.key,
      required this.tableColumns,
      required this.tableName,
      required this.myFunction,
      this.searchQuery = ""});

  static List<Map<String, dynamic>> returnData = [];

  static Future<List<Map<String, dynamic>>> loadProductTable(
      String productID) async {
    returnData = [];
    returnData = await FirebaseClass.loadProductHistory(productID);
    return returnData;
  }

  static Future<List<Map<String, dynamic>>> loadInventoryTable() async {
    returnData = [];
    returnData = await FirebaseClass.loadInventory();
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

Map<String, int> lastIndex = {"Inventory": 15, "Customers": 20};

class _TableClassState extends State<TableClass> {
  bool isLoading = false;
  int pageCount = 1;
  ScrollController _scrollController = ScrollController();

  List<DataColumn> availableColumns = [];

  List<DataCell> availableCells = [];
  late Future<List<Map<String, dynamic>>>? futureData;
  static late Future<List<Map<String, dynamic>>>? inventoryData;
  late Future<List<Map<String, dynamic>>>? searchData;

  @override
  void initState() {
    print("_TableClassState  initializing...${widget.tableName}");

    if (widget.tableName.contains("Product:")) {
      futureData = TableClass.loadProductTable(
          widget.tableName.replaceAll("Product:", ""));
      lastIndex.putIfAbsent(widget.tableName, () => 20);
    }
    if (widget.tableName == "Inventory") {
      var offset = _restoreScrollOffset();
      if (offset < 1) {
        inventoryData = TableClass.loadInventoryTable();
      }
      _scrollController = ScrollController(
        initialScrollOffset: offset,
      );
    }

    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  double _restoreScrollOffset() {
    return MySavedPreferences.getPreference('scrollOffset') ?? 0.0;
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
      print("Reached Bottom");
      loadMoreItems(widget.tableName);
    }
    if (_scrollController.hasClients) {
      if (!widget.tableName.contains("Product:")) {
        MySavedPreferences.addPreference(
            'scrollOffset', _scrollController.offset);
      }
    }
  }

  void loadMoreItems(String table) {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      if (widget.tableName == "Inventory") {
        if (widget.searchQuery.isEmpty) {
          inventoryData?.then((value) async => {
                value.addAll(TableClass.addIndex(
                    value.length,
                    await FirebaseClass.loadNextPage(
                        MySavedPreferences.getPreference(
                            "inventory.nextPageToken")))),
                inventoryData?.then((value2) => {
                      lastIndex[table] = value2.length,
                      setState(() {
                        isLoading = false;
                      })
                    })
              });
        }
      }
    }
  }

  static String lastQuery = "";
  Future<List<Map<String, dynamic>>> searchInventory(String query) async {
    return FirebaseClass.searchInventory(query.trim());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    lastIndex.putIfAbsent(widget.tableName, () => 20);
    setAvailableColumns();
    if (widget.tableName == "Inventory") {
      if (widget.searchQuery.isNotEmpty) {
        if (lastQuery != widget.searchQuery) {
          futureData = searchInventory(widget.searchQuery);
          lastQuery = widget.searchQuery;
        }
      } else {
        futureData = inventoryData;
      }
    }
    else {
      futureData = inventoryData;
    }

    return FutureBuilder(
      future: futureData,
      // future: widget.tableName == "Inventory"
      //     ? widget.searchQuery.isNotEmpty
      //     ? searchData
      //     : inventoryData
      //     : futureData,
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
          return const Text("Error in fetching Data");
        } else if (!snapshot.hasData) {
          return const Text("No Data Available");
        } else {
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

  void setAvailableColumns() {
    availableColumns = [];
    for (var element in widget.tableColumns.keys) {
      availableColumns.add(element == "No"
          ? DataColumn2(label: Center(child: Text(element)),fixedWidth: 50,)
          : DataColumn2(label: Center(child: Text(element)), size: widget.tableColumns[element]));
    }
  }

  final dateFormat = DateFormat('dd-MM-yyyy');


  int countIndex = 0;

  List<DataCell> setTableCells(e, int indexOf, String table) {
    availableCells = [];
    if (table.contains("Product:")) {
      availableCells = setProductCells(e, indexOf);
    }
    if (table.contains("Inventory")) {
      availableCells = setInventoryCells(e, indexOf);
    }
    return availableCells;
  }

  List<DataCell> setProductCells(e, int indexOf) {
    print(" ProductCell Index $indexOf  greater than lastIndex $lastIndex");
    availableCells = [];
    for (var element in widget.tableColumns.keys) {
      element == "No" ? element = "index" : element;
      indexOf + 1 == lastIndex[widget.tableName]
          ? availableCells.add(loadingDataCell(e))
          : availableCells.add(element == "Customer"
              ? productCustomerDataCell(e)
              : defaultDataCell(e, element));
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

  List<DataCell> setCustomerCells(e) {
    availableCells = [];
    for (var element in widget.tableColumns.keys) {
      element == "No" ? element = "index" : element;
      availableCells.add(element == "Name"? customerNameDataCell(e): defaultDataCell(e, element));
    }
    return availableCells;
  }

  //Data Cells
  DataCell imageDataCell(e) {
    return DataCell(
      StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            returnData({
              "Name": e["Name"] ?? "",
              "Offset": MySavedPreferences.getPreference("scrollOffset"),
              "Model": e["Model"] ?? "",
              "Category": e["Category"] ?? "",
              "Quantity": e["Quantity"] ?? "0",
              "Comment": e["Comment"] ?? "",
              "ProductID": e["ProductID"] ?? "",
            });
            setState(() {});
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

  void returnData(Map<String, dynamic> data) {
    activePage = "Product";
    page = ProductPage(data: data);
    widget.myFunction.call();
  }

  //Inventory DataCells
  DataCell productNameDataCell(e) {
    return DataCell(StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          print(' enabled ${e["Name"]}');
          returnData({
            "Name": e["Name"] ?? "",
            "Offset": MySavedPreferences.getPreference("scrollOffset"),
            "Model": e["Model"] ?? "",
            "Category": e["Category"] ?? "",
            "Quantity": e["Quantity"] ?? "0",
            "Comment": e["Comment"] ?? "",
            "ProductID": e["ProductID"] ?? "",
          });

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
              Text( 'SR:${e["Showroom"]} \nWH:${e["Warehouse"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic), ),
            ],
          ),
        ),
      );
    }), showEditIcon: false);
  }

  DataCell customerNameDataCell(e) {
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
              Text(
                '${e["Name"]}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text('Customer ID:', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                      Text(
                        '21795',style: TextStyle(color: Colors.black54,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Text('Last Order:25-05-2023', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
                  const SizedBox()
                ],
              ),
            ],
          ),
        ),
      );
    }), showEditIcon: false);
  }

//Product DataCells
  DataCell productCustomerDataCell(e) {
    return DataCell(StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          print(' enabled ${e["Customer"]}');
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${e["Customer"]}',style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
              Text( '${e["Customer"]}' == 'NewStock'? '': 'Order No: ${e["Order"]}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
            ],
          ),
        ),
      );
    }), showEditIcon: false);
  }

  DataCell defaultDataCell(e, element) {
    return DataCell(Center(
        child: Text(element == "Date"
            ? dateFormat.format(DateTime.parse('${e["Date"]}'))
            : '${e[element]}')));
  }
}
