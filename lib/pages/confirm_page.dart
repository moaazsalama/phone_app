import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/pages/pcr_data_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:provider/provider.dart';

class ConfirmPage extends StatefulWidget {
  static const String routeName = 'confirm-Page';

  const ConfirmPage({Key? key}) : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AnalyzerProvider>(context).analyzer;
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(context);
        return Scaffold(
            body: Stack(
          children: [
            Opacity(
              opacity: 0.2,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/background.PNG'),
                        fit: BoxFit.cover)),
              ),
            ),
            if (!isLoading)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: SizeConfig.orientation == Orientation.portrait
                        ? SizeConfig.screenHeight * 0.15
                        : SizeConfig.screenHeight * 0.25,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)),
                            padding: const EdgeInsets.all(2),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CircleAvatar(
                              child: Image.asset(
                                  user!.gender
                                      ? 'assets/icon/business-man.png'
                                      : 'assets/icon/woman.png',
                                  fit: BoxFit.cover),
                              radius: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(20),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${user.name}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                '${user.phone}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: getProportionateScreenWidth(200),
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: Colors.red[300],
                              borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(15))),
                          child: const Text(
                            'PCR Analysis ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(
                              SizeConfig.orientation == Orientation.portrait
                                  ? 100
                                  : 0),
                        ),
                        if (SizeConfig.orientation == Orientation.portrait)
                          const Center(
                            child: Icon(
                              Icons.coronavirus_outlined,
                              size: 100,
                            ),
                          ),
                        Expanded(
                          child: Container(
                            //      color: Colors.amber,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: SizeConfig.orientation ==
                                          Orientation.portrait
                                      ? SizeConfig.screenWidth * 0.75
                                      : SizeConfig.screenWidth * 0.4,
                                  child: const Text(
                                    'Chose The Reason for Analysis ?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * .01,
                                ),
                                Button(
                                    width: getProportionateScreenWidth(200),
                                    height: getProportionateScreenHeight(70),
                                    title: 'PCR For Reassurance',
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final analysis = Analysis(
                                          name: 'PCR',
                                          price: '70LE',
                                          isNecessary: false,
                                          analysisType: 'PCR');
                                      final user =
                                          Provider.of<AnalyzerProvider>(context,
                                                  listen: false)
                                              .analyzer;
                                      final orderItem = OrderItem(
                                          analysis: analysis,
                                          user: user!,
                                          id: 'id',
                                          dateTime: DateTime.now(),
                                          isDeliverd: 'no');

                                      await Provider.of<Orders>(context,
                                              listen: false)
                                          .sendOrder(orderItem, 'pcrNormal');
                                      Future.delayed(const Duration(seconds: 5),
                                          () {
                                        Navigator.pop(context);
                                        showToast(
                                          'Request Sent Successfuly',
                                          duration: const Duration(seconds: 2),
                                          position: ToastPosition.center,
                                          backgroundColor:
                                              Colors.black.withOpacity(0.8),
                                          radius: 3.0,
                                          textStyle:
                                              const TextStyle(fontSize: 20.0),
                                        );
                                      });
                                    }),
                                SizedBox(
                                  height: SizeConfig.screenHeight * .01,
                                ),
                                Button(
                                    width: getProportionateScreenWidth(200),
                                    height: getProportionateScreenHeight(70),
                                    title: 'PCR For Travling',
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, PcrDataScreen.routName);
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            else
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(20)),
                      child: Image.asset(
                        'assets/img/confirm.png',
                        height: SizeConfig.screenHeight * .3,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            text: 'Our Team Will Call you Soon\n ',
                            children: [
                              TextSpan(
                                  text: user!.gender ? 'Mr ' : 'Mrs ',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text: '${user.name}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900))
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    const CircularProgressIndicator()
                  ],
                ),
              )
          ],
        ));
      },
    );
  }
}