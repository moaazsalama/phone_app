import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  static String routeName = 'Orders-Page';
  const OrdersPage({Key? key}) : super(key: key);
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late List<OrderItem> myRequests;
  late List<AnalysisType> typesList;
  @override
  void initState() {
    print('hello');
    UserSheetApi.fetchAnalysisTypes().then((value) => typesList = value);
    print('init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: MyColors.primaryColor,
        body: Stack(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
        ),
        Opacity(
          opacity: 0.2,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/background.PNG'),
                    fit: BoxFit.fitHeight)),
          ),
        ),
        Column(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: getProportionateScreenHeight(80),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  )),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  const Text(
                    'The Recent Analysis',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: Provider.of<Orders>(context).fetchAllOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    final request =
                        List.generate(snapshot.data!.docs.length, (index) {
                      var orderItem =
                          OrderItem.fromMap(snapshot.data!.docs[index].data());
                      orderItem =
                          orderItem.copyWith(id: snapshot.data!.docs[index].id);
                      if (orderItem.user.analyzerId ==
                          Provider.of<AnalyzerProvider>(context, listen: false)
                              .userId) ;
                      return orderItem;
                    });

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: request.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Orders Yet',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return OrderWidget(request: request[index]);
                                },
                                itemCount: request.length,
                              ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ],
    ));
  }
}

class OrderWidget extends StatelessWidget {
  const OrderWidget({
    Key? key,
    required this.request,
  }) : super(key: key);

  final OrderItem request;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        collapsedBackgroundColor:
            request.isDeliverd == 'no' ? Colors.red : Colors.green,
        subtitle: request.travlingCountry == null
            ? null
            : Text(
                request.travlingCountry!,
                textAlign: TextAlign.start,
                softWrap: true,
                style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                request.analysis.name.toUpperCase(),
                textAlign: TextAlign.start,
                softWrap: true,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${DateFormat('y/M/d hh:mm ').add_j().format(request.dateTime)}',
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        expandedAlignment: Alignment.bottomLeft,
        children: [
          if (request.passportImageUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PassPort Image',
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image(
                      image: NetworkImage(
                        request.passportImageUrl!,
                      ),
                      fit: BoxFit.cover,
                      height: getProportionateScreenHeight(80),
                      width: getProportionateScreenWidth(80),
                    ),
                  ),
                ],
              ),
            ),
          if (request.travlingCountry != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Travling Country',
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    request.travlingCountry!,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          if (request.flightLine != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Flight Line',
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    request.flightLine!,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          if (request.flightLine != null)
            Divider(
              color: Theme.of(context).primaryColor,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analysis Name',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  request.analysis.name,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Prcie',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  request.analysis.price,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
