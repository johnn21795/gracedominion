import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../AppRoutes.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

double time = 0.05;
String status = "Starting Up...";

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) { initialize();});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(
        // gradient:   LinearGradient(colors: [
        //   Color(0xffea06ec),
        //   Color(0xff16001a),
        //
        // ],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter
        //
        // ),
        // color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
                'assets/images/backgrounds/splash.jpg'),
            fit: BoxFit.cover,
            opacity: 1.0,
            colorFilter: ColorFilter.mode(
                Colors.white, BlendMode.colorBurn))
      ),

      child: Column(
        children: [
          Text('Grace Dominion Limited', style: TextStyle(fontSize: 35, color: Colors.purple[800], decoration: TextDecoration.none, fontFamily: 'Claredon'),),

          GradientText('Accounting Software', style: TextStyle(fontSize: 23, color: Colors.yellow[200],  decoration: TextDecoration.none, fontFamily: 'Claredon'),),
          const SizedBox(height: 50,),

          Container(alignment:Alignment.centerLeft, child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("2023 Edition", style: TextStyle(fontSize: 20, color: Colors.purple[800],  decoration: TextDecoration.none, fontFamily: 'Claredon')),
          )),
          Container(alignment:Alignment.centerLeft, child: Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: Text('Version 3.1.9', style: TextStyle(fontSize: 14, color: Colors.purple[800],  decoration: TextDecoration.none, fontFamily: 'Claredon')),
          )),
          const SizedBox(height: 30,),
          Text(status, style: TextStyle(fontSize: 18, color: Colors.purple[800],  decoration: TextDecoration.none, fontFamily: 'Claredon')),
          const SizedBox(height: 15,),
          Text('Loading: ${(time * 100).ceil()}%', style: TextStyle(fontSize: 16, color: Colors.purple[800],  decoration: TextDecoration.none, fontFamily: 'Claredon')),
          const SizedBox(height: 5,),
           Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: GradientProgressBar(
              value: time,
              height: 30,
            ),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(alignment: Alignment.centerLeft, width:300,child: Text('Powered by RICHTECH TECHNOLOGIES 08144430361', style: TextStyle(fontSize: 12, color:  Colors.white, fontWeight: FontWeight.w300,  decoration: TextDecoration.none, fontFamily: 'claredon'))),
              Container(alignment: Alignment.centerLeft, width:200,child: Text('For Complaint and Information Call:08142605775', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w300,  decoration: TextDecoration.none, fontFamily: 'Claredon'))),
            ],
          ),
        ],
      ),

    );

  }


  Stream<double> progressIsolate()  {
    final rp = ReceivePort();
    return Isolate.spawn(_progressIsolate, rp.sendPort)
        .asStream()
        .asyncExpand((_) => rp)
        .takeWhile((element) => element is double)
        .cast();

  }

  void initialize() async{
    int count = 0;
    await for (final msg in progressIsolate()){
      setState(() {
        time = msg;
        count+=1;
        if(count == 7){
          status = "Checking internet Connection...";
        }
        if(count == 20){
          status = "Initializing Firebase...";
        }
        if(count == 30){
          status = "Connecting to Database..";
        }
        // if(count == 10){
        //   status = "Connecting to Database";
        // }
        // if(count == 10){
        //   status = "Connecting to Database";
        // }

      });
    }
    windowManager.setSize(const Size(400,600), animate: true);
    windowManager.center(animate: true);
    windowManager.focus();
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }



}
void _progressIsolate(SendPort sendPort) async{
  double progress = 0.0;
  await for (final now in Stream.periodic(
      const Duration(milliseconds: 50),(_) => {progress += 0.03}).takeWhile((element) => element.last <= 1.0 )) {
    // print("now ${now.last}");
    sendPort.send(now.last);
  }
  Isolate.exit(sendPort);
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

class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        this.style,
      });

  final String text;
  final TextStyle? style;


  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstOver,
      shaderCallback: (Rect bounds) { return const LinearGradient(
          colors: [
            Color(0xff2fbb04),
            Color(0xff185801)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter).createShader(bounds);},
      child: Container(color:Colors.purple, width:300,child: Center(child: Padding(padding: EdgeInsets.all(7.0), child: Text(text, style:style,)))),
    );
  }
}
