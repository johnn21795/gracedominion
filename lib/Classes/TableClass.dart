
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Desktop/WidgetClass.dart';
import '../Interface/MainInterface.dart';
import '../Interface/Product.dart';

class TableClass extends StatefulWidget {
  final Map<String, dynamic> tableColumns;
  final String tableName;
  final Function() myFunction;
  const TableClass({super.key, required this.tableColumns, required this.tableName, required this.myFunction});

  static List<Map<String, dynamic>> returnData = [];
  static String lastCard = "";
  static Future<List<Map<String, dynamic>>> loadPayment(String card) async {

    card == "Inventory" ?
    returnData = getInventoryData():
    returnData = List.generate(30, (index) => {
      "index":index+1, "Name":"CHUKWUDI", "Phone":08143255147, "Orders":"9 Orders", "Amount Spent" :"980,000,000", "Balance": "0"
    });

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

  @override
  State<TableClass> createState() => _TableClassState();
}

int lastIndex = 20;
class _TableClassState extends State<TableClass> {
  bool isLoading = false;
  int pageCount = 1;
  ScrollController _scrollController = ScrollController();

  List<DataColumn> availableColumns = [];

  List<DataCell>  availableCells = [];
  // Map<String, dynamic> tableColumns = {"No" :0,"Image":1,"Name":2,"Category":3,"SKU":4,"Quantity":5,"Comment":6};

  static late Future<List<Map<String, dynamic>>>? futureData ;


  @override
  void initState()  {
    print("_TableClassState  initializing...");
    futureData = TableClass.loadPayment(widget.tableName);
    _scrollController = ScrollController(
      initialScrollOffset: _restoreScrollOffset(),
    );
    print("_scrollController initializing........ $_scrollController  _restoreScrollOffset ${_restoreScrollOffset()}");
    _scrollController.addListener(_scrollListener);
    super.initState();
  }
  double _restoreScrollOffset() {
    return MySavedPreferences.getPreference('scrollOffset') ?? 0.0;
  }

  @override
  void dispose() {
    print("_TableClassState  Disposing.......");

    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }



  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the bottom of the list
      print("Reached Bottom");
      loadMoreItems();
    }
    print("Offset Bottom: ${_scrollController.offset} ....._scrollController  $_scrollController");
    if(_scrollController.hasClients){
      MySavedPreferences.addPreference('scrollOffset', _scrollController.offset);
    }
  }


  void loadMoreItems() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      // Simulate loading delay
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          // Generate new items for the next page
          lastIndex += 10;
          isLoading = false;
        });
      });
    }
  }

  void loadPayment(){
    futureData = null;
    futureData = TableClass.loadPayment(widget.tableName);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setAvailableColumns();
    return FutureBuilder(
      future: futureData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return const Center(child: CircularProgressIndicator());
        } else {


          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
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
          headingTextStyle:   TextStyle(backgroundColor: WidgetClass.mainColor),
          headingRowColor: MaterialStateProperty.all(WidgetClass.mainColor),
          border:  TableBorder(
            left: BorderSide(color: WidgetClass.mainColor),
            right: BorderSide(color: WidgetClass.mainColor),
          ),
          horizontalMargin: 0,
          headingRowHeight: 40,
          dataRowHeight: 70,
          dividerThickness: 3,
          columnSpacing: 0,
          showCheckboxColumn: false,
          showBottomBorder: true,
          smRatio: 0.4,
          lmRatio: 2,
          columns: availableColumns,
          rows: payment.take(lastIndex)
              .map((e) => DataRow(
              cells: widget.tableName == "Inventory" ? setInventoryCells(e, payment.indexOf(e)): setCustomerCells(e) ) ).toList()


      ),
    );
  }

  void setAvailableColumns(){
    availableColumns = [];
    // var mapEntries = widget.tableColumns.entries.toList()
    //   ..sort((a, b) => a.value.compareTo(b.value));
    // tableColumns
    //   ..clear()
    //   ..addEntries(mapEntries);

    for (var element in  widget.tableColumns.keys) {
      availableColumns.add(
          element == "No"? DataColumn2(
            label:  Center(child: Text(element)),
            fixedWidth: 50,
            onSort: (_, __) {
            },
          ):
          DataColumn2(
            label:  Center(child: Text(element)),
            size:   widget.tableColumns[element],
            // size:  element == "Image" || element == "Quantity"  || element == "SKU" || element == "Comment"? ColumnSize.S :  element == "Name"? ColumnSize.L:  ColumnSize.M,
            onSort: (_, __) {
            },
          )
      );
    }

  }
  final dateFormat = DateFormat('dd-MM-yyyy');

  List<DataCell> setAvailableCells(e){
    print("Setting Available Cells");
    availableCells = [];
    for (var element in  widget.tableColumns.keys) {

      element == "No"? element = "index": element;

      availableCells.add(
        element == "Image"?  imageDataCell(e):
        element == "Name"? productNameDataCell(e)
            :
        DataCell(
          Center(child:
          Text(
              element == "Date"? dateFormat.format(DateTime.parse('${e["Date"]}')) : '${e[element]}'
          )
          ),
        ),
      );
    }


    return availableCells;
  }

  int countIndex = 0;
  List<DataCell> setInventoryCells(e, int indexOf) {
    print(" Inventory Index $indexOf  greater than lastIndex $lastIndex" );
    availableCells = [];
    for (var element in  widget.tableColumns.keys) {
      element == "No"? element = "index": element;
      indexOf+1 == lastIndex ?
      availableCells.add(
          loadingDataCell(e)
      ):
      availableCells.add(
          element == "Image"?  imageDataCell(e):
          element == "Name"? productNameDataCell(e):defaultDataCell(e, element)
      )
      ;

      ;
    }
    return availableCells;
  }

  List<DataCell> setCustomerCells(e){
    print("Setting Customers Cells");
    availableCells = [];
    for (var element in  widget.tableColumns.keys) {
      element == "No"? element = "index": element;
      availableCells.add(
          element == "Name"? customerNameDataCell(e):defaultDataCell(e, element)
      );
    }
    return availableCells;
  }

  //Data Cells
  DataCell imageDataCell(e){
    return DataCell(
      StatefulBuilder(builder: (context, setState){
        return GestureDetector(
          onTap: () {
            print(' enabled ${e["Name"]}');
            returnData(
                {"Name": e["Name"]?? "",
                  "Offset":MySavedPreferences.getPreference("scrollOffset"),
                  "Model":e["Model"]?? "",
                  "Category":e["Category"]?? "",
                  "Quantity":e["Quantity"]?? "0",
                  "Comment":e["Comment"]?? "",
                  "ProductID":e["ProductID"]?? "",
                });
            setState((){});
          },
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Image(
                image: AssetImage('assets/images/placeholder.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );}
      ),
    );
  }
  DataCell loadingDataCell(e){
    return DataCell(
      StatefulBuilder(builder: (context, setState){
        return const Center(
          child: Padding(
              padding: EdgeInsets.all(3.0),
              child: CircularProgressIndicator()
          ),
        );}
      ),
    );
  }

  void returnData(Map<String, dynamic> data){
    activePage = "Product";
    page =  ProductPage(data:data);
    widget.myFunction.call();
  }

  //Inventory DataCells
  DataCell productNameDataCell(e){
    return DataCell(
        StatefulBuilder(builder: (context, setState){
          return GestureDetector(
            onTap: () {
              print(' enabled ${e["Name"]}');
              // {"Name":"", "Model":"", "Category":"", "Quantity":"0", "Comment":""}
              returnData(
                  {"Name": e["Name"]?? "",
                    "Offset":MySavedPreferences.getPreference("scrollOffset"),
                    "Model":e["Model"] ?? "",
                    "Category":e["Category"]?? "",
                    "Quantity":e["Quantity"]?? "0",
                    "Comment":e["Comment"]?? "",
                    "ProductID":e["ProductID"]?? "",
                  });

              // setState((){});
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${e["Name"]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children:  [
                          Text('Product ID:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,  fontStyle: FontStyle.italic),),
                          Text("${e["ProductID"]}", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic,  fontWeight: FontWeight.bold),),

                        ],
                      ),
                      const Text('Model:Yellow Color', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,  fontStyle: FontStyle.italic)),
                      const SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          );}
        ),
        showEditIcon: false);
  }
  DataCell customerNameDataCell(e){
    return DataCell(
        StatefulBuilder(builder: (context, setState){
          return GestureDetector(
            onDoubleTap: () {

              setState((){});
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${e["Name"]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text('Customer ID:', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,  fontStyle: FontStyle.italic),),
                          Text('21795', style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic,  fontWeight: FontWeight.bold),),
                        ],
                      ),
                      const Text('Last Order:25-05-2023', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,  fontStyle: FontStyle.italic)),
                      const SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          );}
        ),
        showEditIcon: false);
  }


  DataCell defaultDataCell(e, element){
    return DataCell(
        Center(child:
        Text(
            element == "Date"? dateFormat.format(DateTime.parse('${e["Date"]}')) : '${e[element]}'
        )
        )
    );
  }

}


getInventoryData() {

  List<Map<String, String>> returnDatas;
  returnDatas = [
    {"Name": "BREAD PAN", "Category": "OLD TYPE" },
    {"Name": "BREAD PAN", "Category": "NEW TYPE"},
    {"Name": "GAS POPCORN 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 12OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 16OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN ELECTRIC YELLOW", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 16OZ HP-16B", "Category": "POPCORN MACHINE"},
    {"Name": "ELECTRIC POPCORN MACHINE RED", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 12OZ HP-12B", "Category": "POPCORN MACHINE"},
    {"Name": "STAINLESS STEEL WORK TABLE WHT-2-712S/BN-W03 4FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-615RP/BN-W04 WITH SPLASH BACK 5FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-515TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE 6FT BN-W03", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-718W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723S 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-712W/HWT-3-612W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-69TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 5FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE CORNER HWT-69C", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 4FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-610TS WITH OVER SHELVE 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-615W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-618W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-713TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 6FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-713W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "BREAD PAN", "Category": "OLD TYPE" },
    {"Name": "BREAD PAN", "Category": "NEW TYPE"},
    {"Name": "GAS POPCORN 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 12OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 16OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN ELECTRIC YELLOW", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 16OZ HP-16B", "Category": "POPCORN MACHINE"},
    {"Name": "ELECTRIC POPCORN MACHINE RED", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 12OZ HP-12B", "Category": "POPCORN MACHINE"},
    {"Name": "STAINLESS STEEL WORK TABLE WHT-2-712S/BN-W03 4FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-615RP/BN-W04 WITH SPLASH BACK 5FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-515TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE 6FT BN-W03", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-718W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723S 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-712W/HWT-3-612W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-69TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 5FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE CORNER HWT-69C", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 4FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-610TS WITH OVER SHELVE 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-615W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-618W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-713TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 6FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-713W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "BREAD PAN", "Category": "OLD TYPE" },
    {"Name": "BREAD PAN", "Category": "NEW TYPE"},
    {"Name": "GAS POPCORN 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 12OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 16OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN ELECTRIC YELLOW", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 16OZ HP-16B", "Category": "POPCORN MACHINE"},
    {"Name": "ELECTRIC POPCORN MACHINE RED", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 12OZ HP-12B", "Category": "POPCORN MACHINE"},
    {"Name": "STAINLESS STEEL WORK TABLE WHT-2-712S/BN-W03 4FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-615RP/BN-W04 WITH SPLASH BACK 5FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-515TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE 6FT BN-W03", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-718W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723S 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-712W/HWT-3-612W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-69TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 5FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE CORNER HWT-69C", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 4FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-610TS WITH OVER SHELVE 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-615W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-618W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-713TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 6FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-713W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "BREAD PAN", "Category": "OLD TYPE" },
    {"Name": "BREAD PAN", "Category": "NEW TYPE"},
    {"Name": "GAS POPCORN 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 12OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 16OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN ELECTRIC YELLOW", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 16OZ HP-16B", "Category": "POPCORN MACHINE"},
    {"Name": "ELECTRIC POPCORN MACHINE RED", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 12OZ HP-12B", "Category": "POPCORN MACHINE"},
    {"Name": "STAINLESS STEEL WORK TABLE WHT-2-712S/BN-W03 4FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-615RP/BN-W04 WITH SPLASH BACK 5FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-515TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE 6FT BN-W03", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-718W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723S 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-712W/HWT-3-612W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-69TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 5FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE CORNER HWT-69C", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 4FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-610TS WITH OVER SHELVE 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-615W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-618W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-713TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 6FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-713W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "BREAD PAN", "Category": "OLD TYPE" },
    {"Name": "BREAD PAN", "Category": "NEW TYPE"},
    {"Name": "GAS POPCORN 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 12OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 16OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN ELECTRIC YELLOW", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 16OZ HP-16B", "Category": "POPCORN MACHINE"},
    {"Name": "ELECTRIC POPCORN MACHINE RED", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 12OZ HP-12B", "Category": "POPCORN MACHINE"},
    {"Name": "STAINLESS STEEL WORK TABLE WHT-2-712S/BN-W03 4FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-615RP/BN-W04 WITH SPLASH BACK 5FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-515TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE 6FT BN-W03", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-718W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723S 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-712W/HWT-3-612W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-69TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 5FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE CORNER HWT-69C", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 4FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-610TS WITH OVER SHELVE 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-615W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-618W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-713TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 6FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-713W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "BREAD PAN", "Category": "OLD TYPE" },
    {"Name": "BREAD PAN", "Category": "NEW TYPE"},
    {"Name": "GAS POPCORN 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 12OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 16OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN ELECTRIC YELLOW", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 16OZ HP-16B", "Category": "POPCORN MACHINE"},
    {"Name": "ELECTRIC POPCORN MACHINE RED", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN POT 8OZ", "Category": "POPCORN MACHINE"},
    {"Name": "POPCORN MACHINE 12OZ HP-12B", "Category": "POPCORN MACHINE"},
    {"Name": "STAINLESS STEEL WORK TABLE WHT-2-712S/BN-W03 4FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-615RP/BN-W04 WITH SPLASH BACK 5FEET", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-515TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE 6FT BN-W03", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-718W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723S 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-712W/HWT-3-612W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-69TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 5FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE CORNER HWT-69C", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 4FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-612TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-610TS WITH OVER SHELVE 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE NOBILE HWT-3-615W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-618TS WITH OVER SHELVE 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-618W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-713TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W05 6FT 3STEPS", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 7FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-713W 4FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-723W 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-621TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-623TS WITH OVER SHELVE 6FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-723TS WITH OVER SHELVE 9FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 10FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-WO4 WITH SPLASH BACK 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-721TS WITH OVER SHELVE 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 8FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE BN-W03 3FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE MOBILE HWT-3-615W 5FT", "Category": "WORK TABLE"},
    {"Name": "STAINLESS STEEL WORK TABLE HWT-2-719TS WITH OVER SHELVE 7FT", "Category": "WORK TABLE"}
  ];


  return returnDatas;

}