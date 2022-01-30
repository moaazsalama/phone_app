import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    UserSheetApi.fetchAnalysisTypes().then((value) => typesList = value);

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
                  Text(
                    AppLocalizations.of(context)!.therecentorders,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: getProportionScreenration(20),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: Provider.of<Orders>(context, listen: false)
                    .fetchAllOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    final List<OrderItem> request = [];
                    if (snapshot.data!.docs.isEmpty) return Container();
                    docs.forEach((element) {
                      final orderItem = OrderItem.fromMap(element.data());
                      request.add(orderItem);
                    });
                    print(request.length);

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: request.isEmpty
                            ? Center(
                                child: Text(
                                  AppLocalizations.of(context)!.noorders,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: getProportionScreenration(24),
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
                      ), //hh
                    );
                  } else {
                    return Container();
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${request.totalPrice}\$',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(DateFormat('dd/MM/yyyy').format(request.dateTime)),
          ],
        ),
        subtitle: Text('عدد المنتجات ${request.analysis.length}'),
        children: request.analysis.map((product) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.analysisname,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.analysis.name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                if (product.passportImageUrl != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          product.passportImageUrl!,
                          fit: BoxFit.cover,
                          width: getProportionateScreenWidth(100),
                          height: getProportionateScreenHeight(100),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Image',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.price,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      product.analysis.price,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                if (product.flightLine != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.flightline,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        product.flightLine!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.result,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (product.resultUrl != null)
                      TextButton(
                          onPressed: () {
                            launch(product.resultUrl!);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.result,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ))
                    else
                      Text(
                        AppLocalizations.of(context)!.noresults,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 10,
                  color: Colors.black,
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
