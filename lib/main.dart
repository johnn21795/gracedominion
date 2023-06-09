import 'dart:io';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gracedominion/Desktop/Operator/Dashboard.dart';
// import 'package:gracedominion/Desktop/Operator/MainInterface.dart';
// import 'package:gracedominion/Warehouse/MainInterface.dart';
import 'package:gracedominion/Desktop/Splash.dart';
import 'package:gracedominion/Desktop/WindowsApplication.dart';
import 'package:gracedominion/UI/FireTest.dart';
import 'package:gracedominion/Warehouse/Product.dart';

import 'Interface/MainInterface.dart';
import 'Interface/login.dart';
import 'UI/CollectPayment.dart';
import 'UI/Customers.dart';
import 'UI/Dashboard.dart';
import 'UI/NewCustomer.dart';
import 'UI/Printout.dart';
import 'UI/Profile.dart';
import 'UI/Upload.dart';
// import 'UI/login.dart';
import 'AppRoutes.dart';
import 'firebase_options.dart';







void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isWindows){
    //initialize firebase dart on windows...an alternative to the real Firebase because Windows don't support Firebase at this time
    WindowsApplication();

  }else {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }


  runApp(const MyApp());

}

Map<String, MaterialColor> themes = {
  "Warehouse":  const MaterialColor(700,{700: Color(0xFF000055)},),
  "ShowRoom":   const MaterialColor(700,{700: Color(0xFF005500)}),
  "Management":   const MaterialColor(700,{700: Color(0xFF005555)})};

class MyApp extends StatelessWidget {
  const MyApp({super.key});





  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MightyKens International Limited',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute:  AppRoutes.login,
      onGenerateRoute: (route) => getRoute(route),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }


  Route? getRoute(RouteSettings route) {
    switch(route.name){
      case AppRoutes.home:
        return buildRoute(const Dashboard(), route:route);
      case AppRoutes.collectPayment:
        return buildRoute(const CollectPayment(), route:route);
      case AppRoutes.customers:
        return buildRoute(const Customers(), route:route);
      case AppRoutes.newCustomer:
        return buildRoute(const RegisterCustomer(), route:route);
      case AppRoutes.printout:
        return buildRoute(const PrintOut(), route:route);
      case AppRoutes.profile:
        return buildRoute(const Profile(), route:route);
      case AppRoutes.upload:
        return buildRoute(const Upload(), route:route);
      case AppRoutes.login:
        return buildRoute(const Login(), route:route);
      case AppRoutes.fireTest:
        return buildRoute(const FireTest(), route:route);

        //Windows Unique Route
      case AppRoutes.windowsSplash:
        return buildRoute(const Splash(), route:route);
        //for Dominion
      // case AppRoutes.operatorDashboard:
      //   return buildRoute(const MainInterface(), route:route);



    //NEW ROUTING
      case AppRoutes.interfaceLogin:
        return buildRoute(const Login(), route:route);
      case AppRoutes.windowsDashboard:
        return buildRoute(const Login(), route:route);


      case AppRoutes.operatorDashboard:
        return buildRoute(const MainInterface(), route:route);

      case AppRoutes.product:
        return buildRoute(const ProductPage(data:{}), route:route);
      default:
        return null;

    }
  }

  MaterialPageRoute buildRoute(Widget child, {required RouteSettings route}) {
    return MaterialPageRoute(
      settings: route,
      builder:  (BuildContext context) => child,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
