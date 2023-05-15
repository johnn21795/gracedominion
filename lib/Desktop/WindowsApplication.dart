import 'package:firebase_dart/auth.dart';
import 'package:firebase_dart/core.dart'  ;
import 'package:firebase_dart/implementation/pure_dart.dart' hide Platform;
import 'package:firebase_dart/storage.dart';
import 'package:firedart/firestore/firestore.dart' ;
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../Classes/MainClass.dart';



class WindowsApplication{
  FirebaseOptions get firebaseWindows => const FirebaseOptions(
      apiKey: "AIzaSyA1-JiaQ0RXoSUa9us1Zd_xwv3Mk_j9Xb4",
      authDomain: "gracedominion-d5643.firebaseapp.com",
      databaseURL: "https://gracedominion-d5643-default-rtdb.europe-west1.firebasedatabase.app",
      projectId: "gracedominion-d5643",
      storageBucket: "gracedominion-d5643.appspot.com",
      messagingSenderId: "162191643161",
      appId: "1:162191643161:web:fb8ddf6ccb2f5dac8f9088",
      measurementId: "G-HK8WESM16P"
  );


  WindowsApplication()  {
    startApplication();
    FirebaseApp app;
    //initialize firebase dart on windows...an alternative the real Firebase because Windows don't support Firebase at this time
    FirebaseDart.setup();
    FirebaseStorage storage;
    Firebase.initializeApp(options: firebaseWindows).then((value) =>
    {
     //for storage
    storage = FirebaseStorage.instanceFor(app: value),
       print("storage ${storage.app}"),
    FirebaseAuth.instanceFor(app: value),
    // MainClass.loadFireBaseAppInformation(),
    // MainClass.loadStaffInformation(),
    },
      onError:(f) => print("Error completing: $f"),
    );
    // for FireStore Database
    try {
      Firestore.initialize(firebaseWindows.projectId);
    } catch (e) {
      print("FireStore Error $e");
    }
  }


  void startApplication() async {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(600, 370),
      size: Size(650, 400),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();

    });

  }

}