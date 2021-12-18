import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/providers/analyzer.dart';
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
                stream: Provider.of<Orders>(context).fetchAllOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    final docs = snapshot.data!.docs;
                    final List<OrderItem> request = [];

                    docs.forEach((element) {
                      final orderItem = OrderItem.fromMap(element.data());
                      final userId =
                          Provider.of<AnalyzerProvider>(context, listen: false)
                              .userId;
                      if (orderItem.user.analyzerId.contains(userId!))
                        request.add(orderItem);
                    });

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
        subtitle: request.travlingCountry == null
            ? null
            : Text(
                request.travlingCountry!,
                textAlign: TextAlign.start,
                softWrap: true,
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: getProportionScreenration(20),
                    fontWeight: FontWeight.bold),
              ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                request.analysis.name,
                textAlign: TextAlign.start,
                softWrap: true,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionScreenration(20),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${DateFormat('y/M/d hh:mm ').add_j().format(request.dateTime)}',
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionScreenration(14),
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
                  Text(
                    AppLocalizations.of(context)!.passportimage,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionScreenration(14),
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
                  Text(
                    AppLocalizations.of(context)!.travelcountry,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionScreenration(14),
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    request.travlingCountry!,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionScreenration(14),
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
                  Text(
                    AppLocalizations.of(context)!.flightline,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionScreenration(14),
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    request.flightLine!,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionScreenration(14),
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
                Text(
                  AppLocalizations.of(context)!.analysisname,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionScreenration(14),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  request.analysis.name,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionScreenration(14),
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
                Text(
                  AppLocalizations.of(context)!.price,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionScreenration(14),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  request.analysis.price.replaceAll('LE', '') +
                      ' ' +
                      AppLocalizations.of(context)!.le,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionScreenration(14),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (request.resultUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.result,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionScreenration(14),
                        fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        final Uri? tryParse = Uri.tryParse(request.resultUrl!);
                        tryParse!.toString();
                        await launch(request.resultUrl!, forceSafariVC: false);
                      } on Exception {
                        showToast(
                          AppLocalizations.of(context)!.noconnection,
                          duration: const Duration(seconds: 2),
                          position: ToastPosition.center,
                          backgroundColor: Colors.black.withOpacity(0.8),
                          radius: getProportionScreenration(3),
                          textStyle: TextStyle(
                              fontSize: getProportionScreenration(20.0)),
                        );
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.view,
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: getProportionScreenration(16),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
