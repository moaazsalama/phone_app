// ignore_for_file: unused_import

import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/models/analyzer.dart';
import 'package:phone_lap/pages/blood_page.dart';
import 'package:phone_lap/pages/collection_page.dart';
import 'package:phone_lap/pages/confirm_page.dart';
import 'package:phone_lap/pages/orders_page.dart';
import 'package:phone_lap/pages/pcr_data_page.dart';
import 'package:phone_lap/pages/prescription_data.dart';
import 'package:phone_lap/pages/search_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';
import 'package:phone_lap/providers/languagesprovider.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:phone_lap/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import 'blood_analysis_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home-Page';
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder<Analyzer?>(
        future:
            Provider.of<AnalyzerProvider>(context, listen: false).getAnalyzer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            // ignore: prefer_const_constructors
            return Center(
              child: const CircularProgressIndicator(),
            );
          else if (snapshot.hasData) {
            final user = snapshot.data!;
            return Stack(
              children: [
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
                  crossAxisAlignment:
                      Provider.of<LanguageChangeProvider>(context)
                                  .current!
                                  .languageCode ==
                              'ar'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: getProportionateScreenHeight(160),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            child: IconButton(
                                onPressed: () {
                                  scaffoldKey.currentState!.openDrawer();
                                },
                                icon: Icon(
                                  Icons.menu_outlined,
                                  color: Colors.white,
                                  size: getProportionScreenration(30),
                                )),
                            left: Provider.of<LanguageChangeProvider>(context)
                                        .current!
                                        .languageCode ==
                                    'en'
                                ? getProportionateScreenWidth(5)
                                : null,
                            top: getProportionateScreenHeight(15),
                            right: Provider.of<LanguageChangeProvider>(context)
                                        .current!
                                        .languageCode ==
                                    'ar'
                                ? getProportionateScreenWidth(5)
                                : null,
                          ),
                          Positioned(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, SearchPage.routeName);
                                },
                                icon: Icon(
                                  Icons.search_outlined,
                                  color: Colors.white,
                                  size: getProportionScreenration(30),
                                )),
                            right: Provider.of<LanguageChangeProvider>(context)
                                        .current!
                                        .languageCode ==
                                    'en'
                                ? getProportionateScreenWidth(5)
                                : null,
                            top: getProportionateScreenHeight(15),
                            left: Provider.of<LanguageChangeProvider>(context)
                                        .current!
                                        .languageCode ==
                                    'ar'
                                ? getProportionateScreenWidth(5)
                                : null,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.white)),
                                    padding: const EdgeInsets.all(2),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: CircleAvatar(
                                      child: Image.asset(
                                          user.gender
                                              ? 'assets/icon/business-man.png'
                                              : 'assets/icon/woman.png',
                                          fit: BoxFit.cover),
                                      radius: getProportionScreenration(30),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(20),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${user.name}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                getProportionScreenration(24),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      Text(
                                        '${user.phone}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              getProportionScreenration(16),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                    Container(
                      //     height: getProportionateScreenHeight(100),
                      margin: const EdgeInsets.only(top: 5, left: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: getChild()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: showAnalysis(context),
                      ),
                    ),
                    Row(
                      children: [
                        Item(
                          onPressed: () async {
                            try {
                              final analysis = Analysis(
                                  name: 'Package Corona',
                                  price: '70LE',
                                  analysisType: 'PCR');
                              final user = Provider.of<AnalyzerProvider>(
                                      context,
                                      listen: false)
                                  .analyzer;
                              final orderItem = OrderItem(
                                  analysis: analysis,
                                  user: user!,
                                  id: 'id',
                                  dateTime: DateTime.now(),
                                  isDeliverd: 'no');

                              await Provider.of<Orders>(context, listen: false)
                                  .sendOrder(orderItem, 'pcrNormal');

                              showToast(
                                AppLocalizations.of(context)!.requestsuccessful,
                                duration: const Duration(seconds: 2),
                                position: ToastPosition.center,
                                backgroundColor: Colors.black.withOpacity(0.8),
                                radius: 3.0,
                                textStyle: TextStyle(
                                    fontSize: getProportionScreenration(20.0)),
                              );
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
                          text: 'Package Corona',
                        ),
                        Item(
                          onPressed: () {},
                          text: 'Lipid Profile',
                        ),
                      ],
                    ),
                    if (SizeConfig.screenHeight > 600)
                      Expanded(
                          child: FutureBuilder<Map<String, dynamic>>(
                              future: UserSheetApi.slider(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return const Center(
                                      child: CircularProgressIndicator());
                                else if (snapshot.hasData) {
                                  return CarouselSlider.builder(
                                    options: CarouselOptions(
                                      height: 400.0,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      onPageChanged: (index, reason) {},
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    itemBuilder: (context, index, realIndex) {
                                      final List<AnalysisType> types =
                                          snapshot.data!['analysisType'];
                                      final List<Analysis> allAnalysis =
                                          snapshot.data!['analysis'];
                                      final current =
                                          allAnalysis.where((element) {
                                        return element.analysisType ==
                                            types[index].key;
                                      }).toList();
                                      return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${types[index].anaysisType}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            getProportionScreenration(
                                                                20.0),
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                      child: InkWell(
                                                    onTap: () => Navigator.of(
                                                            context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          CollectionPage(
                                                              analysisList:
                                                                  current,
                                                              analysisType:
                                                                  types[index]),
                                                    )),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      child: ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return AnalysisItemHome(
                                                            current[index],
                                                          );
                                                        },
                                                        itemCount:
                                                            current.length,
                                                      ),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                    itemCount:
                                        snapshot.data!['analysisType'].length,
                                  );
                                } else
                                  return Center(
                                    child: Text(AppLocalizations.of(context)!
                                        .noconnection),
                                  );
                              }))
                  ],
                ),
              ],
            );
          } else {
            return Center(
              child: TextButton(
                child: Text(AppLocalizations.of(context)!.noconnection),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            );
          }
        },
      ),
      drawer: MainDrawer(),
    );
  }

  List<Widget> showAnalysis(context) {
    final List<Map<String, dynamic>> analysisNames = [
      {
        'name': AppLocalizations.of(context)!.bloodanalysis,
        'color': Colors.red,
        'icon': Icons.bloodtype_outlined,
        'onPressed': () {
          Navigator.of(context).pushNamed(BloodPage.routeName);
        }
      },
      {
        'name': AppLocalizations.of(context)!.pcranalysis,
        'color': Colors.blue,
        'icon': Icons.coronavirus_outlined,
        'onPressed': () {
          Navigator.of(context).pushNamed(ConfirmPage.routeName);
        }
      },
      {
        'name': AppLocalizations.of(context)!.attachprescription,
        'color': Colors.grey,
        'icon': Icons.photo_outlined,
        'onPressed': () {
          Navigator.pushNamed(context, PrescriptionData.routeName);
        }
      },
    ];
    return List.generate(
        analysisNames.length,
        (index) => Container(
              // height: getProportionateScreenHeight(60),
              margin: const EdgeInsets.all(5),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      analysisNames[index]['color'].withOpacity(.9),
                      analysisNames[index]['color'],
                      analysisNames[index]['color'].withOpacity(.7)
                    ],
                  ),
                  borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(15))),
              //        height: getProportionateScreenHeight(120),

              child: ListTile(
                onTap: analysisNames[index]['onPressed'],
                title: Text(
                  analysisNames[index]['name'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionScreenration(24),
                      fontWeight: FontWeight.bold),
                ),
                leading: Icon(
                  analysisNames[index]['icon'],
                  color: Colors.white,
                  size: getProportionScreenration(40),
                ),
                trailing: Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.white,
                  size: getProportionScreenration(16),
                ),
              ),
            ));
  }

  List<Widget> getChild() {
    if (Provider.of<LanguageChangeProvider>(context).current!.languageCode !=
        'ar')
      return [
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.availableanalysis,
            textAlign: TextAlign.justify,
            style: const TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(5)),
            child: Button(
              titleSize: getProportionScreenration(20),
              title: '${AppLocalizations.of(context)!.myanalysis}',
              //  titleSize: 10,
              onPressed: () async {
                Navigator.pushNamed(context, OrdersPage.routeName);
              },
              height: getProportionateScreenHeight(60),
              width: getProportionateScreenWidth(180),
              padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
            ),
          ),
        ),
      ];
    else
      return [
        Expanded(
          child: TextButton(
            onPressed: () {
              final languageCode =
                  Provider.of<LanguageChangeProvider>(context, listen: false)
                      .current!
                      .languageCode;
              Provider.of<LanguageChangeProvider>(context, listen: false)
                  .changeLocale(languageCode == 'en' ? 'ar' : 'en');
            },
            child: Text(
              AppLocalizations.of(context)!.availableanalysis,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionScreenration(24),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(10)),
            child: Button(
              title: '${AppLocalizations.of(context)!.myanalysis}',
              //  titleSize: 10,
              onPressed: () async {
                Navigator.pushNamed(context, OrdersPage.routeName);
              },
              height: getProportionateScreenHeight(60),
              width: getProportionateScreenWidth(180),
              padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
            ),
          ),
        ),
      ].reversed.toList();
  }
}

class Item extends StatelessWidget {
  final Function() onPressed;
  final String text;

  const Item({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: getProportionateScreenHeight(100),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor),
        alignment: Alignment.center,
        width: SizeConfig.screenWidth / 2 - 20,
        child: Stack(
          children: [
            Positioned(
              left: getProportionateScreenWidth(20),
              top: getProportionateScreenHeight(20),
              child: Text(text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  )),
            ),
            Positioned(
              left: getProportionateScreenWidth(20),
              top: getProportionateScreenHeight(60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(AppLocalizations.of(context)!.requestnow,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String value;
  final String title;
  final Color color;
  final String? imageUrl;
  const CategoryItem({
    Key? key,
    required this.value,
    required this.color,
    required this.title,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.topLeft,
      height: getProportionateScreenHeight(100),
      width: getProportionateScreenWidth(100),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color.withOpacity(0.5), color.withOpacity(0.9)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          if (imageUrl != null)
            Align(
              alignment: Alignment.centerRight,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl!,
                    height: getProportionateScreenHeight(25),
                    width: getProportionateScreenWidth(50),
                  )),
            ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                '$title',
                textAlign: TextAlign.start,
                softWrap: true,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionScreenration(14),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '$value',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionScreenration(18),
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}

class AnalysisItemHome extends StatelessWidget {
  final Analysis analysis;

  const AnalysisItemHome(this.analysis);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        analysis.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: getProportionScreenration(16),
          color: Colors.white,
        ),
        softWrap: true,
        overflow: TextOverflow.fade,
      ),
    );
  }
}
