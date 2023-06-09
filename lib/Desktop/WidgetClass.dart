
import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../Classes/LogicClass.dart';
import '../Interface/MainInterface.dart';
import 'package:dio/dio.dart';




class WidgetClass{
  static Color defaultColor = Colors.black45;
  static  Color mainColor = const Color(0xff000077);
  static Map<String, dynamic> sharedPreferences = {};
}


class MySavedPreferences {
  static final MySavedPreferences _instance = MySavedPreferences._internal();

  factory MySavedPreferences() {
    return _instance;
  }

  MySavedPreferences._internal();

  static void addPreference(String key, dynamic value) {
    WidgetClass.sharedPreferences[key] = value;
  }

  static dynamic getPreference(String key) {
    dynamic value = WidgetClass.sharedPreferences[key];
    return value ?? 0.0;
  }
}


class MyFloatingActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const MyFloatingActionButton({super.key, required this.text, required this.onPressed});

  @override
  MyFloatingActionButtonState createState() => MyFloatingActionButtonState();
}

class MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool _isHovering = false;
  static const Duration _animationDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (isHovering) {
        setState(() { _isHovering = isHovering;});},
      child: AnimatedContainer(
        duration: _animationDuration,
        width: _isHovering ? 150 : 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: _isHovering ? Colors.white70: WidgetClass.mainColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _isHovering ? Center(child: Text(widget.text, style:  TextStyle(color: WidgetClass.mainColor, fontWeight: FontWeight.bold),)) :
          Icon(widget.text == 'Select Date'? Icons.calendar_month :widget.text == 'Move Product'? Icons.airport_shuttle_outlined : Icons.add, color: !_isHovering ? Colors.white: WidgetClass.mainColor,),
        ),
      ),
    );
  }
}

class MyCustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Size size;

  const MyCustomButton({super.key, required this.text, required this.onPressed, required this.icon, required this.size, } );

  @override
  MyCustomButtonState createState() => MyCustomButtonState();
}

class MyCustomButtonState extends State<MyCustomButton> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: FaIcon( widget.icon,
          size: widget.size.height * 0.5,
          color: _isHovering ?  WidgetClass.mainColor : Colors.white
      ),
      onPressed: widget.onPressed,
      onHover: (isHovering) {
        _isHovering = isHovering;
        setState(() {});
      },
      label: Text(
        widget.text,
        style: TextStyle(
            color: _isHovering ? WidgetClass.mainColor : Colors.white,
            fontSize: widget.size.height / 3),
      ),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        backgroundColor:_isHovering ?   Colors.white : WidgetClass.mainColor,
        // backgroundColor: Colors.transparent,
        fixedSize: widget.size,
        shape:widget.size.height == 42? RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)) : RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }
}

class InventoryImage extends StatefulWidget {
  final String productId;
  final String imageType;

  const InventoryImage({Key? key, required this.productId, required this.imageType}) : super(key: key);

  @override
  State<InventoryImage> createState() => _InventoryImageState();
}

class _InventoryImageState extends State<InventoryImage> {
  late Future<Widget> futureImage;

  @override
  void initState() {
    super.initState();
    futureImage = FirebaseClass.getProductImage(widget.productId, widget.imageType);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: futureImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(
           alignment: AlignmentDirectional.center,
            fit:  widget.imageType == "Images" ? StackFit.expand :  StackFit.loose,
            children: [
              Image.asset(
                'assets/images/placeholder.jpg',
                fit:   BoxFit.cover,
              ),
               const Center(child: Text("Loading ...", style: TextStyle(fontSize: 11, color: Colors.grey),))
            ],
          );
        } else if (snapshot.hasError) {
          return Image.asset(
            'assets/images/placeholder.jpg',
            fit: BoxFit.cover,
          );
        } else if (!snapshot.hasData) {
          return Image.asset(
            'assets/images/placeholder.jpg',
            fit: BoxFit.cover,
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: snapshot.data!,
              ),
            ],
          );
        }
      },
    );
  }
}

class LoadingDialog extends StatefulWidget {
  final String title;
  const LoadingDialog({super.key,  required this.title});

  // const LoadingDialog(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final dialog =  AlertDialog(
            title: Text(widget.title),
            content:  Padding( padding: const
            EdgeInsets.only(top: 10.0, bottom: 10.0, right: 18.0, left: 1.0),
              child: Container(
                transform: Matrix4.translationValues(10, 5, 0),
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  color: mainColor,
                ),
              ),
            )


        );
        return dialog;
      },
    );
  }
}

class PaymentConfirm extends StatefulWidget {
  final String status;
  final String ref;
  final String collection;
  const PaymentConfirm({Key? key, required this.status, required this.ref,required this.collection}) : super(key: key);


  @override
  State<PaymentConfirm> createState() => _PaymentConfirmState();
}

class _PaymentConfirmState extends State<PaymentConfirm> {
  String status = "";
  @override
  Widget build(BuildContext context) {

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(status == "" ? widget.status : status, style: TextStyle(color:status == ""? widget.status == "Unconfirmed"? Colors.red: Colors.green:Colors.green , fontWeight: FontWeight.bold)),
        Visibility(
          visible:status == ""? widget.status == "Unconfirmed" : false,
          child: TextButton(onPressed: () async{
            await FirebaseClass.updateDynamic( widget.collection, widget.ref,
                {"Status": "Confirmed"});
            status =  await FirebaseClass.getDynamic(widget.collection, widget.ref,
                "Status");
            setState(() {


            });
          }, child: Icon(Icons.done_all, color: Colors.green[900],)),
        ),
      ],
    );
  }
}


class DownloadFileScreen extends StatefulWidget {
  @override
  _DownloadFileScreenState createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends State<DownloadFileScreen> {
  double _progress = 0.0;

  Future<int?> downloadFile() async {
    final String? userProfile = Platform.environment['USERPROFILE'];
    final String imageFolderPath = '$userProfile\\AppData\\Local\\CachedImages\\mightykens.exe';
    final File softwareFile = File(imageFolderPath);
    if (softwareFile.existsSync()) {
      softwareFile.deleteSync();
    }

    softwareFile.createSync();

    final dio = Dio();
    final response = await dio.download(
      await FirebaseClass.updateSoftware(),
      imageFolderPath,
      onReceiveProgress: (receivedBytes, totalBytes) {
        if (totalBytes != -1) {
          double progress = (receivedBytes / totalBytes) * 100;
          setState(() {
            _progress = progress;
          });
        }
      },
    );

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyCustomButton(
                text: "Update Software",
                onPressed: () async {
                  downloadFile().then((value) => {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black87, content: Text(value == 200? "Software Update Successful": "Update Failed", style:  TextStyle(fontSize: 18, color: Colors.white), ), duration:const Duration(milliseconds: 2000) ,))
                  });

                },
                icon: Icons.download,
                size: const Size(180, 41)
            ),
            const SizedBox(height: 5),
            Visibility(
              visible: _progress.ceil() > 0,
                child: Center(child: Text("${_progress.ceil()} %", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black ),))),

          ],
        ),
      ),
    );
  }
}
class GradientProgressBar extends StatelessWidget {
  const GradientProgressBar(
      {
        required this.value,
        required this.height
      });
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.colorBurn,
      shaderCallback: (Rect bounds) { return const LinearGradient(
          colors: [
            Color(0xff2fbb04),
            Color(0xff185801)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter).createShader(bounds);},
      child: LinearProgressIndicator(value: value, minHeight: height, backgroundColor: Colors.white, color: Colors.green[400],),
    );
  }
}









class CustomerInformation {
  String name = "Chukwuedo Jame2s";
  String phone = "08142605775";
  String address = "CS 60 CornerStone Plaza, Alaba Int'l Market Ojo Lagos";
  String date = "11/10/2022";
  String status = "Active";
  String cardNo  = "Active" ;


  static Map<String, dynamic> data = {
    "Address":"",
    "Amount":0,
    "AuditDate":"",
    "Branch":"",
    "CardNo":"",
    "CardPackage":"",
    "CardType":"",
    "ClearedDate":"",
    "ClearedTimes":"",
    "CollectedBy":"",
    "DateOfReg":"",
    "Image":"",
    "LastAudit":"",
    "LastClearedDate":"",
    "LastMark":"",
    "LastPayAmt":0,
    "LastDate":"",
    "Name":"",
    "Percentage":0.0,
    "Period":"",
    "Phone":"",
    "SecondRnd":"",
    "StaffReg":"",
    "StartDate":"",
    "Status":"",
    "Status2":"",
    "TotalAmtPaid":0,
    "TotalAmtPayable":0,
    "TotalBalRem":0,
  };

  static Map<String, dynamic> defaultData = {
    "Address":"",
    "Amount":0,
    "AuditDate":"",
    "Branch":"",
    "CardNo":"",
    "CardPackage":"",
    "CardType":"",
    "ClearedDate":"",
    "ClearedTimes":"",
    "CollectedBy":"",
    "DateOfReg":"",
    "Image":"",
    "LastAudit":"",
    "LastClearedDate":"",
    "LastMark":"",
    "LastPayAmt":0,
    "LastDate":"",
    "Name":"",
    "Percentage":0.0,
    "Period":"",
    "Phone":"",
    "SecondRnd":"",
    "StaffReg":"",
    "StartDate":"",
    "Status":"",
    "Status2":"",
    "TotalAmtPaid":0,
    "TotalAmtPayable":0,
    "TotalBalRem":0,
  };
  static Map<String, dynamic> getInfo(){
    return data;
  }

}

