
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Classes/LogicClass.dart';
import '../Classes/TableClass.dart';
import '../Desktop/WidgetClass.dart';
import 'MainInterface.dart';
import 'Profile.dart';



Size? screenSize;
final dateFormat = DateFormat('dd-MM-yyyy');
class CustomersPage extends StatefulWidget {
  final Function() myFunction;
  const CustomersPage({Key? key, required this.myFunction}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final cardController = TextEditingController();
  Color labelColor = WidgetClass.mainColor;
  bool isSearching = false;
  String filter = "All";
  bool reload = false;

  void changeActivePage(){
    widget.myFunction.call();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      floatingActionButton: MyFloatingActionButton(
        text: 'Add New Customer',
        onPressed: () async {
          pageLoading = true;
          changeActivePage();
          activePage = "Profile";
          var customerID = await FirebaseClass.getNewCustomerID();
          page =  Profile(data: {"Name":"", "Phone":"", "Address":"", "Balance":"0", "Comment":"", "CustomerID":customerID});
          pageLoading = false;
          changeActivePage();

        },
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
                      reload = cardController.text.isEmpty;
                      setState(() {});
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
                        label: const Text(
                          "Search Customer",
                          textAlign: TextAlign.right,
                          style: TextStyle(
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
            child: Center(
              child: SizedBox(
                  height: screenSize!.height * 0.87 + 20,
                  width: screenSize!.width * 0.87,
                  child:  TableClass(
                    tableColumns: const {"No" :ColumnSize.S,"Name":ColumnSize.M,"Phone":ColumnSize.S,"Address":ColumnSize.M,"LastOrder":ColumnSize.S,"TotalOrders":ColumnSize.S,"OrdersAmount":ColumnSize.S,"Balance":ColumnSize.S},
                    tableName: "Customers",
                    myFunction: changeActivePage,
                    searchQuery:  {"Search": cardController.text.toUpperCase(), "Reload":reload},
                  )),
            ),
          ),
          Positioned(
            right: screenSize!.width * 0.07,
            child: DropdownButton(
                isExpanded: false,
                dropdownColor: mainColor.withOpacity(0.9),
                style: const TextStyle(color: Colors.white),
                selectedItemBuilder: (BuildContext context) {
                  return ["All", "Debtors", "Creditors"].map((String value) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList();
                },
                underline: Container(
                  height: 1,
                  color: mainColor,
                ),
                value: filter,
                items: ["All", "Debtors", "Creditors"]
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
                    .toList(),
                onChanged: (string) {
                  filter = string!;
                  setState(() {});
                }),
          ),
        ],
      )
      ,
    );
  }


}

