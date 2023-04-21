import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../Classes/MainClass.dart';
import '../Controller/CollectPaymentController.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  @override
  void initState() {
    try {
      Directory("${MainClass.customerImagesPath}Old/").createSync(recursive: true);
    } catch (e) {
    print(e);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Image profile = const Image(
    image: AssetImage('assets/images/placeholder.jpg'),
    fit: BoxFit.cover,
  );
  final textController = TextEditingController();
  final cardController = TextEditingController();
  final amountController = TextEditingController();

  List<String> cardList = <String>["Contribution", "Savings", "Property"];

  bool allowSMS = false;
  bool isCardExist = false;
  bool isButtonDisabled = true;

  String
      fName = "",
      lName = "",
      phone = "",
      address = "",
      cardNo = "",
      cardType = "Contribution",
      period = "4 Months";
  String? cardPackage = MainClass.selectedPackage?.first
      .putIfAbsent("CardPackage", () => "")
      .toString();
  int initialPayment = 0;

  List<XFile>? _imageFileList;
  Map<String, String> newImageFileList = HashMap<String, String>();

  // Directory? _appSupportDirectory;
  // Directory? _externalCacheDirectories;

  void _requestExternalStorageDirectory() async {
    setState(() {
      // getApplicationDocumentsDirectory().then((value) => _appSupportDirectory = value);
      // getExternalCacheDirectories().then((value) => _externalCacheDirectories = value?.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    _requestExternalStorageDirectory();

    Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(children: [
        ListView(
          children: [
            SizedBox(
              height: screenSize.height / 3,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0),
              child: Text(
                "Card Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            cardInputWidget(context, cardNo,
                const Icon(Icons.credit_card_rounded)),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0),
              child: Text(
                "Customer Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: inputWidget(context, "First Name", fName,
                        const Icon(Icons.account_circle))),
                Expanded(
                    child: inputWidget(
                        context,
                        "Last Name",
                        lName,
                        const Icon(Icons.account_circle_outlined))),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            inputWidget(context, "Phone", phone, const Icon(Icons.phone)),
            const SizedBox(
              height: 10,
            ),
            inputWidget(context, "Address", address,
                const Icon(Icons.location_on)),
            const SizedBox(
              height: 10,
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Stack(
                        children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        width: screenSize.width / 3.3,
                        height: screenSize.width / 3.3,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: const Color(0x77ffFFFF),
                              strokeAlign: BorderSide.strokeAlignOutside),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: _imageFileList == null
                            ? profile
                            : newImageFileList.putIfAbsent("front", () => "") == "" ? profile : Image.file(
                          File(newImageFileList.putIfAbsent("front", () => "")),
                          fit: BoxFit.cover,
                        ),
                        // Image.file(File(_imageFileList![0].path), fit: BoxFit.cover,),
                      ),
                      Positioned(
                        child: Container(
                          width: screenSize.width / 3.3,
                          height: screenSize.width / 3.3,
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: IconButton(
                              color: Colors.white,
                              onPressed: isButtonDisabled? null : () {
                                _onImageButtonPressed(
                                  ImageSource.camera, page: "front"
                                );
                              },
                              icon: Visibility(
                                  visible: newImageFileList.putIfAbsent("front", () => "") == "" ? true : false,
                                  child: const Icon(Icons.camera_alt)),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const Center(
                        child: Text(
                          "Card Front",
                          style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                Column(
                  children: [
                    Stack(children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        width: screenSize.width / 3.3,
                        height: screenSize.width / 3.3,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: const Color(0x77ffFFFF),
                              strokeAlign: BorderSide.strokeAlignOutside),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: _imageFileList == null
                            ? profile
                            : newImageFileList.putIfAbsent("first", () => "") == "" ? profile : Image.file(
                          File(newImageFileList.putIfAbsent("first", () => "")),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        child: Container(
                          width: screenSize.width / 3.3,
                          height: screenSize.width / 3.3,
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: IconButton(
                              color: Colors.white,
                              onPressed: isButtonDisabled? null : () {
                                _onImageButtonPressed(
                                  ImageSource.camera, page: "first"
                                );
                              },
                              icon: Visibility(
                                  visible: newImageFileList.putIfAbsent("first", () => "") == "" ? true : false,
                                  child: const Icon(Icons.camera_alt)),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const Center(
                        child: Text(
                          "First Mark",
                          style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                Column(
                  children: [
                    Stack(children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        width: screenSize.width / 3.3,
                        height: screenSize.width / 3.3,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: const Color(0x77ffFFFF),
                              strokeAlign: BorderSide.strokeAlignOutside),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: _imageFileList == null
                            ? profile
                            : newImageFileList.putIfAbsent("last", () => "") == "" ? profile : Image.file(
                              File(newImageFileList.putIfAbsent("last", () => "")),
                                fit: BoxFit.cover,
                              ),

                      ),
                      Positioned(
                        child: Container(
                          width: screenSize.width / 3.3,
                          height: screenSize.width / 3.3,
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: IconButton(
                              color: Colors.white,
                              onPressed: isButtonDisabled? null :() {
                                _onImageButtonPressed(
                                  ImageSource.camera, page:"last"
                                );
                              },
                              icon: Visibility(
                                  visible:newImageFileList.putIfAbsent("last", () => "") == "" ? true : false,
                                  child: const Icon(Icons.camera_alt)),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const Center(
                        child: Text(
                          "Last Mark",
                          style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            dropDownWidget2(context, "Card Type", cardList.first, cardList,
                (select) {
              cardType = select!;
              setState(() {});
            }),
            const SizedBox(
              height: 10,
            ),
            dropDownWidget(context, "Card Package", MainClass.selectedPackage,
                (select) {
              cardPackage = select!;
              setState(() {});
            }),
            const SizedBox(
              height: 10,
            ),
            dropDownWidget2(context, "Period", MainClass.periodList.first,
                MainClass.periodList, (select) {
              period = select!;
              setState(() {});
            }),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 20.0),
              child: Text(
                "Last Mark Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 20.0),
                    child: TextField(
                      controller: amountController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                            firstDate: DateTime.utc(2022),
                            initialDate: DateTime.now(),
                            lastDate: DateTime.utc(2024),
                            context: context);
                        amountController.text =
                            MainClass.userFormat.format(selectedDate!);
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(22),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          label: const Text(
                            "LastMark Date",
                            style:
                                TextStyle(textBaseline: TextBaseline.alphabetic),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only( right: 10),
                    child:
                    dropDownWidget2(context, "Other Date", MainClass.lastMarkList.first,
                        MainClass.lastMarkList, (select) {
                          period = select!;
                          setState(() {});
                        }),
                  ),
                ),
              ],
            ),
            Center(
              child: SizedBox(
                width: screenSize.width * 0.8,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    disabledForegroundColor: Colors.green[900],
                    disabledBackgroundColor: Colors.black38,

                  ),
                  onPressed:  isButtonDisabled ? null : () {
                    if (_imageFileList == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Image Required!",
                            style: TextStyle(fontSize: 11),
                          ),
                          duration: Duration(milliseconds: 2000),
                        ),
                      );
                    } else if (fName == "" ||
                        lName == "" ||
                        phone == "" ||
                        address == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "All Fields Required!",
                            style: TextStyle(fontSize: 11),
                          ),
                          duration: Duration(milliseconds: 2000),
                        ),
                      );
                    } else {
                       registerCustomer();
                    }
                  },
                  child: const Text("Add Old Customer"),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
        ClipPath(
          clipper: CustomClipPath(),
          child: Container(
            height: screenSize.height / 2.4,
            width: screenSize.width,
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/backgrounds/greenDark.jpg'),
                    fit: BoxFit.fill,
                    opacity: 0.3,
                    colorFilter:
                        ColorFilter.mode(Colors.black, BlendMode.colorDodge))),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Stack(children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      width: screenSize.width / 3,
                      height: screenSize.width / 3,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.0,
                            color: const Color(0x77ffFFFF),
                            strokeAlign: BorderSide.strokeAlignOutside),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: _imageFileList == null
                          ? profile
                          : newImageFileList.putIfAbsent("profile", () => "") == "" ? profile : Image.file(
                        File(newImageFileList.putIfAbsent("profile", () => "")),
                        fit: BoxFit.cover,
                      ),

                    ),
                    Positioned(
                      child: Container(
                        width: screenSize.width / 3,
                        height: screenSize.width / 3,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: IconButton(
                            color: Colors.white,
                            onPressed: isButtonDisabled? null : () {
                              _onImageButtonPressed(
                                ImageSource.camera, page:"profile"
                              );
                            },
                            icon: Visibility(
                                visible: newImageFileList.putIfAbsent("profile", () => "") == "" ? true : false,
                                child: const Icon(Icons.camera_alt)),
                          ),
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 70,
          width: screenSize.width,
          color: Colors.black12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 3, bottom: 13),
                child: Text(
                  'Old Customer',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Claredon'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Future<void>  _onImageButtonPressed(
    ImageSource source, {String page = ""}
  ) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 50,
      );
      _imageFileList = pickedFile == null ? null : <XFile>[pickedFile];
      setState(() {
        (File(_imageFileList![0].path).copySync(
            "${MainClass.customerImagesPath}Old/$cardNo-$page.png"));
        print("$page${MainClass.customerImagesPath}Old/$cardNo-$page.png");
        newImageFileList.putIfAbsent(page, () => "${MainClass.customerImagesPath}Old/$cardNo-$page.png");
        newImageFileList.update(page, (value) => "${MainClass.customerImagesPath}Old/$cardNo-$page.png",  ifAbsent: () => "${MainClass.customerImagesPath}Old/$cardNo-$page.png");
      });
    } catch (e) {
      setState(() {
        print(e);
      });
    }
  }

  void registerCustomer() {
    SnackBar snackBar = SnackBar(
      action: SnackBarAction(
          label: "Close",
          onPressed: () {
            Navigator.pop(context);
          }),
      content: const Text(
        "Card Registration Successful!",
        style: TextStyle(fontSize: 11),
      ),
      duration: const Duration(milliseconds: 3000),
    );
    showModalBottomSheet(
      constraints: const BoxConstraints(maxHeight: 200),
      context: context,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Confirm Registration: ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Claredon'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'For Card: ${MainClass.newCardList.putIfAbsent(cardType, () => "No New Card")} ?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Claredon'),
            ),
          ),
          Center(
              child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              disabledForegroundColor: Colors.green[900],
              disabledBackgroundColor: Colors.black38,
            ),
            onPressed: () async {
              Map<String, Object> data = HashMap<String, String>();
              String lastMark = "";
              await MainClass.readDB(
                  "SELECT CardPackage,Amount,TotalAmountPayable FROM CardPackages WHERE CardPackage = ?",
                  [
                    cardPackage.toString()
                  ]).then((value) => {
                    lastMark = CollectPaymentController.getLastMark(
                        "", 0, int.parse(value.single.col2!), initialPayment),
                    data.putIfAbsent(
                        "CardNo",
                        () => MainClass.newCardList
                            .putIfAbsent(cardType, () => "No New Card")),
                    data.putIfAbsent("Name", () => fName + " " + lName),
                    data.putIfAbsent("Phone", () => phone),
                    data.putIfAbsent("Address", () => address),
                    data.putIfAbsent("Branch", () => MainClass.branch),
                    data.putIfAbsent("DateofReg",
                        () => MainClass.userFormat.format(DateTime.now())),
                    data.putIfAbsent("CardPackage", () => cardPackage!),
                    data.putIfAbsent("CardPackage", () => cardPackage!),
                    data.putIfAbsent("StaffReg", () => MainClass.staff),
                    data.putIfAbsent("CardType", () => cardType),
                    data.putIfAbsent("Period", () => period),
                    data.putIfAbsent("Amount", () => value.single.col2!),
                    data.putIfAbsent(
                        "TotalAmtPayable", () => value.single.col3!),
                    data.putIfAbsent(
                        "TotalAmtPaid", () => initialPayment.toString()),
                    data.putIfAbsent(
                        "LastPayAmount", () => initialPayment.toString()),
                    data.putIfAbsent(
                        "percentage",
                        () => (initialPayment / int.parse(value.single.col3!))
                            .toString()),
                    data.putIfAbsent("LastPayDate",
                        () => MainClass.userFormat.format(DateTime.now())),
                    data.putIfAbsent("CollectedBy", () => MainClass.staff),
                    data.putIfAbsent("LastMark", () => lastMark),
                    data.putIfAbsent("Status", () => "ACTIVE"),
                    data.putIfAbsent("Photo", () => 1.toString()),
                    data.putIfAbsent("AllowSMS", () => allowSMS.toString()),
                  });
              await MainClass.insertDB(data, "Customers");

              data = HashMap<String, Object>();
              data.putIfAbsent("Date",
                  () => MainClass.databaseFormat.format(DateTime.now()));
              data.putIfAbsent(
                  "CardNo",
                  () => MainClass.newCardList
                      .putIfAbsent(cardType, () => "No New Card"));
              data.putIfAbsent("Amount", () => initialPayment.toString());
              data.putIfAbsent("LastMark", () => lastMark);
              data.putIfAbsent("Collected", () => MainClass.staff);
              await MainClass.insertDB(data, "Printout");

              await MainClass.newCardsList();
              fName = "";
              lName = "";
              phone = "";
              address = "";
              cardType = "Contribution";
              period = "4 Months";
              allowSMS = false;
              MainClass.todayCustomers += 1;
              MainClass.todayBalance += initialPayment;
              MainClass.isCustomersLoaded = false;
              MainClass.reloadDashboard = true;
              _imageFileList = null;

              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
            label: const Text('Confirm'),
          )),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              foregroundColor: Colors.white,
              backgroundColor: Colors.red[900],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.cancel),
            label: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  void clearUI() {
    profile = const Image(
      image: AssetImage('assets/images/placeholder.jpg'),
      fit: BoxFit.cover,
    );
    fName = "";
    lName = "";
    address = "";
  }


  Widget cardInputWidget(BuildContext context, String text,  Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
      child: TextField(
        onChanged: (value) async {
              cardNo = value;
              isButtonDisabled = isCardExist = await MainClass.getBoolean("SELECT CardNo FROM Customers WHERE CardNo = ?",[cardNo.toUpperCase()]);
              isButtonDisabled = isCardExist;
              if(value.isEmpty){
                isButtonDisabled = true;
              }
              setState(() {

              });
        },
        controller: cardController,

        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          errorText:  isCardExist ? "Card Already Exists"  : null,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 0.5)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black38, width: 0.5)),
          prefixIcon: icon,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 0.2)),
          floatingLabelStyle: TextStyle(
              textBaseline: TextBaseline.alphabetic, color: Colors.green[900]),
          label: const Text(
            "CardNo",
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
          ),
        ),
      ),
    );
  }


  Widget inputWidget(BuildContext context, String text, String value, Icon icon) {
    final textController2 = TextEditingController();
    textController2.text = value;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
      child: TextField(
        onChanged: (value) async {
          switch (text) {
            case "First Name":
              fName = value;
              break;
            case "Last Name":
              lName = value;
              break;
            case "Phone":
              phone = value;
              break;
            case "Address":
              address = value;
              break;
            case "CardNo":
              cardNo = value;
              isCardExist = await MainClass.getBoolean("SELECT CardNo FROM Customers WHERE CardNo = ?",[cardNo]);
              if(isCardExist){
                isButtonDisabled = false;
              }else{
                isButtonDisabled = true;
              }
              setState(() {

              });
              break;
          }
        },
        controller: textController2,

        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          errorText: text == "CardNo" ? isCardExist ? "Card Already Exists" : null : null,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 0.5)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black38, width: 0.5)),
          prefixIcon: icon,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 0.2)),
          floatingLabelStyle: TextStyle(
              textBaseline: TextBaseline.alphabetic, color: Colors.green[900]),
          label: Text(
            text,
            style: const TextStyle(textBaseline: TextBaseline.alphabetic),
          ),
        ),
      ),
    );
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

Widget dropDownWidget(BuildContext context, String? text,
    List<Map<String, Object?>>? items, Function(String?) changed) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
    child: DropdownButtonFormField(
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: Text(text!),
          focusColor: Colors.green,
          suffixIconColor: Colors.green,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      value: items?.first.putIfAbsent("CardPackage", () => "").toString(),
      items: items
          ?.map((item) => DropdownMenuItem<String>(
                value: item.putIfAbsent("CardPackage", () => "").toString(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    (item.putIfAbsent("CardPackage", () => "").toString() +
                        "\t\t\t\t " +
                        item.putIfAbsent("Amount", () => "").toString()),
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ),
                ),
              ))
          .toList(),
      onChanged: changed,
    ),
  );
}

Widget dropDownWidget2(BuildContext context, String? text, String? value,
    List<String> items, Function(String?) changed) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
    child: DropdownButtonFormField(
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: Text(text!),
          focusColor: Colors.green,
          suffixIconColor: Colors.green,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      value: value,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: changed,
    ),
  );
}


