
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Showroom/MainInterface.dart';
import 'package:intl/intl.dart';

import '../Desktop/WidgetClass.dart';



Size? screenSize;
final dateFormat = DateFormat('dd-MM-yyyy');
class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  bool isTyping = false;
  final cardController = TextEditingController();
  String cardLabel = "Search Customer";
  Color labelColor = WidgetClass.mainColor;
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      floatingActionButton: MyFloatingActionButton(
        text: 'Add New Customer',
        onPressed: (){},
      ),
      body:  Stack(
        children: [
          Positioned(
            left:10,
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  height: 100,
                  width: screenSize!.width * 0.35,
                  child: TextField(
                    onSubmitted: (query){

                    },
                    onChanged: (card) async {
                      setState(() { });
                    },
                    style: const TextStyle(fontSize: 14),
                    controller: cardController,
                    decoration:  InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: labelColor, width: 2.0),
                        ),
                        suffixIcon: isSearching? Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                          child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child: const CircularProgressIndicator(strokeWidth: 2.0 )),
                        ): const SizedBox(),
                        label: Text(
                          cardLabel,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              textBaseline: TextBaseline.alphabetic),
                        ),labelStyle: TextStyle(fontSize: 12, color: labelColor)
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Container(
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: MyCustomButton(
                      text: "Search",
                      onPressed: (){},
                      icon: Icons.search,
                      size: const Size(130, 38)
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top:50,
            child: SizedBox(
                height: screenSize!.height * 0.87,
                child:  TableClass(tableColumns: const {"No" :ColumnSize.S,"Name":ColumnSize.M,"Phone":ColumnSize.M,"Orders":ColumnSize.S,"Amount Spent":ColumnSize.S,"Balance":ColumnSize.S}, tableName: "Customers", myFunction: (){},)),
          )
        ],
      )
      ,
    );
  }
}

// class TableClass extends StatefulWidget {
//   const TableClass({super.key});
//
//   static List<Map<String, dynamic>> returnData = [];
//   static String lastCard = "";
//   static Future<List<Map<String, dynamic>>> loadPayment(String card) async {
//     // if (card != lastCard) {
//     //   // returnData = await MainClass.loadPayment(card);
//     //   returnData = List.generate(30, (index) => {
//     //     "Image": "Kitchen", "Name":"ELECTRIC GRIDDLE STANDING WITH CABINET HALF GROOVED HALF SMOOTH BIG", "Quantity":5, "SKU":"YEG-2-4DG", "Category" :"ELECTRIC GRIDDLE STANDING"
//     //   });
//     //   lastCard = card;
//     //   print("Operator Data............ $returnData");
//     // } else {
//     //   lastCard = card;
//     // }
//     returnData = List.generate(30, (index) => {
//       "index":index+1, "Image":  "Kitchen", "Name":"ELECTRIC GRIDDLE STANDING WITH CABINET HALF GROOVED HALF SMOOTH BIG", "Quantity":5000, "SKU":"YEG-2-4DG", "Category" :"ELECTRIC GRIDDLE STANDING"
//     });
//     return returnData;
//   }
//
//   @override
//   State<TableClass> createState() => _TableClassState();
// }
//
// class _TableClassState extends State<TableClass> {
//
//   List<DataColumn> selectedColumns = [];
//
//   List<DataColumn> availableColumns = [];
//
//   List<DataCell>  availableCells = [];
//   Map<String, int> tableColumns = {"No" :0,"Image":1,"Name":2,"Category":3,"SKU":4,"Quantity":5,"Comment":6};
//
//   static late Future<List<Map<String, dynamic>>>? futureData ;
//
//   static List<bool> editable = [];
//
//   @override
//   void initState() {
//     futureData = TableClass.loadPayment("2301302569");
//     // futureData!.then((value) => {
//     //   editable = List.generate(value.length, (index) => false)
//     // });
//     super.initState();
//   }
//
//   static void loadPayment(){
//     futureData = null;
//     futureData = TableClass.loadPayment("2301302569");
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     setAvailableColumns();
//
//     return FutureBuilder(
//       future: futureData,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           print("Operator Data............ ${snapshot.data} ");
//           editable = List.generate(snapshot.data!.length, (index) => false);
//           print(editable);
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             verticalDirection: VerticalDirection.down,
//             children: <Widget>[
//               Expanded(
//                 child: Container(
//                     padding: const EdgeInsets.all(5),
//                     child: bodyData3(snapshot.data!, size)),
//               )
//             ],
//           );
//         }
//       },
//     );
//   }
//
//   Widget bodyData3(List<Map<String, dynamic>> payment, Size size) {
//     bool enabled = false;
//     dataTableShowLogs = false;
//     return SizedBox(
//       width: size.width * 0.9,
//       child: DataTable2(
//           headingTextStyle:  const TextStyle(backgroundColor: MainInterface.mainColor),
//           headingRowColor: MaterialStateProperty.all(MainInterface.mainColor),
//           border: const TableBorder(
//             left: BorderSide(color: MainInterface.mainColor),
//             right: BorderSide(color: MainInterface.mainColor),
//           ),
//           horizontalMargin: 0,
//           headingRowHeight: 40,
//           dataRowHeight: 70,
//           dividerThickness: 3,
//           columnSpacing: 0,
//           showCheckboxColumn: false,
//           showBottomBorder: true,
//           smRatio: 0.4,
//           lmRatio: 2,
//           columns: availableColumns,
//           rows: payment
//               .map((e) => DataRow(
//               cells: setAvailableCells(e)))
//               .toList()),
//     );
//   }
//
//   void setAvailableColumns(){
//     availableColumns = [];
//     var mapEntries = tableColumns.entries.toList()
//       ..sort((a, b) => a.value.compareTo(b.value));
//     tableColumns
//       ..clear()
//       ..addEntries(mapEntries);
//
//     for (var element in tableColumns.keys) {
//       availableColumns.add(
//           element == "No"? DataColumn2(
//             label:  Center(child: Text(element)),
//             fixedWidth: 50,
//             onSort: (_, __) {
//             },
//           ):
//           DataColumn2(
//             label:  Center(child: Text(element)),
//             size:  element == "Image" || element == "Quantity"  || element == "SKU" || element == "Comment"? ColumnSize.S :  element == "Name"? ColumnSize.L:  ColumnSize.M,
//             onSort: (_, __) {
//             },
//           )
//       );
//     }
//
//   }
//   List<DataCell> setAvailableCells(e){
//     print("Setting Available Cells");
//     availableCells = [];
//     for (var element in tableColumns.keys) {
//
//       element == "No"? element = "index": element;
//
//       bool x =false;
//       availableCells.add(
//         element == "Image"?  DataCell(
//           StatefulBuilder(builder: (context, setState){
//
//             return GestureDetector(
//               onDoubleTap: () {
//                 print('onSubmited enabled');
//                 editable[int.parse("${e["index"]}") -1] = !editable[int.parse("${e["index"]}") -1];
//                 print( editable[int.parse("${e["index"]}") -1]);
//                 setState((){});
//               },
//               child: const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(3.0),
//                   child: Image(
//                     image: AssetImage('assets/images/profile.jpg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             );}
//           ),
//         ):
//         element == "Name"?
//         DataCell(
//             StatefulBuilder(builder: (context, setState){
//               return GestureDetector(
//                 onDoubleTap: () {
//                   print('onSubmited enabled');
//                   editable[int.parse("${e["index"]}") -1] = !editable[int.parse("${e["index"]}") -1];
//                   setState((){});
//                 },
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('${e[element]}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: const [
//                               Text('Product ID:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,  fontStyle: FontStyle.italic),),
//                               Text('3587', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic,  fontWeight: FontWeight.bold),),
//                             ],
//                           ),
//                           const Text('Model:Yellow Color', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,  fontStyle: FontStyle.italic)),
//                           const SizedBox()
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );}
//             ),
//             showEditIcon: false):
//         DataCell(
//           Center(child:
//           Text(
//               element == "Date"? dateFormat.format(DateTime.parse('${e["Date"]}')) : '${e[element]}'
//           )
//           ),
//         ),
//       );
//     }
//
//
//     return availableCells;
//   }
// }
