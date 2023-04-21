import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';

import '../Classes/MainClass.dart';

class FireTest extends StatefulWidget {
  const FireTest({Key? key}) : super(key: key);

  @override
  State<FireTest> createState() => _FireTestState();
}

class _FireTestState extends State<FireTest> {

  final CollectionReference Customers =   Firestore.instance.collection("Customers");

 var customerList = [];



  @override
  void initState() {
    // TODO: implement initState
   getCustomers();
    super.initState();
  }

  void getCustomers(){
    final CollectionReference packages  = Firestore.instance.collection("packages");
    packages.where("CardType", isEqualTo: "CONTRIBUTION").get().then((firstValue) {
        packages.document(firstValue.first.id).collection("Packages").orderBy("Name").get().then((secondValue)
        {
          for (var e in secondValue) {
            MainClass.contributionPackages?.add(e.map) ;
          }

          // for (var results in secondValue) {
          //   print('${results.id} => ${results.map.entries}');
          // }
          },
          onError: (e) => print("Error completing: $e"),
        );
      },
      // onError: (e) => print("Error completing: $e"),
    );




    // Customers.where("Name", isEqualTo: "JAMES CHUKWUEDO").get().then(
    //       (querySnapshot) {
    //     print("Successfully completed");
    //     for (var results in querySnapshot) {
    //       print('${results.id} => ${results.map.length}');
    //     }
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );

    // Future.delayed(const Duration(milliseconds: 500), () async{
    //   customerList = await Customers.get();
    //   print(customerList);
    //   print(customerList[1]["Name"]);
    //   setState(() {
    //
    //   });
    // });
    
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Container(
        child: Column(
          children: [
            Text('Package'),
            Text('Name'),
            Text('CardNo'),
            Text('Address'),

          ],
        ),

      ),
    );
  }
}
