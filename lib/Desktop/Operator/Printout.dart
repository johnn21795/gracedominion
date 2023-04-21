import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../Classes/MainClass.dart';

class Printout extends StatefulWidget {
  const Printout({Key? key}) : super(key: key);

  @override
  State<Printout> createState() => _PrintoutState();
}

class _PrintoutState extends State<Printout> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: screenSize.width *0.02,
            top:5,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  transform: Matrix4.translationValues(0, 13, 0),
                    child: const Text("Branch", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),
                    )
                ),
                DropdownButton(
                  hint: const Text("Select Branch"),
                  value: "Alaba",
                  items: [
                    "Alaba",
                    "Card2",
                    "Card3",
                    "Card4"
                  ]
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
                      .toList(),
                  onChanged: (string) {
                    print("string $string");
                  },
                ),


              ],
            ),
          ),
          Positioned(
            left: screenSize.width *0.02,
            top: 100,
            child: Stack(
              children: [
                const Text("Staff", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),),
                DropdownButton(
                  hint: const Text("Select Staff"),
                  value: "Blessing Greta",
                  items: [
                    "Blessing Greta",
                    "Card2",
                    "Card3",
                    "Card4"
                  ]
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
                      .toList(),
                  onChanged: (string) {
                    print("string $string");
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: screenSize.width *0.02,
            top: screenSize.height *0.35,
            child: Stack(
              children: [
                const Text("Summary", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "copper"),),
              ],
            ),
          ),
          Positioned(
            left: screenSize.width *0.02,
            top: screenSize.height *0.35+20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Customers Recorded: 30", style: TextStyle( fontWeight: FontWeight.w300, fontSize: 14, fontFamily: "claredon"),),
                SizedBox(height: 10,),
                const Text("Total Cash: N75,000", style: TextStyle( fontWeight: FontWeight.w300, fontSize: 14, fontFamily: "claredon"),),
                SizedBox(height: 5,),
                const Text("Total Transfer: N300,000", style: TextStyle( fontWeight: FontWeight.w300, fontSize: 14, fontFamily: "claredon"),),
                SizedBox(height: 25,),
                const Text("Grand Total: N375,000", style: TextStyle( fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "claredon"),),
                SizedBox(height: 30,),
                Row(
                  children: [
                    const Text("Status:", style: TextStyle( fontWeight: FontWeight.w300, fontSize: 16, fontFamily: "claredon"),),
                    const Text("Verified", style: TextStyle( color:Color(0xFF005500) ,fontWeight: FontWeight.w300, fontSize: 16, fontFamily: "claredon"),),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
              left: screenSize.width *0.13,
              top: 102,
              child: SizedBox(
            width: 120,
            height: 38,
            child: Stack(
              children: [
                const Text("Date", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        showDatePicker(
                            firstDate: DateTime.utc(2022),
                            initialDate: DateTime.now(),
                            lastDate: DateTime.now(),
                            context: context);
                        setState(() {

                        });
                      },
                      child: const Icon(Icons.calendar_month),
                    ),
                  ),
                ),
              ],
            ),
          )),
          Positioned(
              // left: screenSize.width *0.15,
              right: 3,
              top: 0,
              child: SizedBox(
                // width: screenSize.width *0.7,
                  height: screenSize.height,
                  child: bodyData2(screenSize)))
        ],
      ),
    );
  }

  static List<Map<String, dynamic>> returnData = [];
  static String lastCard = "";
  static Future<List<Map<String, dynamic>>> loadPayment(String card) async {
    if (card != lastCard) {
      returnData = await MainClass.loadPayment(card);
      lastCard = card;
      print("Operator Data............ $returnData");
    } else {
      lastCard = card;
    }
    print("Operator Data............ $returnData");
    print("lastCard Data............ $lastCard");
    print("card Data............ $card");

    return returnData;
  }
  
  Widget bodyData2(Size size) {
    // dataTableShowLogs = false;
    return FutureBuilder(
      future: loadPayment("card"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: Container(

                    child: bodyData3(snapshot.data!, size)),
              )
            ],
          );
        }
      },
    );
  }

  Widget bodyData3(List<Map<String, dynamic>> payment, Size size) {
    bool enabled = false;
    dataTableShowLogs = false;
    return Container(
      width: size.width * 0.65,
      child: DataTable2(
          sortColumnIndex: 0,
          sortAscending: true,
          headingTextStyle: const TextStyle(backgroundColor: Colors.purple),
          headingRowColor: MaterialStateProperty.all(Colors.purple),
          border: const TableBorder(
            left: BorderSide(color: Colors.purple),
            right: BorderSide(color: Colors.purple),
          ),
          horizontalMargin: 0,
          headingRowHeight: 40,
          dataRowHeight: 45,
          dividerThickness: 2,
          columnSpacing: 0,
          showCheckboxColumn: false,
          showBottomBorder: true,
          smRatio: 0.4,
          lmRatio: 2,
          columns: <DataColumn>[
            DataColumn2(
              label: const Center(child: Text("No")),
              size: ColumnSize.S,
              onSort: (_, __) {
                setState(() {
                  // widget.photos.sort((a, b) => a.data["quote"]["companyName"]
                  //     .compareTo(b.data["quote"]["companyName"]));
                });
              },
            ),
            DataColumn2(
              label: const Center(child: Text("CardNo")),
              size: ColumnSize.M,
              onSort: (_, __) {
                setState(() {
                  // widget.photos.sort((a, b) => a.data["quote"]["companyName"]
                  //     .compareTo(b.data["quote"]["companyName"]));
                });
              },
            ),
            DataColumn(
              label: const Center(child: Text("Name")),
              onSort: (_, __) {
                setState(() {
                  // widget.photos.sort((a, b) => a.data["quote"]["companyName"]
                  //     .compareTo(b.data["quote"]["companyName"]));
                });
              },
            ),
            DataColumn2(
              label: const Center(child: Text("CardPackage")),
              onSort: (_, __) {
                setState(() {
                  // widget.photos.sort((a, b) => a.data["stats"]["dividendYield"]
                  //     .compareTo(b.data["stats"]["dividendYield"]));
                });
              },
            ),
            DataColumn2(
              label: const Center(child: Text("Amount")),
              size: ColumnSize.M,
              onSort: (_, __) {
                setState(() {
                  // widget.photos.sort((a, b) => a.data["quote"]["companyName"]
                  //     .compareTo(b.data["quote"]["companyName"]));
                });
              },
            ),
            DataColumn(
              label: const Center(child: Text("Method")),
              onSort: (_, __) {
                setState(() {
                  // widget.photos.sort((a, b) => a.data["quote"]["iexBidPrice"]
                  //     .compareTo(b.data["quote"]["iexBidPrice"]));
                });
              },
            ),
            DataColumn(
              label: const Center(child: Text("LastMark")),
              onSort: (_, __) {
                setState(() {
                  // widget.photos.sort((a, b) => a.data["stats"]["latestPrice"]
                  //     .compareTo(b.data["stats"]["latestPrice"]));
                });
              },
            ),
            DataColumn(
              label: const Center(child: Text("TotalPaid")),
              onSort: (_, __) {
                setState(() {
                  // widget.photos.sort((a, b) => a.data["stats"]["latestPrice"]
                  //     .compareTo(b.data["stats"]["latestPrice"]));
                });
              },
            ),
          ],
          rows: payment
              .map((e) => DataRow(
              selected: e["Method"] == "pos",
              onSelectChanged: (val) {
                setState(() {
                  print("${e["Method"]}");
                });
              },
              cells: [
                DataCell(
                  Center(child: Text('${e["index"]}')),
                ),
                DataCell(
                    GestureDetector(
                      onDoubleTap: () {
                        print('onSubmited enabled');
                      },
                      child: Center(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          initialValue: MainClass.userFormat
                              .format(DateTime.parse("${e["Date"]}")),
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (val) {
                            print('onSubmited $val');
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabled: enabled,
                          ),
                        ),
                      ),
                    ),
                    showEditIcon: false),
                DataCell(
                  Center(child: Text('${e["Amount"]}')),
                ),
                DataCell(
                  Center(child: Text('${e["Method"]}')),
                ),
                DataCell(
                  Center(child: Text('${e["LastMark"]}')),
                ),
                DataCell(
                  Center(child: Text('${e["LastMark"]}')),
                ),
                DataCell(
                  Center(child: Text('${e["LastMark"]}')),
                ),
                DataCell(
                  Center(child: Text('${e["LastMark"]}')),
                ),
              ]))
              .toList()),
    );
  }
}
