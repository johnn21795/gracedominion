
import 'package:flutter/material.dart';


class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child: const Text("Inventory Page"),
      )
      ,
    );
  }
}
