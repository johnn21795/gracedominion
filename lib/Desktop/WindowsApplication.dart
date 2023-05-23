import 'dart:io';

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
      // apiKey: "AIzaSyA1-JiaQ0RXoSUa9us1Zd_xwv3Mk_j9Xb4",
      // authDomain: "gracedominion-d5643.firebaseapp.com",
      // databaseURL: "https://gracedominion-d5643-default-rtdb.europe-west1.firebasedatabase.app",
      // projectId: "gracedominion-d5643",
      // storageBucket: "gracedominion-d5643.appspot.com",
      // messagingSenderId: "162191643161",
      // appId: "1:162191643161:web:fb8ddf6ccb2f5dac8f9088",
      // measurementId: "G-HK8WESM16P"
      apiKey: "AIzaSyAB2Yn_Y3Ppo0txysLkHPxjwTX9NwxWhOg",
      authDomain: "mightykens-69536.firebaseapp.com",
      projectId: "mightykens-69536",
      storageBucket: "mightykens-69536.appspot.com",
      messagingSenderId: "466096782464",
      appId: "1:466096782464:web:1090ac4df831be1bbffa65",
      measurementId: "G-Z98N6QMJ90"
  );


  WindowsApplication()  {
    startApplication();
    //initialize firebase dart on windows...an alternative the real Firebase because Windows don't support Firebase at this time
    FirebaseDart.setup();
    Firebase.initializeApp(options: firebaseWindows).then((value) =>
    {
     //for storage
    FirebaseStorage.instanceFor(app: value),
      //for Authentications and Logins
    FirebaseAuth.instanceFor(app: value),
    // MainClass.loadFireBaseAppInformation(),
    // MainClass.loadStaffInformation(),
    });

    // for FireStore Database
    try {
      Firestore.initialize(firebaseWindows.projectId);
    } catch (e) {
      print("FireStore Error $e");
    }

    //Directory for storing Images
    Directory directory = Directory('${Platform.environment['USERPROFILE']}\\AppData\\Local\\CachedImages\\Thumbnails\\');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    directory = Directory('${Platform.environment['USERPROFILE']}\\AppData\\Local\\CachedImages\\Images\\');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    directory = Directory('C:\\Users\\Public\\TempImages\\');
    directory.deleteSync(recursive: true);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
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