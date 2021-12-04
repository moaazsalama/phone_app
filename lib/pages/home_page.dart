// ignore_for_file: unused_import

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analyzer.dart';
import 'package:phone_lap/models/information.dart';
import 'package:phone_lap/pages/blood_page.dart';
import 'package:phone_lap/pages/confirm_page.dart';
import 'package:phone_lap/pages/orders_page.dart';
import 'package:phone_lap/pages/pcr_data_page.dart';
import 'package:phone_lap/pages/prescription_data.dart';
import 'package:phone_lap/pages/search_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:phone_lap/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(200),
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
                                  icon: const Icon(
                                    Icons.menu_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                              left: getProportionateScreenWidth(5),
                              top: getProportionateScreenHeight(15),
                            ),
                            Positioned(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, SearchPage.routeName);
                                  },
                                  icon: const Icon(
                                    Icons.search_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                              right: getProportionateScreenWidth(5),
                              top: getProportionateScreenHeight(15),
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
                                        radius: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(20),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.name}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(10),
                                        ),
                                        Text(
                                          '${user.phone}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
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
                        margin: const EdgeInsets.only(top: 10, left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Avalibale Analysis',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(20),
                                    vertical: getProportionateScreenHeight(10)),
                                child: Button(
                                  title: 'My Analysis',
                                  //  titleSize: 10,
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, OrdersPage.routeName);
                                  },
                                  height: getProportionateScreenHeight(60),
                                  width: getProportionateScreenWidth(180),
                                  padding: const EdgeInsets.only(
                                      right: 5, top: 5, bottom: 5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: showAnalysis(context),
                        ),
                      ),
                      Button(
                        title: 'Attach a presscription',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, PrescriptionData.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: TextButton(
                child: const Text('check Connections'),
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
        'name': 'Blood Analysis',
        'color': Colors.red,
        'icon': Icons.bloodtype_outlined,
        'onPressed': () {
          Navigator.of(context).pushNamed(BloodPage.routeName);
        }
      },
      {
        'name': 'PCR Analysis',
        'color': Colors.blue,
        'icon': Icons.coronavirus_outlined,
        'onPressed': () {
          Navigator.of(context).pushNamed(ConfirmPage.routeName);
        }
      },
    ];
    return List.generate(
        2,
        (index) => Expanded(
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        analysisNames[index]['color'].withOpacity(.9),
                        analysisNames[index]['color'],
                        analysisNames[index]['color'].withOpacity(.7)
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(15))),
                height: getProportionateScreenHeight(120),
                child: InkWell(
                  onTap: analysisNames[index]['onPressed'],
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            analysisNames[index]['icon'],
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          analysisNames[index]['name'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.arrow_forward_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
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
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '$value',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
