import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Classes/MainClass.dart';
import '../Splash.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool test = true;
    TextStyle labelStyle = const TextStyle(fontSize: 15, letterSpacing: 0.0);
    TextStyle headerStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.purple[700],
        fontFamily: 'copper');
    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: Stack(
          children: [
            Positioned(
                child: Container(
                    color: Colors.grey[100],
                    width: screenSize.width * 0.41,
                    height: screenSize.height,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 32,
                            top: 6,
                            child: Text("Branch", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),)),

                        Positioned(
                          left:30,
                          top:5,
                          child:  Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButton(
                                hint: Text("Select Branch"),
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
                              SizedBox(width: screenSize.width * 0.06),
                              Stack(
                                children: [
                                  Text("Staff", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),),
                                  DropdownButton(
                                    hint: Text("Select Staff"),
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
                              SizedBox(width: screenSize.width * 0.06),
                              SizedBox(
                                width: 120,
                                height: 38,
                                child: Stack(
                                  children: [
                                    Text("Date", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),),
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
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          left:screenSize.width * 0.03,
                          top: screenSize.height * 0.15,
                          child:  Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               SizedBox(
                                height: 38,
                                width: screenSize.width * 0.15,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        prefixIcon: const Icon(Icons.credit_card_rounded),
                                        suffixIcon: !test ? Padding(
                                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
                                          child: Container( transform:Matrix4.translationValues(10, 0, 0), width: 10, height:10,child: CircularProgressIndicator(strokeWidth: 2.0 )),
                                        ) : Icon(Icons.check_circle,),
                                        hintText: "Enter Card No",
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        label: Text(
                                          "Card No"
                                          ,
                                          style:
                                          TextStyle(color: "cardPackage" == "Card No" ?const Color(0xFF21AC06) : const Color(0xFF083A09) ),
                                        ),
                                        border: const OutlineInputBorder())
                                ),
                              ),
                              SizedBox(width: 20,),
                              SizedBox(
                                height: 38,
                                width: screenSize.width * 0.12,
                                child: const TextField(
                                    textAlignVertical: TextAlignVertical.bottom,
                                    decoration: InputDecoration(
                                        // prefixIcon: const Icon(FontAwesomeIcons.moneyBill1Wave, size: 20,),
                                        prefixIcon: Icon(FontAwesomeIcons.moneyBillTrendUp, size: 20,),
                                        hintText: "Amount",
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        label: Text(
                                          "Cash",style:TextStyle(color: "cardPackage" == "Card No" ?Color(0xFF21AC06) : Color(0xFF083A09) ),
                                        ),
                                        border: OutlineInputBorder())
                                ),
                              ),
                              SizedBox(width: 20,),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Enter'),
                                style: ElevatedButton.styleFrom(

                                ),
                              ),
                              SizedBox(width: 20,),
                              Visibility(
                                visible: false,
                                child: SizedBox(
                                  width: 120,
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

                                          });
                                        },
                                        child: const Icon(Icons.calendar_month),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: false,
                                child: DropdownButton(
                                  hint: Text("Select Staff"),
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
                              ),


                            ],
                          ),
                        ),
                        Positioned(
                          left:10,
                          top:screenSize.height * 0.4,
                          bottom:screenSize.height * 0.055 ,
                          child:  Container(
                            width: screenSize.width * 0.4,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.black54,
                                    strokeAlign: BorderSide.strokeAlignInside)
                            ),

                            child: ListView(

                              children:List.generate(100, (index) => Container(
                                decoration: BoxDecoration(
                                  color: index.isEven?  const Color(0xFFFEEDFF) :
                                  const Color(0xFFF4D9F4),
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.black38,
                                      strokeAlign: BorderSide.strokeAlignInside),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${100 - index}. Entered N5,000 for Card:2304587450 ", style: TextStyle(letterSpacing: 0.3,)),
                                ),
                              ),),

                                ),
                          ),
                        ),


                        Positioned(
                          left:10,
                          top:screenSize.height * 0.3 ,
                          child:    Row(
                            children: [
                              Text("Total Money Recorded:",  style: headerStyle),
                              SizedBox(width: 50,),
                              Text("N25,500"),
                              SizedBox(width: 50,),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Finish'),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          left:10,
                          top:screenSize.height * 0.4 -20,
                          child:   Text(
                            "History",
                            style: headerStyle,
                          ),
                        ),

                        Positioned(
                          left:10,
                          bottom:screenSize.height * 0.01,
                          child:   ElevatedButton(
                            onPressed: () {},
                            child: Text('Clear History'),
                          ),
                        ),


                      ],
                    )
                    )),
            Positioned(
              left: screenSize.width * 0.45,
              child: Container(
                color: Colors.white54,
                width: screenSize.width * 0.5,
                height: screenSize.height - 50,
                child: Stack(
                  children: [
                    Positioned(
                      top:5,
                        child: Row(
                          children: [
                            Text("Card Number: " , style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "claredon",
                                color: Colors.purple),),
                            Text("2301456898", style: TextStyle(fontSize: 15,  fontWeight: FontWeight.bold,),),
                            SizedBox(width: screenSize.width * 0.06),
                            Text("Status:  ", style: TextStyle(
                                fontSize: 16,
                                fontFamily: "claredon",
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),),
                            Text("Active", style: TextStyle(
                                fontSize: 16,  fontWeight: FontWeight.bold, color: Colors.green[900]),),
                            SizedBox(width: screenSize.width * 0.06),
                            Text("Staff:  ", style: TextStyle(
                                fontSize: 16,
                                fontFamily: "claredon",
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),),
                            Text("Blessing", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[900]),),

                          ],

                    )),
                    Positioned(
                      top: 40,
                      child: Container(
                        width: screenSize.width * 0.1,
                        height: screenSize.width * 0.11,
                        decoration: BoxDecoration(
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
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: MainClass.getProfilePic(
                                    0, "cardNo", context),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 40,
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
                      top: screenSize.height * 0.16 +40,
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
                      left: screenSize.width * 0.25,
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
          ],
        ),
      ),
    );
  }

  Widget accountInformation(bool editable) {
    String name = "Chukwuedo James";
    String phone = "08142605775";
    String address = "CS 60 CornerStone Plaza, Alaba Int'l Market Ojo Lagos";
    String date = "11/10/2022";
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
                    setState(() {});
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
}
