
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Interface/NewStock.dart';
import 'package:gracedominion/Interface/Product.dart';
import 'package:intl/intl.dart';
import '../AppRoutes.dart';
import '../Classes/LogicClass.dart';
import '../Classes/TableClass.dart';
import '../Desktop/WidgetClass.dart';
import 'MainInterface.dart';


final dateFormat = DateFormat('dd-MM-yyyy');
Size? screenSize;


class InventoryPage extends StatefulWidget {
   final Function() myFunction;
  
  const InventoryPage({Key? key, required this.myFunction}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool isTyping = false;
  final searchController = TextEditingController();
  String cardLabel = "Search Inventory";
  // List<String> locations = [];
  String? selectedLocation;
  Color labelColor = mainColor;
  bool isSearching = false;
  bool reload = false;



  void changeActivePage(){
    widget.myFunction.call();
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: MyFloatingActionButton(
        text: 'Add New Product',
        onPressed: () async {
          pageLoading = true;
          changeActivePage();
          activePage = "Product";
          var productID = await FirebaseClass.getNewProductID();
          page =  ProductPage(data: {"Name":"", "Model":"", "Category":"", "Quantity":"0", "Comment":"", "ProductID":productID});
          pageLoading = false;
          changeActivePage();
        },
      ),
      body:  Stack(
        children: [
          Positioned(
            left:10,
            top: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  height: 100,
                  width: screenSize!.width * 0.35,
                  child: TextField(
                    onSubmitted: (query) async {
                      reload = searchController.text.isEmpty;
                      setState(() {});
                      // searchQuery = query.toUpperCase();
                      // isSearching = false;
                      // setState(() {});
                    },
                    style: const TextStyle(fontSize: 14),
                    controller: searchController,
                    decoration:  InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: labelColor, width: 2.0),
                        ),
                        suffixIcon: isSearching? Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                          child: Container( transform:Matrix4.translationValues(10, 5, 0), width: 10, height:10,child:  CircularProgressIndicator(strokeWidth: 2.0, color: mainColor, )),
                        ): const SizedBox(),
                        label: Text(
                          cardLabel,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              textBaseline: TextBaseline.alphabetic),
                        ),labelStyle: TextStyle(fontSize: 14, color: labelColor)
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Container(
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: MyCustomButton(
                    text: "Search",
                    onPressed: (){
                      reload = searchController.text.isEmpty;
                      setState(() {});
                    },
                    icon: Icons.search,
                    size: const Size(130, 38)
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            right: screenSize!.width * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Location", style: TextStyle(fontSize: 11),),
                Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  child: DropdownButton(
                      isExpanded: false,
                      dropdownColor: mainColor.withOpacity(0.9),
                      style: const TextStyle(color: Colors.white),
                      selectedItemBuilder: (BuildContext context) {
                        return locations.map((String value) {
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
                      value: selectedLocation ?? locations[0],
                      items: locations.map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                          .toList(),
                      onChanged: (string) {
                        selectedLocation = string!;
                        setState(() {});
                      }),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
              right:  screenSize!.width * 0.03,
            child: MyCustomButton(
              text: "New Stock",
              onPressed: () async{
                pageLoading = true;
                changeActivePage();
                activePage = "Add New Stock";
                page =  const NewStockPage();
                pageLoading = false;
                changeActivePage();
                // Navigator.pushReplacementNamed(context, AppRoutes.login);

              },
              icon: Icons.list_alt_rounded,
              size: const Size(130, 38)
            ),
          ),
          Positioned(
            top:50,
            child: SizedBox(
              height: screenSize!.height * 0.87 + 20,
                width: screenSize!.width * 0.87,
                child:  TableClass(
                    tableColumns: const {"No" :ColumnSize.S,"Image":ColumnSize.S,"Name":ColumnSize.L,"Model":ColumnSize.S,"Category":ColumnSize.M,"Quantity":ColumnSize.M,"Comment":ColumnSize.S},
                    tableName: "Inventory",
                    myFunction: changeActivePage,
                    searchQuery:  {"Search": searchController.text.toUpperCase(), "Reload":reload, "SelectedLocation":selectedLocation?? locations[0]},
                ),



            )
              // child:  LazyLoadDataTableExample())
            ,
          )
        ],
      )
      ,
    );
  }



}
