import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gracedominion/Classes/MainClass.dart';
import 'package:gracedominion/Desktop/Splash.dart';
import 'package:window_manager/window_manager.dart';
import 'package:data_table_2/data_table_2.dart';

Color defaultColor = Colors.black45;
Map<String, int> tableColumns =  {};
class OperatorDashboard extends StatefulWidget {
  const OperatorDashboard({Key? key}) : super(key: key);

  @override
  State<OperatorDashboard> createState() => _OperatorDashboardState();
}
Color hoverColor = Colors.yellow;

class _OperatorDashboardState extends State<OperatorDashboard> {
  final cardTextController = TextEditingController();
  final amountController = TextEditingController();
  bool isTyping = false;
  bool isAmount = false;
  bool isButtonDisabled = true;

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
    tableColumns = {"James" :0,"Athena":1,"Juliet":2,"Esther":3,"Rachel":4,"Mike":5,"John":6};
    print(tableColumns);
    super.initState();
  }


  Color focusedColor = Colors.green;

  double navWidth = 70;
  double expWidth = 200;

  List<bool> isHover = List.generate(6, (index) => false);
  List<bool> selectColumns = List.generate(8, (index) => true);
  final cardController = TextEditingController();

   void changeState(){
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    setAvailableColumns();
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

      void _mystate(){
        setState(() {

        });
      }

    return Container(
      width: screenSize.width,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              color: Colors.white54,
              width: screenSize.width * 0.5,
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
                              text: ' ',
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Status:  ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "copper",
                                        color: Colors.purple)),
                                TextSpan(
                                    text: 'Active',
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
                                    text: 'Blessing',
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
                                onChanged: (card) async {
                                  cardNo = card.toUpperCase();
                                  cardController.value.text.isEmpty
                                      ? clearUI
                                      : setUI([]);
                                },
                                style: TextStyle(fontSize: 14),
                                controller: cardController,
                                decoration: const InputDecoration(
                                  label: Text(
                                    "Card Number",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        textBaseline: TextBaseline.alphabetic),
                                  ),labelStyle: TextStyle(fontSize: 12)
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: FaIcon( Icons.search,
                                size: 20,
                                color: isHover[4] ? Colors.purple : defaultColor = Colors.white),
                            onPressed: () {},
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
                              fixedSize: const Size(120, 38),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              backgroundColor: isHover[4] ? Colors.white : defaultColor = Colors.purple,
                            ),
                          ),


                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 3,
                            child: DropdownButton(
                              isExpanded: true,
                              value: "2314568798  Blessing",
                              items: [
                                "2314568798  Blessing",
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
                              child: accountInformation(true),
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
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Update Card'),
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
                                    "CONTRIBUTION",
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
                                  "250. FOODSTUFF STAGE 15",
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
                                    "250",
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
                                    "4 Months",
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
                              Flexible(
                                  flex: 10,
                                  child: Text(
                                    "Total Amount Payable:",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                  flex: 6,
                                  child: Text(
                                    "62,000",
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
                                  flex: 12,
                                  child: Text(
                                    "Total Amount Paid:",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 2, child: Container()),
                              Flexible(
                                  flex: 5,
                                  child: Text(
                                    "10,000",
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
                                  flex: 8,
                                  child: Text(
                                    "Last Mark:",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 2, child: Container()),
                              Flexible(
                                  flex: 5,
                                  child: Center(
                                      child: Text(
                                    "21/03/2023",
                                    style: labelStyle,
                                  ))),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 8,
                                  child: Text(
                                    "Balance: ",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 4, child: Container()),
                              Flexible(
                                  flex: 5,
                                  child: Text(
                                    "10,000",
                                    style: labelStyle,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 10,
                                  child: Text(
                                    "Last Audit: ",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 4, child: Container()),
                              Flexible(
                                  flex: 5,
                                  child: Text(
                                    "01/04/2023",
                                    style: labelStyle,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: screenSize.width * 0.17,
                              child: const GradientProgressBar(
                                  value: 0.5, height: 20)),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 10,
                                  child: Text(
                                    "Last Pay Date:",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 3, child: Container()),
                              Flexible(
                                  flex: 5,
                                  child: Text(
                                    "01/04/2023",
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
                                  flex: 9,
                                  child: Text(
                                    "Last Pay Amount:",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 2, child: Container()),
                              Flexible(
                                  flex: 6,
                                  child: Text(
                                    "6000",
                                    style: labelStyle,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 9,
                                  child: Text(
                                    "Last Cleared Date:",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 2, child: Container()),
                              Flexible(
                                  flex: 6,
                                  child: Text(
                                    " 14/01/2023",
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
                                  flex: 9,
                                  child: Text(
                                    "Start New:",
                                    style: labelStyle,
                                  )),
                              Flexible(flex: 2, child: Container()),
                              Flexible(
                                  flex: 6,
                                  child: Text(
                                    " 14/01/2023",
                                    style: labelStyle,
                                  )),
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
            left: screenSize.width * 0.50 + 5,
            child: Container(
              width: 200,
              height: 50,
              child: DropdownCheckbox(options: tableColumns, update: changeState,),
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
              left: screenSize.width * 0.5,
              top: 40,
              child: Container(
                  width: screenSize.width * 0.41,
                  height: screenSize.height - 150,
                  // child: bodyData2(screenSize)
                child:   TableClass(),


                  //
                  ))
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

  List<DataColumn> selectedColumns = [];
  List<DataColumn> availableColumns = [];
  List<DataCell>  availableCells = [];
  Widget bodyData3(List<Map<String, dynamic>> payment, Size size) {
    bool enabled = false;
    dataTableShowLogs = false;
    return Container(
      width: size.width * 0.45,
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
          columns: availableColumns,
          rows: payment
              .map((e) => DataRow(
                      selected: e["Method"] == "pos",
                      onSelectChanged: (val) {
                        setState(() {
                          print("${e["Method"]}");
                        });
                      },
                      cells: setAvailableCells(e)))
              .toList()),
    );
  }

  void setAvailableColumns(){
    print("Setting Available Columns");
    availableColumns = [];
    availableColumns.addAll(
    [
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
          label: const Center(child: Text("Date")),
          onSort: (_, __) {
            setState(() {
              // widget.photos.sort((a, b) => a.data["quote"]["companyName"]
              //     .compareTo(b.data["quote"]["companyName"]));
            });
          },
        ),
        DataColumn2(
          label: const Center(child: Text("Amount")),
          onSort: (_, __) {
            setState(() {
              // widget.photos.sort((a, b) => a.data["stats"]["dividendYield"]
              //     .compareTo(b.data["stats"]["dividendYield"]));
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
      ]
    );
  }
  List<DataCell> setAvailableCells(e){
    print("Setting Available Cells");
    availableCells = [];
     availableCells.addAll([
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
    ]);
     return availableCells;
  }

  void clearUI() {
    profile = const Image(
      image: AssetImage('assets/images/placeholder.jpg'),
      fit: BoxFit.cover,
    );
    isProfile = 0;
    // name = "";
    // phone = "";
    // address = "";
    // date = "";
    name = "Chukwuedo James";
    phone = "08142605775";
    address = "CS 60 CornerStone Plaza, Alaba Int'l Market Ojo Lagos";
    date = "11/10/2022";
    cardPackage = "Card No";

    lastMark = "";
    payAmount = 0;
    payDate = "";
    collectedBy = "";
    progress = 0.0;

    lastMark2 = "";
    payAmount2 = 0;
    payDate2 = "";
    collectedBy2 = "";
  }

  void setUI(List<String> data) {
    // Name,Address,Phone,DateOfReg,LastMark,LastPayAmount,LastPayDate,CollectedBy,CardPackage,TotalAmtPayable,TotalAmtPaid, Photo,
    if (data.isNotEmpty) {
      isProfile = int.parse(data[12]);
      profile = isProfile > 0
          ? const Image(
              image: AssetImage('assets/images/profile.jpg'),
              fit: BoxFit.cover,
            )
          : const Image(
              image: AssetImage('assets/images/placeholder.jpg'),
              fit: BoxFit.cover,
            );

      name = data[0];
      address = data[1];
      phone = data[2];
      date = data[3];

      //Payment Information Variables
      lastMark = data[4];
      payAmount = int.parse(data[5]);
      try {
        payDate = MainClass.userFormat.format(DateTime.parse(data[6]));
      } catch (e) {
        payDate = (data[6]);
      }

      collectedBy = data[7];
      cardPackage = data[8];
      totalAmtPayable = int.parse(data[10]);
      totalAmtPaid = int.parse(data[11]);
      rate = int.parse(data[13]);

      progress = totalAmtPaid / totalAmtPayable;
      progress = progress > 1
          ? 0
          : totalAmtPayable == totalAmtPaid
              ? 1
              : progress;
      //Update Payment Information Variables
      payAmount2 = _amount;
      payDate2 = MainClass.userFormat.format(DateTime.now());
      collectedBy2 = MainClass.staff;
    } else {
      clearUI();
    }
    setState(() {});
  }

  Widget accountInformation(bool editable) {
    if (!editable) {
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
            MainClass.returnTitleCase(name),
            style: TextStyle(color: Colors.purple[900]),
          ),
          Text(
            phone,
            style: const TextStyle(color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  MainClass.returnTitleCase(address),
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )),
          ),
          Text(
            date,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      );
    }
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
   void setAvailableColumns(){
     print("Setting Available Columns");
     availableColumns = [];
     // tableColumns.forEach((element) {
     //   availableColumns.add(
     //       DataColumn2(
     //         label:  Center(child: Text(element)),
     //         size: ColumnSize.M,
     //         onSort: (_, __) {
     //         },
     //       )
     //   );
     // });

   }

  @override
  Widget build(BuildContext context) {
    print("Undisturbed is built");
    setAvailableColumns();
    return FutureBuilder(
      future: TableClass.loadPayment("card"),
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
                    child: bodyData3(snapshot.data!)),
              )
            ],
          );
        }
      },
    );
  }

  List<DataColumn> selectedColumns = [];

  List<DataColumn> availableColumns = [];

  List<DataCell>  availableCells = [];

  Widget bodyData3(List<Map<String, dynamic>> payment) {
    bool enabled = false;
    dataTableShowLogs = false;
    return Container(
      width: 600,
      child: DataTable2(
          sortColumnIndex: 0,
          sortAscending: true,
          headingTextStyle:  TextStyle(backgroundColor: hoverColor),
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
              selected: e["Method"] == "pos",
              onSelectChanged: (val) {

              },
              cells: setAvailableCells(e)))
              .toList()),
    );
  }

   List<DataCell> setAvailableCells(e){
     print("Setting Available Cells");
     availableCells = [];

     // tableColumns.forEach((element) {
     //   availableCells.add(
     //     DataCell(
     //       Center(child: Text('${e["Method"]}')),
     //     ),
     //   );
     // });


     return availableCells;
   }
}
class CheckboxWithLabel extends StatefulWidget {
  final String label;
  final Function(bool isChecked) onChanged;
  final List<String> selected;

  CheckboxWithLabel({
    required this.label,
    required this.onChanged,
    required this.selected
  });

  @override
  _CheckboxWithLabelState createState() => _CheckboxWithLabelState();
}

class _CheckboxWithLabelState extends State<CheckboxWithLabel> {
  bool _isChecked = true;
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
        children: [
          Text(widget.label),
          Checkbox(
            value: widget.selected.contains(widget.label),
            onChanged: (bool? value) {
              setState(() {
                switch(widget.label){
                  case "James":
                    hoverColor  = Colors.green;

                    break;
                  case "Athena":
                    hoverColor  = Colors.yellow;
                    break;
                  case "Esther":
                    hoverColor  = Colors.blue;
                    break;
                  case "Mike":
                    hoverColor  = Colors.purple;
                    break;
                }
               if(value!){
                 // tableColumns.insert(1, widget.label);
               }else{
                 tableColumns.remove(widget.label);
               }
                _isChecked = value!;
                widget.onChanged(_isChecked);
              });
            },
          ),

        ],
      ),
    );
  }
}
class DropdownCheckbox extends StatefulWidget {
  final Map<String, int> options;
  final Function update;

  DropdownCheckbox({required this.options, required this.update});

  @override
  _DropdownCheckboxState createState() => _DropdownCheckboxState();
}

List<String> _selectedItems2 = tableColumns.keys.toList();
// ["James","Athena","Juliet","Esther","Rachel","Mike","Johnn"]
String? sec;
class _DropdownCheckboxState extends State<DropdownCheckbox> {
  late final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DropdownButtonFormField<String>(
          //   key: _key,
          //   hint: const Text("Select Columns"),
          //   // value: sec,
          //   items: widget.options.keys.((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: CheckboxWithLabel(
          //         label: value,
          //         onChanged: (bool isChecked) {
          //           setState(() {
          //             if (isChecked) {
          //               _selectedItems2.add(value);
          //             } else {
          //               _selectedItems2.remove(value);
          //             }
          //             widget.update.call();
          //             _key.currentState?.reset();
          //           });
          //         },
          //         selected:   _selectedItems2,
          //       ),
          //     );
          //   }).toList(),
          //   onChanged: (String? newValue) {
          //     // do something with selected value
          //   },
          // ),
        ],
      ),
    );
  }
}

