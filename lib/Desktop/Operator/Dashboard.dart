import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Classes/MainClass.dart';
import 'package:gracedominion/Desktop/Splash.dart';
import 'package:gracedominion/Desktop/WidgetClass.dart';
import 'package:window_manager/window_manager.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

Color defaultColor = Colors.black45;
final dateFormat = DateFormat('dd-MM-yyyy');
Map<String, int> tableColumns =  {};

Map<String, int> tableColumnsCopy =   {"No" :0,"Date":1,"Amount":2,"Method":3,"LastMark":4,"TotalPaid":5,"CollectedBy":6,"RegisteredBy":7,"Verified":8};

List<String> tableColumns2  = const ["No","Date","Amount","Method","LastMark","TotalPaid","CollectedBy","RegisteredBy","Verified"];

class OperatorDashboard extends StatefulWidget {
  const OperatorDashboard({Key? key}) : super(key: key);

  @override
  State<OperatorDashboard> createState() => _OperatorDashboardState();
}

Color hoverColor = Colors.yellow;

class _OperatorDashboardState extends State<OperatorDashboard> {
  final cardTextController = TextEditingController();
  bool isTyping = false;
  bool isAmount = false;
  bool isButtonDisabled = true;
  bool isUpdating = false;
  bool searchView = false;

  //Customer Information Variables
  Image profile = const Image(
    image: AssetImage('assets/images/placeholder.jpg'),
    fit: BoxFit.cover,
  );
  int isProfile = 1;
  String name = "Chukwuedo James";
  String phone = "08142605775";
  String address = "CS 60 CornerStone Plaza, Alaba Int'l Market Ojo Lagos";
  String date = "11/10/2022";
  String status = "Active";

  //Payment Information Variables
  String cardPackage = "Card No";

  int rate = 200;

  String lastMark = "21/7/2022";

  int payAmount = 5000;

  int totalAmtPayable = 5000;

  int totalAmtPaid = 5000;

  String payDate = "21/7/2022";

  String collectedBy = "Richard";

  double progress = 0.7;

  //Update Payment Information Variables
  String lastMark2 = "21/7/2022";

  int payAmount2 = 5000;

  String payDate2 = "21/7/2022";

  String collectedBy2 = "James";

  TextStyle payStyle2 =
      const TextStyle(fontWeight: FontWeight.w400, color: Colors.green);

  //Card Variables
  String cardNo = "";
  int _amount = 0;

  @override
  void initState() {
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
    tableColumns = {"No" :0,"Date":1,"Amount":2,"Method":3,"LastMark":4,"TotalPaid":5};
    super.initState();
  }


  Color focusedColor = Colors.green;


  List<bool> isHover = List.generate(6, (index) => false);
  List<bool> selectColumns = List.generate(8, (index) => true);

  final cardController = TextEditingController();
  String cardLabel = "Card Number";
  Color labelColor = Colors.purple;
  bool isSearching = false;

  void changeState(){ setState(() {}); }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width - 125),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                      color: const Color(0xFFEFEFEF),
                      child: activePage2(context),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget activePage2(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    TextStyle labelStyle = const TextStyle(fontSize: 15, letterSpacing: 0.0);
    TextStyle headerStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.purple[700],
        fontFamily: 'copper');

    return Container(
      width: screenSize.width,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              color: Colors.white54,
              width: screenSize.width * 0.48,
              height: screenSize.height - 50,
              child: Stack(
                children: [
                  Positioned(
                    top: 3,
                    left: 4,
                    child: Container(
                      width: screenSize.width * 0.1,
                      height: screenSize.width * 0.11,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: Colors.black12,
                            strokeAlign: BorderSide.strokeAlignOutside),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: Colors.grey,
                                    strokeAlign: BorderSide.strokeAlignOutside),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child:
                                  MainClass.getProfilePic(0, cardNo, context),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Status:  ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "copper",
                                        color: Colors.purple)),
                                TextSpan(
                                    text: CustomerInformation.data["Status"],
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "claredon",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900])),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: ' ',
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Staff:  ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "copper",
                                        color: Colors.purple)),
                                TextSpan(
                                    text: CustomerInformation.data["StaffReg"],
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "claredon",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenSize.width * 0.1,
                    child: Container(
                      width: (screenSize.width * 0.5 - screenSize.width * 0.1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              transform: Matrix4.translationValues(0, -10, 0),
                              child: TextField(
                                onSubmitted: (query){
                                  searchFunction(query);
                                },
                                onChanged: (card) async {
                                  if(cardController.value.text.length == 10 ){
                                    isSearching = true;
                                    searchView = false;
                                    setState(() {});
                                  }
                                  if(cardController.value.text.length == 10 ){
                                    CustomerInformation.data = await MainClass.loadCustomerInfo(card);
                                    isSearching = false;
                                    if(CustomerInformation.data.containsKey("error")){
                                      var err = CustomerInformation.data.putIfAbsent("error", () => null);
                                      switch(err.code.toString()){
                                        case "5":
                                          cardLabel = "Card Not Found";
                                          labelColor = const Color(0xff9b0101);
                                          break;
                                        case "14":
                                          cardLabel = "No Internet Connection";
                                          labelColor = const Color(0xffd73d0a);
                                          break;
                                        case "2":
                                          cardLabel = "Slow Connection, retry";
                                          labelColor =  const Color(0xffde4e1b);
                                          break;
                                      }
                                      CustomerInformation.data = CustomerInformation.defaultData;
                                    }else{
                                      if(CustomerInformation.data.isEmpty){
                                        CustomerInformation.data = CustomerInformation.defaultData;
                                        cardLabel = "Card Number";
                                        labelColor = Colors.purple;
                                      }else{
                                        cardLabel = "Card Number";
                                        labelColor =  const Color(0xff258203);
                                      }
                                    }
                                  } else{
                                    cardLabel = "Card Number";
                                    labelColor = Colors.purple;
                                    CustomerInformation.data = CustomerInformation.defaultData;
                                  }
                                  if(cardController.value.text.length > 10 ){
                                    cardLabel = "Search Query";
                                  }
                                  setState(() {
                                    
                                  });
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
                          ),
                          ElevatedButton.icon(
                            icon: FaIcon( Icons.search,
                                size: 20,
                                color: isHover[4] ? Colors.purple : defaultColor = Colors.white),
                            onPressed: () {
                              searchFunction( cardController.text);
                            },
                            onHover: (state) {
                              isHover[4] = state;
                              setState(() {});
                            },
                            label: Text(
                              "Search",
                              style: TextStyle(
                                  color: isHover[4] ? Colors.purple : defaultColor = Colors.white,
                                  fontSize: 13),
                            ),
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              fixedSize: const Size(100, 38),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              backgroundColor: isHover[4] ? Colors.white : defaultColor = Colors.purple,
                            ),
                          ),


                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 3,
                            child: searchCombo(comboData.isNotEmpty? "Search Result": "No Result", comboData.keys.toList()),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: screenSize.width * 0.1,
                    child: Container(
                      width: screenSize.width * 0.25,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: SizedBox(
                              height: screenSize.width * 0.11 - 50,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.account_circle,
                                    color: Colors.purple,
                                    size: 18,
                                  ),
                                  Icon(
                                    Icons.phone,
                                    color: Colors.purple,
                                    size: 18,
                                  ),
                                  Icon(
                                    Icons.location_on_sharp,
                                    color: Colors.purple,
                                    size: 18,
                                  ),
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.purple,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: screenSize.width * 0.11 - 50,
                              child: accountInformation(isUpdating),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenSize.height * 0.222,
                    left: screenSize.width * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Visibility(
                        visible: CustomerInformation.data["Name"] != "" || cardLabel == "Card Not Found",
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(cardLabel == "Card Number"? "Update Card":"Add Card"),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenSize.height * 0.35,
                    left: screenSize.width * 0.28,
                    child: Container(
                      width: screenSize.width * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CARD INFORMATION",
                            style: headerStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 8,
                                  child: Text(
                                    "CardType:",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                  flex: 14,
                                  child: Text(
                                    CustomerInformation.data["CardType"],
                                    style: labelStyle,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  "Package: ",
                                  style: labelStyle,
                                ),
                              ),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                flex: 13,
                                child: Text(
                                  CustomerInformation.data["CardPackage"],
                                  style: labelStyle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 3,
                                  child: Text(
                                    "Amount: ",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                  flex: 13,
                                  child: Text(
                                    CustomerInformation.data["Amount"].toString(),
                                    style: labelStyle,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 3,
                                  child: Text(
                                    "Period: ",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                  flex: 8,
                                  child: Text(
                                    CustomerInformation.data["Period"],
                                    style: labelStyle,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenSize.height * 0.35,
                    left: 20,
                    child: Container(
                      width: screenSize.width * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PAYMENT INFORMATION",
                            style: headerStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Total Amount Payable:",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Text(
                                CustomerInformation.data["TotalAmtPayable"].toString(),
                                style: labelStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Total Amount Paid:",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Text(
                                CustomerInformation.data["TotalAmtPaid"].toString(),
                                style: labelStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Last Mark:",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Center(
                                  child: Text(
                                    CustomerInformation.data["LastMark"],
                                style: labelStyle,
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Balance: ",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Text(
                                CustomerInformation.data["TotalBalRem"].toString(),
                                style: labelStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              width: screenSize.width * 0.17,
                              child:  GradientProgressBar(
                                  value:  CustomerInformation.data["Percentage"], height: 20)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenSize.height * 0.62,
                    left: 20,
                    child: Container(
                      width: screenSize.width * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "OTHER INFORMATION",
                            style: headerStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Last Pay Amount:",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Text(
                                CustomerInformation.data["LastPayAmt"].toString(),
                                style: labelStyle,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Last Pay Date:",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Text(

                                CustomerInformation.data["LastDate"] == ""? "":
                                dateFormat.format(CustomerInformation.data["LastDate"]),
                                style: labelStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Last Audit: ",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Text(

                                CustomerInformation.data["LastAudit"] == ""? "":
                                dateFormat.format(CustomerInformation.data["LastAudit"]),
                                style: labelStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Last Cleared Date:",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Text(
                                CustomerInformation.data["LastClearedDate"] == ""? "":
                                dateFormat.format(CustomerInformation.data["LastClearedDate"]),
                                style: labelStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.11,
                                child: Text(
                                  "Start Date:",
                                  style: labelStyle,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.02,
                              ),
                              Text(

                                CustomerInformation.data["StartDate"] == ""? "":
                                dateFormat.format(CustomerInformation.data["StartDate"]),
                                style: labelStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: screenSize.width * 0.49,
            child: Container(
              width: 200,
              height: 50,
              child: DropdownCheckbox(options: tableColumns2, update: changeState,),
            ),
          ),
          Positioned(
            right: screenSize.width * 0.02 + 20,
            top: 5,
            child: customButton(
                isHover[5], "Clear Card", FontAwesomeIcons.broom, (state) {
              isHover[5] = state;
              setState(() {});
            }, const Size(120, 35)),
          ),
          Positioned(
              left: screenSize.width * 0.48,
              top: 40,
              child: SizedBox(
                  width: screenSize.width * 0.44,
                  height: screenSize.height - 150,
                child: TableClass(),


                  //
                  ))
        ],
      ),
    );
  }
  static Map<String, Map<String, dynamic>> comboData = {};

  void searchFunction(String query) async{
     isSearching = true;
     print("Query $query");
     setState(() {});
     comboData = await MainClass.searchCustomerInfo(query.toLowerCase());
     isSearching = false;
     searchView = true;

     setState(() {});

   }

  Widget searchCombo(String hint, List<String> items){
     return Visibility(
       visible: searchView,
       child: DropdownButton(
         isExpanded: false,
         hint: Text(hint),
         value: null,
         items: items.map((item) => DropdownMenuItem<String>(
           value: item,
           child: Text(item),
         ))
             .toList(),
         onChanged: (string) {
           print("string $string");
           CustomerInformation.data = comboData[string]!;
           cardController.text =  CustomerInformation.data["CardNo"];
           cardLabel = "Card Number";
           setState(() {});
         },
       ),
     );
  }


  static String lastCard = "";

  List<DataColumn> selectedColumns = [];
  List<DataColumn> availableColumns = [];
  List<DataCell>  availableCells = [];



  Widget accountInformation(bool editable) {
    if (editable) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 18,
            child: TextField(),
          ),
          const SizedBox(
            height: 18,
            child: TextField(),
          ),
          const SizedBox(
            height: 18,
            child: TextField(),
          ),
          SizedBox(
            height: 30,
            child: TextField(
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
                      isButtonDisabled = true;
                    });
                  },
                  child: const Icon(Icons.calendar_month),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MainClass.returnTitleCase(stringify(CustomerInformation.data["Name"])),
            style: TextStyle(color: Colors.purple[900]),
          ),
          Text(
            CustomerInformation.data["Phone"],
            style: const TextStyle(color: Colors.black),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                MainClass.returnTitleCase( stringify(CustomerInformation.data["Address"])),
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
          Text(
            CustomerInformation.data["DateOfReg"] == ""? "":
            dateFormat.format(CustomerInformation.data["DateOfReg"]),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      );
    }
  }

  String stringify(dynamic data){
    String string = data.toString();
    return string;
  }

  Widget customButton(
      bool isHover, String text, IconData icon, Function(bool)? onHover,
      [Size size = const Size(150, 50),]) {
    return ElevatedButton.icon(
      icon: FaIcon(icon,
          size: 20,
          color: isHover ? Colors.purple : defaultColor = Colors.white),
      onPressed: () {},
      onHover: onHover,
      label: Text(
        text,
        style: TextStyle(
            color: isHover ? Colors.purple : defaultColor = Colors.white,
            fontSize: 13),
      ),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        fixedSize: size,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        backgroundColor: isHover ? Colors.white : defaultColor = Colors.purple,
      ),
    );
  }
}

class TableClass extends StatefulWidget {
  const TableClass({super.key});

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
    return returnData;
  }

  @override
  State<TableClass> createState() => _TableClassState();
}

class _TableClassState extends State<TableClass> {

   List<DataColumn> selectedColumns = [];

   List<DataColumn> availableColumns = [];

   List<DataCell>  availableCells = [];

   late Future<List<Map<String, dynamic>>> futureData;

   List<bool> editable = [];

   @override
   void initState() {
     futureData = TableClass.loadPayment("card");
     futureData.then((value) => {
       editable = List.generate(value.length, (index) => false)
     });
    super.initState();
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
          print("Operator Data............ ");
          editable = List.generate(snapshot.data!.length, (index) => false);
          print(editable);
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
    bool enabled = false;
    dataTableShowLogs = false;

    return SizedBox(
      width: size.width * 0.45,
      child: DataTable2(
          headingTextStyle:  const TextStyle(backgroundColor: Colors.purple),
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
          columns: availableColumns,
          rows: payment
              .map((e) => DataRow(
              cells: setAvailableCells(e)))
              .toList()),
    );
  }

   void setAvailableColumns(){
     availableColumns = [];
     var mapEntries = tableColumns.entries.toList()
       ..sort((a, b) => a.value.compareTo(b.value));
     tableColumns
       ..clear()
       ..addEntries(mapEntries);

     for (var element in tableColumns.keys) {
       availableColumns.add(
           DataColumn2(
             label:  Center(child: Text(element)),
             size: element == "No"? ColumnSize.S : ColumnSize.M,
             onSort: (_, __) {
             },
           )
       );
     }

   }
   List<DataCell> setAvailableCells(e){
     print("Setting Available Cells");
     availableCells = [];
     for (var element in tableColumns.keys) {
       switch(element){
         case "No": element = "index";
         break;
         case "TotalPaid": element = "Total";
         break;
         case "CollectedBy": element = "Staff";
         break;

       }

       bool x =false;


       availableCells.add(
         element == "Amount"?  DataCell(
             StatefulBuilder(builder: (context, setState){
               return GestureDetector(
                 onDoubleTap: () {
                   print('onSubmited enabled');
                   editable[int.parse("${e["index"]}") -1] = !editable[int.parse("${e["index"]}") -1];
                   print( editable[int.parse("${e["index"]}") -1]);
                   setState((){});
                 },
                 child: Center(
                   child: TextFormField(

                     enabled: editable[int.parse("${e["index"]}") -1],
                     autofocus: true,
                     textAlign: TextAlign.center,
                     initialValue: "${e["Amount"]}",
                     keyboardType: TextInputType.text,
                     textAlignVertical: editable[int.parse("${e["index"]}") -1] ? TextAlignVertical.center : TextAlignVertical.top,

                     onFieldSubmitted: (val) {
                       print('onSubmited $val');
                       editable[int.parse("${e["index"]}") -1] = false;
                       setState((){});
                     },
                     decoration: InputDecoration(
                       border: InputBorder.none,
                           prefixIcon: editable[int.parse("${e["index"]}") -1] ? const Icon(Icons.edit, size: 15,) : null,
                         suffixIcon: editable[int.parse("${e["index"]}") -1] ? const Icon(Icons.delete_forever, color: Color(0xffaa0000), size: 18,) : null,
                         enabledBorder: const OutlineInputBorder(
                           gapPadding: 1.0,
                           borderSide: BorderSide(color: Colors.purpleAccent, width: 1.0),
                         ),
                         contentPadding: EdgeInsets.zero,
                         focusedBorder: const UnderlineInputBorder(
                           borderSide: BorderSide(color: Colors.purple, width: 1.0),
                         )

                     ),
                   ),
                 ),
               );}
             ),
             showEditIcon: editable[int.parse("${e["index"]}") -1]):
         element == "Method"?
         DataCell(
             StatefulBuilder(builder: (context, setState){
               return GestureDetector(
                 onDoubleTap: () {
                   print('onSubmited enabled');
                   editable[int.parse("${e["index"]}") -1] = !editable[int.parse("${e["index"]}") -1];
                   setState((){});
                 },
                 child: Center(
                   child: editable[int.parse("${e["index"]}") -1] ? DropdownButton(
                     isExpanded: false,
                     value: "${e["Method"]}",
                     items: [
                       "Cash",
                       "Transfer",
                     ].map((item) => DropdownMenuItem<String>(
                       value: item,
                       child: Text(item),
                     ))
                         .toList(),
                     onChanged: (string) {
                       print("string $string");
                       editable[int.parse("${e["index"]}") -1] = false;
                       setState((){});
                     },
                     // onChanged: null,
                   ) : Text('${e[element]}'),
                 ),
               );}
             ),
             showEditIcon: false):
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
}

class CheckboxWithLabel extends StatefulWidget {
  final String label;
  final Function(bool isChecked) onChanged;
  final List<String> selected;

  const CheckboxWithLabel({super.key,
    required this.label,
    required this.onChanged,
    required this.selected
  });

  @override
  CheckboxWithLabelState createState() => CheckboxWithLabelState();
}

class CheckboxWithLabelState extends State<CheckboxWithLabel> {
  bool _isChecked = true;
  int getPosition(columnName){
    int position = 0;
    switch(columnName){
      case "No": position = 0;
      break;
      case "Date": position = 1;
      break;
      case "Amount": position = 2;
      break;
      case "Method": position = 3;
      break;
      case "LastMark": position = 4;
      break;
      case "TotalPaid": position = 5;
      break;
      case "CollectedBy": position = 5;
      break;
      case "RegisteredBy": position = 6;
      break;
      case "Verified": position = 7;
      break;
    }
    return position;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
          widget.onChanged(_isChecked);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.label),
          Checkbox(
            value: widget.selected.contains(widget.label),
            onChanged: (bool? value) {
              setState(() {
                Map<String, int> tableColumnsTemp = tableColumns;
               if(value!){
                 tableColumnsTemp.putIfAbsent(widget.label, () => getPosition(widget.label));
                tableColumns = tableColumnsTemp;
               }else{
                 tableColumns.remove(widget.label);
               }
                _isChecked = value;
                widget.onChanged(_isChecked);
              });
            },
          ),
        ],
      ),
    );
  }
}

List<String> _selectedItems2 =  tableColumns.keys.toList();
class DropdownCheckbox extends StatefulWidget {
  final List<String> options;
  final Function update;

  const DropdownCheckbox({super.key, required this.options, required this.update});

  @override
  DropdownCheckboxState createState() => DropdownCheckboxState();
}

class DropdownCheckboxState extends State<DropdownCheckbox> {
  late final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            key: _key,
            hint: const Text("Select Columns"),
            items: widget.options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CheckboxWithLabel(
                  label: value,
                  onChanged: (bool isChecked) {
                    setState(() {
                      isChecked? _selectedItems2.add(value): _selectedItems2.remove(value);
                      widget.update.call();
                      _key.currentState?.reset();
                    });
                  },
                  selected:  _selectedItems2,
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // do something with selected value
            },
          ),
        ],
      ),
    );
  }
}

