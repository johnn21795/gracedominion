import 'dart:collection';

import 'package:gracedominion/Classes/MainClass.dart';
import 'package:flutter/material.dart';

import '../Classes/ModelClass.dart';
import 'CustomerProfile.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class CustomerStatus {
  final String card;
  final String name;
  final String phone;
  final String address;
  final String package;
  final String status;
  final String total;
  final String paid;
  final int photo;
  late String percentage;

  CustomerStatus(
    this.card,
    this.name,
    this.phone,
    this.address,
    this.package,
    this.status,
    this.photo,
    this.total,
    this.paid,
  );
}

class _CustomersState extends State<Customers> {
  String? status = "Active";
  static late CustomerStatus selectedCustomer;
  static List<CustomerStatus> selectedCustomerList = <CustomerStatus>[];

  static final List<CustomerStatus> data = <CustomerStatus>[];
  static final List<CustomerStatus> active = <CustomerStatus>[];
  static final List<CustomerStatus> inActive = <CustomerStatus>[];
  static final List<CustomerStatus> neglected = <CustomerStatus>[];
  static final List<CustomerStatus> away = <CustomerStatus>[];

  int activeCustomers = 0;
  int inActiveCustomers = 0;
  int neglectedCustomers = 0;
  int awayCustomers = 0;

  static Map<String, Color> backgroundColor = HashMap<String, Color>();
  static Map<String, Color> statusColor = HashMap<String, Color>();

  ScrollController scrollController = ScrollController();
  bool showScrollToTop = false;
  // static int maxList = 10;

  @override
  void initState() {
    super.initState();

    // scrollController.addListener(() {
    //   if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
    //     if(selectedCustomerList.length - maxList > 0){
    //       int diff = selectedCustomerList.length - maxList;
    //       loadMoreData(diff> 10? 10 : diff);
    //     }
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.minScrollExtent + 200) {
        if (!showScrollToTop) {
          showScrollToTop = true;
          setState(() {});
        }
      }
      if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) {
        showScrollToTop = false;
        setState(() {});
      }
    });

    //   }
    // });
    backgroundColor.addAll({'INACTIVE': const Color(0xfffeffed)});
    backgroundColor.addAll({'ACTIVE': const Color(0xfff0ffed)});
    backgroundColor.addAll({'NEGLECTED': const Color(0xffffeded)});
    backgroundColor.addAll({'AWAY': const Color(0xffedeeff)});

    statusColor.addAll({'INACTIVE': const Color(0xffa5a500)});
    statusColor.addAll({'ACTIVE': const Color(0xff127b00)});
    statusColor.addAll({'NEGLECTED': const Color(0xffc50000)});
    statusColor.addAll({'AWAY': const Color(0xff484f5f)});
    selectedCustomerList = active;
  }

  //  void loadMoreData(int rows){
  //   maxList +=rows;
  //   print("Loading More Data...");
  //   setState(() {
  //   });
  // }
  LoadCustomersList lc = LoadCustomersList();
  @override
  Widget build(BuildContext context) {
    int totalCustomers = data.length;
    activeCustomers = LoadCustomersList.activeCustomers;
    inActiveCustomers = LoadCustomersList.inActiveCustomers;
    neglectedCustomers = LoadCustomersList.neglectedCustomers;
    awayCustomers = LoadCustomersList.awayCustomers;
    // maxList > selectedCustomerList.length? maxList = selectedCustomerList.length : maxList = maxList;
    // maxList = selectedCustomerList.length;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: MySearchDelegate());
        },
        child: const Icon(Icons.search),
      ),
      body: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Stack(children: [
            Stack(
                children:[
                  Padding(
                    padding:  EdgeInsets.only(top:screenSize.height / 4),
                      child:
                      ListView.builder(itemCount: selectedCustomerList.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical:5),
                            child: InkWell(
                              splashColor: Colors.red.withOpacity(0.3),
                              onTap: ()async {
                                LoadCustomersList lc = LoadCustomersList();
                                selectedCustomer = selectedCustomerList[index];
                                Map<String, String> result =  await lc.loadCustomersInfo(selectedCustomer.card.toUpperCase());
                                await Navigator.push(context, MaterialPageRoute(
                                    builder:(context) =>
                                        CustomerProfile(customerInfo:result))
                                );
                                if(!MainClass.isCustomersLoaded){
                                  await lc.clearCustomerInfo().then((value) =>   setState((){}));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color(0x33000000),
                                          offset: Offset(1.0, 2.0),
                                          blurRadius: 1.0,
                                          spreadRadius: 1.5
                                      )
                                    ],
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color: backgroundColor.putIfAbsent(selectedCustomerList[index].status, () => const Color(0x00000000))
                                ),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                                          child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                border: Border.all(width: 1.0, color:  backgroundColor.putIfAbsent(selectedCustomerList[index].status, () => const Color(0x00000000)), strokeAlign: BorderSide.strokeAlignOutside),
                                              ),
                                              child: MainClass.getProfilePic(selectedCustomerList[index].photo, selectedCustomerList[index].card.toUpperCase(), context)
                                          ),
                                        ),
                                        SizedBox(
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:  CrossAxisAlignment.start,
                                            children: const [
                                              Icon(Icons.credit_card_rounded, color: Color(0xba000000),size: 15,),
                                              Icon(Icons.account_circle, color: Color(0xba000000), size: 15,),
                                              Icon(Icons.phone, color: Color(0xba000000), size: 15,),
                                              Icon(Icons.card_giftcard, color: Color(0xba000000), size: 15,),
                                              Icon(Icons.location_on_sharp, color: Color(0xba000000), size: 15,),


                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Expanded(
                                          child: SizedBox(
                                            width: 200,
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [
                                                Text(selectedCustomerList[index].card, style: TextStyle( fontSize: 12, color: const Color(0xff000000), fontFamily: 'Claredon', fontWeight: FontWeight.w600), ),
                                                Text(MainClass.returnTitleCase(selectedCustomerList[index].name), style: TextStyle( fontSize: 12,fontFamily: 'Claredon',), ),
                                                Text(selectedCustomerList[index].phone, style: TextStyle( fontSize: 12,fontFamily: 'Claredon',), ),
                                                Text(selectedCustomerList[index].package, style: TextStyle( fontSize: 12,fontFamily: 'Claredon',), ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: 8.0),
                                                  child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(MainClass.returnTitleCase(selectedCustomerList[index].address), style: TextStyle( fontSize: 12, fontFamily: 'Claredon',), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(right: 10, top: 5, child: Text(MainClass.returnTitleCase(selectedCustomerList[index].status), style: TextStyle( fontSize: 12, fontFamily: 'Claredon', fontWeight: FontWeight.bold, color: statusColor.putIfAbsent(selectedCustomerList[index].status.toUpperCase(), () => const Color(0xff000000))  ), ),),
                                    // Positioned(right: 10, bottom: 23, child: Text(selectedCustomerList[index].percentage+"%", style: TextStyle( fontSize: 12, fontFamily: 'Claredon', fontWeight: FontWeight.bold, color: statusColor.putIfAbsent(selectedCustomerList[index].status.toUpperCase(), () => const Color(0xff000000))  ), ),),
                                    Positioned(left: 6, top: 3, child: Text((index+1).toString()+".", style: const TextStyle( fontSize: 6,  fontWeight: FontWeight.bold, color:  Color(0x55000000)  ), ),)

                                  ],
                                ),
                              ),
                            ),
                          );

                        },
                      ),
                  ),
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      transform: Matrix4.translationValues(0, 0, 0),
                      height: screenSize.height / 3.2,
                      width: screenSize.width,
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/backgrounds/greenDark.jpg'),
                              fit: BoxFit.fill,
                              opacity: 0.3,
                              colorFilter: ColorFilter.mode(
                                  Colors.black, BlendMode.colorDodge)))
                      ,child:
                    Stack(
                      children: [
                        Positioned(
                          top: 30,
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
                        Positioned(
                            top: screenSize.height / 10,
                            left: screenSize.width / 2.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Total Customers: ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 1.5,
                                        fontFamily: 'condensed')),
                                Text(totalCustomers.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: 'Majoris')),
                              ],
                            )),
                        Positioned(
                            top: screenSize.height / 5.6,
                            left: 15,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Active: ',
                                    style: TextStyle(
                                      color: Colors.green[200],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    )),
                                Text(activeCustomers.toString(),
                                    style:
                                    TextStyle(color: Colors.green[100], fontSize: 13)),
                              ],
                            )),
                        Positioned(
                            top: screenSize.height / 5,
                            left: 15,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('InActive: ',
                                    style: TextStyle(
                                        color: Colors.yellow[200],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                Text(inActiveCustomers.toString(),
                                    style:
                                    TextStyle(color: Colors.yellow[200], fontSize: 13)),
                              ],
                            )),
                        Positioned(
                            top: screenSize.height / 5.6,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Neglected: ',
                                    style: TextStyle(
                                        color: Colors.red[200],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                Text(neglectedCustomers.toString(),
                                    style: TextStyle(color: Colors.red[200], fontSize: 13)),
                              ],
                            )),
                        Positioned(
                            top: screenSize.height / 5,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Away: ',
                                    style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                Text(awayCustomers.toString(),
                                    style:
                                    TextStyle(color: Colors.grey[200], fontSize: 13)),
                              ],
                            )),
                        Positioned(
                          top: 25,
                          right: 20,
                          child: DropdownButton(
                            iconEnabledColor: Colors.white,
                            dropdownColor: Colors.green[800],
                            focusColor: Colors.white,
                            hint: const Text(
                              "Status",
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            value: status,
                            items:
                            <String>["All", "Active", "InActive", "Neglected", "Away"]
                                .map((status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(
                                status,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ))
                                .toList(),
                            onChanged: (String? value) {
                              status = value;
                              switch (value) {
                                case "Active":
                                  selectedCustomerList = active;
                                  break;
                                case "InActive":
                                  selectedCustomerList = inActive;
                                  break;
                                case "Neglected":
                                  selectedCustomerList = neglected;
                                  break;
                                case "Away":
                                  selectedCustomerList = away;
                                  break;
                                default:
                                  selectedCustomerList = data;
                                  break;
                              }
                              scrollController.position.animateTo(
                                  scrollController.position.pixels - 10,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease);
                              setState(() {});
                            },
                          ),
                        )

                      ],),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Visibility(
                      visible: showScrollToTop,
                      child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0x44000000)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 3.0, bottom: 2),
                            child: IconButton( icon: Icon(Icons.keyboard_arrow_up_rounded, size: 35, color: Colors.green[700],), onPressed: () {  scrollController.position.animateTo(scrollController.position.minScrollExtent, duration:  Duration(seconds: (selectedCustomerList.length/10).ceil() > 5 ? 5: (selectedCustomerList.length/10).ceil()), curve: Curves.ease);  },),
                          )),
                    ),)

                ]

            ),



          ])),
    );
  }

  // Image getProfilePic(int profile, String cardNo){
  //    if(profile == 0){
  //      return  const Image(image: AssetImage('assets/images/placeholder.jpg',), fit: BoxFit.cover,);
  //    }else{
  //      if(File("${MainClass.customerImagesPath}$cardNo.png").existsSync()){
  //        return Image.file(File("${MainClass.customerImagesPath}$cardNo.png"), fit: BoxFit.cover,) ;
  //      }else{
  //        return const Image(image: AssetImage('assets/images/placeholder.jpg',), fit: BoxFit.cover,);
  //      }
  //    }
  // }

}

class MySearchDelegate extends SearchDelegate {
  ScrollController scrollController = ScrollController();
  static late CustomerStatus selectedCustomer;
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => {
            query.isEmpty ? close(context, null) : query = '',
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  late List<CustomerStatus> queryResult;
  Future<List<CustomerStatus>> searchCustomer() async {
    queryResult = [];
    String sql =
        "SELECT CardNo,Name,Phone,Address,CardPackage,Status,Photo,TotalAmtPayable,TotalAmtPaid FROM Customers WHERE"
        " Name lIKE '%${query == "" ? "NoQuery" : query}%'"
        " or Phone lIKE '%${query == "" ? "NoQuery" : query}%'"
        " or Address lIKE '%${query == "" ? "NoQuery" : query}%'"
        " or CardPackage lIKE '%${query == "" ? "NoQuery" : query}%'"
        " or CardNo lIKE '%${query == "" ? "NoQuery" : query}%'"
        " Order by Name ";

    await MainClass.readDB(sql, []).then((data) => {
          queryResult.clear(),
          if (data.isNotEmpty)
            {
              for (int x = 0; x < data.length; x++)
                {
                  queryResult.add(CustomerStatus(
                      data.elementAt(x).col1!,
                      data.elementAt(x).col2!,
                      data.elementAt(x).col3!,
                      data.elementAt(x).col4!,
                      data.elementAt(x).col5!,
                      data.elementAt(x).col6!,
                      int.parse(data.elementAt(x).col7!),
                      data.elementAt(x).col8!,
                      data.elementAt(x).col9!)),
                }
            }
        });
    // Future.delayed(const Duration(milliseconds: 300));
    // queryResult.add(CustomerStatus("2180GH", "James", "1234567", "Alaba", "Stage 3", "ACTIVE", 1, "31000", "10000"));
    // queryResult.add(CustomerStatus("519E", "John", "1234567", "Ojo", "Stage 4", "AWAY", 1, "31000", "10000"));
    // queryResult.add(CustomerStatus("831J", "Mike", "1234567", "Alaba", "Stage 5", "INACTIVE", 0, "31000", "10000"));
    // queryResult.add(CustomerStatus("235J", "Athena", "1234567", "Alaba", "Stage 6", "NEGLECTED", 0, "31000", "10000"));
    return queryResult;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: searchCustomer(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Column(
                children: const [
                  Icon(
                    Icons.error,
                    size: 30,
                    color: Colors.grey,
                  ),
                  Text(
                    "No Records Found",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              );
            case ConnectionState.waiting:
              queryResult = queryResult.isEmpty
                  ? snapshot.data != null
                      ? snapshot.data as List<CustomerStatus>
                      : queryResult
                  : queryResult;
              return Container(
                transform: Matrix4.translationValues(0, 25, 0),
                child: ListView.builder(
                  itemCount: queryResult.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Material(
                        child: InkWell(
                          splashColor: Colors.red.withOpacity(0.3),
                          onTap: () async {
                            LoadCustomersList lc = LoadCustomersList();
                            selectedCustomer = queryResult[index];
                            Map<String, String> result =
                                await lc.loadCustomersInfo(
                                    selectedCustomer.card.toUpperCase());
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerProfile(customerInfo: result)));
                            // if(!MainClass.isCustomersLoaded){
                            //   await lc.clearCustomerInfo().then((value) =>   setState((){}));
                            // }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x33000000),
                                      offset: Offset(1.0, 2.0),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.5)
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: _CustomersState.backgroundColor
                                    .putIfAbsent(queryResult[index].status,
                                        () => const Color(0x00000000))),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 7),
                                      child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            border: Border.all(
                                                width: 1.0,
                                                color: _CustomersState
                                                    .backgroundColor
                                                    .putIfAbsent(
                                                        queryResult[index]
                                                            .status,
                                                        () => const Color(
                                                            0x00000000)),
                                                strokeAlign:
                                                    BorderSide.strokeAlignOutside),
                                          ),
                                          child: MainClass.getProfilePic(
                                              queryResult[index].photo,
                                              queryResult[index]
                                                  .card
                                                  .toUpperCase(),
                                              context)),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Icon(
                                            Icons.credit_card_rounded,
                                            color: Color(0xba000000),
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.account_circle,
                                            color: Color(0xba000000),
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.phone,
                                            color: Color(0xba000000),
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.card_giftcard,
                                            color: Color(0xba000000),
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.location_on_sharp,
                                            color: Color(0xba000000),
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 200,
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              queryResult[index].card,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontFamily: 'Claredon',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              MainClass.returnTitleCase(
                                                  queryResult[index].name),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Claredon',
                                              ),
                                            ),
                                            Text(
                                              queryResult[index].phone,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Claredon',
                                              ),
                                            ),
                                            Text(
                                              queryResult[index].package,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Claredon',
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    MainClass.returnTitleCase(
                                                        queryResult[index]
                                                            .address),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Claredon',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 10,
                                  top: 5,
                                  child: Text(
                                    MainClass.returnTitleCase(
                                        queryResult[index].status),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Claredon',
                                        fontWeight: FontWeight.bold,
                                        color: _CustomersState.statusColor
                                            .putIfAbsent(
                                                queryResult[index]
                                                    .status
                                                    .toUpperCase(),
                                                () => const Color(0xff000000))),
                                  ),
                                ),
                                // Positioned(right: 10, bottom: 23, child: Text(selectedCustomerList[index].percentage+"%", style: TextStyle( fontSize: 12, fontFamily: 'Claredon', fontWeight: FontWeight.bold, color: statusColor.putIfAbsent(selectedCustomerList[index].status.toUpperCase(), () => const Color(0xff000000))  ), ),),
                                Positioned(
                                  left: 6,
                                  top: 3,
                                  child: Text(
                                    (index + 1).toString() + ".",
                                    style: const TextStyle(
                                        fontSize: 6,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0x55000000)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            case ConnectionState.done:
            default:
              return Stack(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
                  child: Text(
                    "${queryResult.length} Results",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0, 25, 0),
                  child: ListView.builder(
                    itemCount: queryResult.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Material(
                          child: InkWell(
                            splashColor: Colors.red.withOpacity(0.3),
                            onTap: () async {
                              LoadCustomersList lc = LoadCustomersList();
                              _CustomersState.selectedCustomer =
                                  queryResult[index];
                              Map<String, String> result =
                                  await lc.loadCustomersInfo(_CustomersState
                                      .selectedCustomer.card
                                      .toUpperCase());

                              print(result);
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomerProfile(
                                          customerInfo: result)));
                              // if(!MainClass.isCustomersLoaded){
                              //   await lc.clearCustomerInfo().then((value) =>   setState((){}));
                              // }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color(0x33000000),
                                        offset: Offset(1.0, 2.0),
                                        blurRadius: 1.0,
                                        spreadRadius: 1.5)
                                  ],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: _CustomersState.backgroundColor
                                      .putIfAbsent(queryResult[index].status,
                                          () => const Color(0x00000000))),
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 7),
                                        child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color: _CustomersState
                                                      .backgroundColor
                                                      .putIfAbsent(
                                                          queryResult[index]
                                                              .status,
                                                          () => const Color(
                                                              0x00000000)),
                                                  strokeAlign:
                                                      BorderSide.strokeAlignOutside),
                                            ),
                                            child: MainClass.getProfilePic(
                                                queryResult[index].photo,
                                                queryResult[index]
                                                    .card
                                                    .toUpperCase(),
                                                context)),
                                      ),
                                      SizedBox(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Icon(
                                              Icons.credit_card_rounded,
                                              color: Color(0xba000000),
                                              size: 15,
                                            ),
                                            Icon(
                                              Icons.account_circle,
                                              color: Color(0xba000000),
                                              size: 15,
                                            ),
                                            Icon(
                                              Icons.phone,
                                              color: Color(0xba000000),
                                              size: 15,
                                            ),
                                            Icon(
                                              Icons.card_giftcard,
                                              color: Color(0xba000000),
                                              size: 15,
                                            ),
                                            Icon(
                                              Icons.location_on_sharp,
                                              color: Color(0xba000000),
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                queryResult[index].card,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontFamily: 'Claredon',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                MainClass.returnTitleCase(
                                                    queryResult[index].name),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Claredon',
                                                ),
                                              ),
                                              Text(
                                                queryResult[index].phone,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Claredon',
                                                ),
                                              ),
                                              Text(
                                                queryResult[index].package,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Claredon',
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      MainClass.returnTitleCase(
                                                          queryResult[index]
                                                              .address),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'Claredon',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 5,
                                    child: Text(
                                      MainClass.returnTitleCase(
                                          queryResult[index].status),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Claredon',
                                          fontWeight: FontWeight.bold,
                                          color: _CustomersState.statusColor
                                              .putIfAbsent(
                                                  queryResult[index]
                                                      .status
                                                      .toUpperCase(),
                                                  () =>
                                                      const Color(0xff000000))),
                                    ),
                                  ),
                                  // Positioned(right: 10, bottom: 23, child: Text(selectedCustomerList[index].percentage+"%", style: TextStyle( fontSize: 12, fontFamily: 'Claredon', fontWeight: FontWeight.bold, color: statusColor.putIfAbsent(selectedCustomerList[index].status.toUpperCase(), () => const Color(0xff000000))  ), ),),
                                  Positioned(
                                    left: 6,
                                    top: 3,
                                    child: Text(
                                      (index + 1).toString() + ".",
                                      style: const TextStyle(
                                          fontSize: 6,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0x55000000)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]);
          }
        });

    // return ListView.builder(
    //     itemCount: suggest.length,
    //     itemBuilder: (context, index) {
    //       final q = suggest[index];
    //       return ListTile(
    //         title: Text(q),
    //         onTap: (){},
    //       );
    // },
    // );
  }
}

class LoadCustomersList {
  static int activeCustomers = 0;
  static int inActiveCustomers = 0;
  static int neglectedCustomers = 0;
  static int awayCustomers = 0;

  void sortData(ModelClassLarge data) {
    CustomerStatus c = CustomerStatus(
        data.col1!,
        data.col2!,
        data.col3!,
        data.col4!,
        data.col5!,
        data.col6!,
        int.parse(data.col7!),
        data.col8!,
        data.col9!);
    // try {
    //   c.percentage = (int.parse(data.col8!) / int.parse(data.col9!)*100).floor().toString();
    //   print("Percentage "+ c.percentage);
    // } catch (e) {
    //   c.percentage = "0";
    // }
    String? stat = data.col6;
    switch (stat) {
      case "INACTIVE":
        _CustomersState.inActive.add(c);
        inActiveCustomers++;
        break;
      case "ACTIVE":
        _CustomersState.active.add(c);
        activeCustomers++;
        break;
      case "Active":
        _CustomersState.active.add(c);
        activeCustomers++;
        break;
      case "NEGLECTED":
        _CustomersState.neglected.add(c);
        neglectedCustomers++;
        break;
      case "AWAY":
        _CustomersState.away.add(c);
        awayCustomers++;
        break;
    }
  }

  Future<bool> loadCustomers() async {
    String sql =
        "SELECT CardNo,Name,Phone,Address,CardPackage,Status,Photo,TotalAmtPayable,TotalAmtPaid FROM Customers Order by Name ";
    Future<List<ModelClassLarge>> callback = MainClass.readDB(sql, []);
    await callback.then((value) => {
          if (value.isNotEmpty)
            {
              for (int x = 0; x < value.length; x++)
                {
                  sortData(value.elementAt(x)),
                },
            },
        });

    _CustomersState.data.addAll(_CustomersState.active);
    _CustomersState.data.addAll(_CustomersState.inActive);
    _CustomersState.data.addAll(_CustomersState.neglected);
    _CustomersState.data.addAll(_CustomersState.away);
    MainClass.isCustomersLoaded = true;
    return MainClass.isCustomersLoaded;
  }

  static Future<List<CustomerStatus>> searchCustomers(String query) async {
    List<CustomerStatus> result = [];
    ModelClassLarge data;
    String sql =
        "SELECT CardNo,Name,Phone,Address,CardPackage,Status,Photo,TotalAmtPayable,TotalAmtPaid FROM Customers WHERE "
        "CardNo Like '% $query %' "
        " OR Name Like '% $query %' "
        " OR Phone Like '% $query %' "
        " OR Address Like '% $query %' "
        " OR CardPackage Like '% $query %' ";
    Future<List<ModelClassLarge>> callback = MainClass.readDB(sql, []);
    await callback.then((value) => {
          if (value.isNotEmpty)
            {
              for (int x = 0; x < value.length; x++)
                {
                  data = value.elementAt(x),
                  result.add(CustomerStatus(
                      data.col1!,
                      data.col2!,
                      data.col3!,
                      data.col4!,
                      data.col5!,
                      data.col6!,
                      int.parse(data.col7!),
                      data.col8!,
                      data.col9!))
                },
            },
        });

    return result;
  }

  Future<Map<String, String>> loadCustomersInfo(String card) async {
    Map<String, String> customerDetails = HashMap<String, String>();
    customerDetails.putIfAbsent(
        "CardNo", () => _CustomersState.selectedCustomer.card);
    customerDetails.putIfAbsent(
        "Name", () => _CustomersState.selectedCustomer.name);
    customerDetails.putIfAbsent(
        "Phone", () => _CustomersState.selectedCustomer.phone);
    customerDetails.putIfAbsent(
        "Address", () => _CustomersState.selectedCustomer.address);
    customerDetails.putIfAbsent(
        "CardPackage", () => _CustomersState.selectedCustomer.package);
    customerDetails.putIfAbsent(
        "Status", () => _CustomersState.selectedCustomer.status);
    customerDetails.putIfAbsent(
        "Photo", () => _CustomersState.selectedCustomer.photo.toString());
    customerDetails.putIfAbsent("TotalAmtPayable",
        () => _CustomersState.selectedCustomer.total.toString());
    customerDetails.putIfAbsent(
        "TotalAmtPaid", () => _CustomersState.selectedCustomer.paid.toString());

    String sql =
        "SELECT DateOfReg,CardType,Amount,Period,LastMark FROM Customers WHERE CardNo = ?";
    Future<List<ModelClassLarge>> callback = MainClass.readDB(sql, [card]);
    await callback.then((value) => {
          if (value.isNotEmpty)
            {
              customerDetails.putIfAbsent(
                  "DateOfReg", () => value.elementAt(0).col1.toString()),
              customerDetails.putIfAbsent(
                  "CardType", () => value.elementAt(0).col2.toString()),
              customerDetails.putIfAbsent(
                  "Amount", () => value.elementAt(0).col3.toString()),
              customerDetails.putIfAbsent(
                  "Period", () => value.elementAt(0).col4.toString()),
              customerDetails.putIfAbsent(
                  "LastMark", () => value.elementAt(0).col5.toString()),
            }
        });
    return customerDetails;
  }

  Future<bool> clearCustomerInfo() async {
    activeCustomers = 0;
    inActiveCustomers = 0;
    neglectedCustomers = 0;
    awayCustomers = 0;
    MainClass.isCustomersLoaded = false;
    _CustomersState.active.clear();
    _CustomersState.inActive.clear();
    _CustomersState.neglected.clear();
    _CustomersState.away.clear();
    _CustomersState.data.clear();
    return await loadCustomers();
  }

  LoadCustomersList();
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
