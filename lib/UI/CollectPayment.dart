import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../Classes/MainClass.dart';
import '../Controller/CollectPaymentController.dart';

class CollectPayment extends StatefulWidget {
  const CollectPayment({Key? key}) : super(key: key);

  @override
  State<CollectPayment> createState() => _CollectPaymentState();
}

class _CollectPaymentState extends State<CollectPayment> {
  final cardTextController = TextEditingController();
  final amountController = TextEditingController();
  bool isTyping = false;
  bool isAmount = false;
  bool isButtonDisabled = true;

  //Customer Information Variables
  Image profile = const Image(image: AssetImage('assets/images/placeholder.jpg'), fit: BoxFit.cover,);
  int isProfile = 1;
  String name = "Chukwuedo James";
  String phone = "08142605775";
  String address = "CS 60 CornerStone Plaza, Alaba Int'l Market Ojo Lagos";
  String date = "11/10/2022";

  //Payment Information Variables
  String cardPackage = "Card No"  ;
  int rate = 200  ;
  String lastMark = "21/7/2022"  ;
  int payAmount= 5000  ;
  int totalAmtPayable= 5000  ;
  int totalAmtPaid= 5000  ;
  String payDate= "21/7/2022"  ;
  String collectedBy= "Richard"  ;
  double progress= 0.7 ;

  //Update Payment Information Variables
  String lastMark2 = "21/7/2022"  ;
  int payAmount2= 5000  ;
  String payDate2= "21/7/2022"  ;
  String collectedBy2= "James"  ;
  TextStyle payStyle2 = const TextStyle(fontWeight: FontWeight.w400, color: Colors.green);

  //Card Variables
  String cardNo = "";
  int _amount = 0;

  XFile? imageFile;

  @override
  Widget build(BuildContext context) {

    cardTextController.value.text.isEmpty? isTyping = false  : MediaQuery.of(context).viewInsets.bottom > 0.0 ? isTyping = false: isTyping = true;
    amountController.value.text.isEmpty ? isAmount = false : isAmount = true;
    amountController.value.text.isEmpty ||  cardTextController.value.text.isEmpty? isButtonDisabled = true: isButtonDisabled = false;
    cardPackage == "Card No" ? isButtonDisabled = true: isButtonDisabled = false;

    Size screenSize = MediaQuery.of(context).size;
    TextStyle textStyle1 = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                height: screenSize.height / 2.2,
                decoration:  const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/backgrounds/greenDark.jpg'),
                        fit: BoxFit.fill,
                        opacity: 0.3,
                        colorFilter: ColorFilter.mode(
                            Colors.black, BlendMode.colorDodge))),
                child: Stack(
                  children: [
                    const Positioned(
                        top: 40,
                        left: 50,
                        child: Text(
                          'Collect Payment',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Claredon'),
                        )),
                    Positioned(
                      top: 60,
                      child: Row(
                        children: [
                          Container(
                            height: screenSize.height / 4,
                            width: screenSize.width * 0.95,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                    colors: [Color(0x00aeffa4), Color(0x00ffffff)],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                // const Padding(
                                //   padding: EdgeInsets.only(left: 15.0, top: 30.0, bottom: 5.0),
                                //   child: Text(
                                //     "Customer Information",
                                //     style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.white),
                                //   ),
                                // ),
                                SizedBox(
                                  width: screenSize.width,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0, top: 5.0),
                                        child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            width:  screenSize.width / 3.9,
                                            height:  screenSize.width / 3.9,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1.0, color: const Color(0x99ffFFFF), strokeAlign: BorderSide.strokeAlignOutside),
                                              borderRadius:
                                              const BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: Stack(children: [
                                              Container(
                                                clipBehavior: Clip.hardEdge,
                                                width:  screenSize.width / 3,
                                                height:  screenSize.width / 3,
                                                decoration:  BoxDecoration(
                                                  border: Border.all(width: 2.0, color: const Color(0x77ffFFFF), strokeAlign: BorderSide.strokeAlignOutside),
                                                  borderRadius:const BorderRadius.all(Radius.circular(20)),
                                                ),
                                                child:MainClass.getProfilePic(isProfile, cardNo, context) ,
                                              ),
                                              Positioned(
                                                child: Visibility(
                                                  visible: isProfile > 0 ? false : cardNo  == ""? false :cardPackage == "Card No"? false : true,
                                                  child: Container(
                                                    width:  screenSize.width / 3,
                                                    height:  screenSize.width / 3,
                                                    decoration: const BoxDecoration(color: Colors.black26, ),
                                                    child: Center(
                                                      child: IconButton(
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          SnackBar snackBar = SnackBar(action: SnackBarAction(label: "Save Image", onPressed: (){
                                                            MainClass.updateDB("UPDATE Customers SET Photo = 1 WHERE CardNo = ?", [cardNo]).then((value) =>
                                                            {
                                                            File(imageFile!.path).copySync("${MainClass.customerImagesPath}$cardNo.png"),
                                                            MainClass.isCustomersLoaded= false
                                                            }
                                                            );

                                                          }), content: const Text("Image Capture Successful ", style: TextStyle(fontSize: 11),), duration:const Duration(milliseconds: 5000) ,);
                                                          MainClass.onImageButtonPressed(cardNo).then((value) =>
                                                          setState(() {
                                                          imageFile = value;
                                                          if(value != null){
                                                          isProfile = 1;
                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                          } } )
                                                          );
                                                        },
                                                        icon:  const Icon(Icons.camera_alt),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                        child: SizedBox(
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Icon(Icons.account_circle, color: Colors.white, size: 18,),
                                              Icon(Icons.phone, color: Colors.white, size: 18,),
                                              Icon(Icons.location_on_sharp, color: Colors.white, size: 18,),
                                              Icon(Icons.calendar_month, color: Colors.white, size: 18,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                MainClass.returnTitleCase(name), style: const TextStyle(color: Colors.white),
                                              ),
                                              Text(
                                                phone, style: const TextStyle(color: Colors.white),
                                              ),
                                               Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(  MainClass.returnTitleCase(address),
                                                      style: const TextStyle(color: Colors.white),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    )),
                                              ),
                                              Text(
                                                date, style: const TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    Positioned(
                      top: 28,
                      left: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: isTyping,
              child: Container(
                transform: Matrix4.translationValues(-5, -50, 0),
                height: screenSize.height / 4.3,
                width: screenSize.width * 0.95,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x15000000),
                        offset: Offset(1.0, 2.0),
                        blurRadius: 1.0,
                        spreadRadius: 2.0
                      )
                    ],

                    gradient: LinearGradient(
                        colors: [Color(0xffffffff), Color(0xccffffff)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft)
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 15.0),
                        child: Text(
                          "Payment Information",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width,
                        height: screenSize.height / 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "LastMark:  ",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "L. PayAmount:   ",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "L. PayDate: ",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Collected By:  ",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Progress: ",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 180,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lastMark,
                                        style: textStyle1,
                                      ),
                                      Text(
                                        payAmount.toString(),
                                        style: textStyle1,
                                      ),
                                      Text(
                                        payDate,
                                        style: textStyle1,
                                      ),
                                      Text(
                                        collectedBy,
                                        style: textStyle1,
                                      ),
                                      LinearProgressIndicator(
                                        value: progress,
                                        color: progress == 1.0? Colors.green[800] :Colors.lightBlue[800],
                                        minHeight: 13,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isAmount,
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text(
                                        lastMark2,
                                        style: payStyle2,
                                      ),
                                      Text(
                                        payAmount2.toString(),
                                        style: payStyle2,
                                      ),
                                      Text(
                                        payDate2,
                                        style: payStyle2,
                                      ),
                                      Text(
                                        collectedBy2,
                                        style: payStyle2,
                                      ),
                                      Text(
                                        "    "+((totalAmtPaid+payAmount2) / totalAmtPayable *100).floor().toString()+"%",
                                        style: payStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: double.infinity),
                  transform: Matrix4.translationValues(-5, -40, 0),
                  width: screenSize.width * 0.95,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),

                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                        child: Text(
                          "Card Details",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: screenSize.width * 0.85,
                          child: TextField(
                            onChanged:  (card) async {
                              cardNo = card.toUpperCase();
                              cardTextController.value.text.isEmpty?
                              clearUI :
                              setUI(await CollectPaymentController.cardEntered(card.toUpperCase()));
                              },
                            controller: cardTextController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.credit_card_rounded),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      cardTextController.clear();
                                      amountController.clear();
                                      clearUI();
                                      setState(() {
                                        isButtonDisabled = true;
                                      });

                                    },
                                    child: const Icon(Icons.close)),
                                hintText: "Enter Card No",
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                label: Text(
                                  cardPackage
                                  ,
                                  style:
                                  TextStyle(color: cardPackage == "Card No" ?const Color(0xFF21AC06) : const Color(0xFF083A09) ),
                                ),
                                border: const OutlineInputBorder()),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: SizedBox(
                          width: screenSize.width * 0.85,
                          child:  TextField(
                            onChanged: (amount){
                              _amount = int.parse(amount.isEmpty ? "0" : amount);
                              payAmount2 = int.parse(amount.isEmpty ? "0" : amount);
                              lastMark2 = CollectPaymentController.getLastMark("", _amount, rate,totalAmtPaid);
                              },
                            controller: amountController,

                            keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.currency_exchange),
                                label: Text(
                                  "Amount",
                                  style:
                                  TextStyle(textBaseline: TextBaseline.alphabetic),
                                ),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: SizedBox(
                          width: screenSize.width * 0.8,
                          height: 50,

                          child: ElevatedButton(
                            autofocus: true,
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              disabledForegroundColor: Colors.green[900],
                              disabledBackgroundColor: Colors.black38,

                            ),
                            onPressed: isButtonDisabled ? null : collectPayment,
                            child: const Text("Collect Payment"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }


  void collectPayment(){
    SnackBar snackBar = SnackBar(content: Text("Payment For Card:$cardNo Successful!", style: const TextStyle(fontSize: 11),), duration:const Duration(milliseconds: 2000) ,);
    showModalBottomSheet(constraints: const BoxConstraints(maxHeight: 200), context: context, builder: (context) => Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Confirm Payment: ', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Claredon' ),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(' N$_amount For Card: $cardNo ? ', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Claredon' ),),
        ),
        Center(
            child:ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            disabledForegroundColor: Colors.green[900],
            disabledBackgroundColor: Colors.black38,
          ),
          onPressed: () async {
            Map<String,Object> data = HashMap<String,Object>();
            data.putIfAbsent("Date", () => MainClass.databaseFormat.format(DateTime.now()));
            data.putIfAbsent("CardNo", () => cardNo);
            data.putIfAbsent("Amount", () => _amount);
            data.putIfAbsent("LastMark", () => lastMark2);
            data.putIfAbsent("Collected", () =>  MainClass.staff);
            int oldAmount = 0;
            String sql = "";
            await MainClass.readDB("SELECT Amount From Printout WHERE CardNo = ? AND Date = ? ", [cardNo,  MainClass.databaseFormat.format(DateTime.now()) ]).then((value) =>
            {

              if(value.isNotEmpty){
                print("Updating..."),
                oldAmount = int.parse(value.single.col1!),
                sql = "UPDATE Printout SET Amount = ? WHERE CardNo = ? AND Date = ?",
                MainClass.updateDB(sql, [(oldAmount+_amount), cardNo,  MainClass.databaseFormat.format(DateTime.now())])
              }else{
                print("inserting..."),
                MainClass.insertDB(data, "Printout"),
                MainClass.todayCustomers += 1,
              },
              sql = "UPDATE Customers SET TotalAmtPaid = ?, LastMark = ?, LastPayAmount  = ?,LastPayDate = ?,CollectedBy = ? WHERE CardNo = ?",
              MainClass.updateDB(sql, [(totalAmtPaid+_amount), lastMark2,_amount, MainClass.databaseFormat.format(DateTime.now()), MainClass.staff, cardNo])
            });


            MainClass.todayBalance += _amount;
            MainClass.reloadDashboard = true;

            cardTextController.clear();
            amountController.clear();
            clearUI();

            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
            Navigator.pop(context);},
          icon: const Icon(Icons.check), label:  const Text('Confirm Payment'),

        ) ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(

            elevation: 5,
            foregroundColor: Colors.white,
            backgroundColor: Colors.red[900],
          ),
          onPressed: (){ Navigator.pop(context);},
          icon: const Icon(Icons.cancel), label:  const Text('   Dismiss           '),

        ),
      ],
    ),
    );
  }

  void clearUI(){
     profile = const Image(image: AssetImage('assets/images/placeholder.jpg'), fit: BoxFit.cover,);
     isProfile = 0;
     name = "";
     phone = "";
     address = "";
     date = "";
     cardPackage=  "Card No";

      lastMark = ""  ;
      payAmount= 0  ;
      payDate= ""  ;
      collectedBy= ""  ;
      progress= 0.0 ;

      lastMark2 = ""  ;
      payAmount2= 0  ;
      payDate2= ""  ;
      collectedBy2= ""  ;
  }



  void setUI(List<String> data){
    // Name,Address,Phone,DateOfReg,LastMark,LastPayAmount,LastPayDate,CollectedBy,CardPackage,TotalAmtPayable,TotalAmtPaid, Photo,
    if(data.isNotEmpty){
      isProfile  = int.parse(data[12]);
      profile = isProfile > 0?
      const Image(image: AssetImage('assets/images/profile.jpg'), fit: BoxFit.cover,) :
      const Image(image: AssetImage('assets/images/placeholder.jpg'), fit: BoxFit.cover,);


      name = data[0];
      address = data[1];
      phone = data[2];
      date = data[3];

      //Payment Information Variables
      lastMark = data[4];
      payAmount= int.parse(data[5]) ;
      try{
        payDate= MainClass.userFormat.format(DateTime.parse(data[6]));
      }catch(e){
        payDate=(data[6]);
      }

      collectedBy =  data[7];
      cardPackage=  data[8];
      totalAmtPayable= int.parse(data[10]) ;
      totalAmtPaid= int.parse(data[11]) ;
      rate = int.parse(data[13]) ;

      progress = totalAmtPaid / totalAmtPayable;
      progress = progress > 1 ?  0: totalAmtPayable == totalAmtPaid ? 1 : progress;
      //Update Payment Information Variables
      payAmount2= _amount;
      payDate2= MainClass.userFormat.format(DateTime.now());
      collectedBy2= MainClass.staff  ;

    }else{
      clearUI();
    }
    setState(() {

    });
  }
}



class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h * 0.8);
    path.quadraticBezierTo(
      w * 0.25,
      h * 0.7,
      w * 0.5,
      h * 0.8,
    );
    path.quadraticBezierTo(
      w * 0.85,
      h * 0.95,
      w,
      h * 0.8,
    );
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
