import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../theme.dart';

class OtpPage extends StatefulWidget {
  static String routeName = 'otp-Page';
  const OtpPage({Key? key}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(40),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: const TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(40),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: MyColors.primaryColorLight.withAlpha(20),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: MyColors.primaryColor,
              size: getProportionScreenration(16),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(AppLocalizations.of(context)!.enter,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionScreenration(23),
                              fontWeight: FontWeight.w500))),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        otpNumberWidget(0),
                        otpNumberWidget(1),
                        otpNumberWidget(2),
                        otpNumberWidget(3),
                        otpNumberWidget(4),
                        otpNumberWidget(5),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                constraints: const BoxConstraints(maxWidth: 500),
                child: ElevatedButton(
                  onPressed: () async {
                    final bool =
                        await Provider.of<AuthProvider>(context, listen: false)
                            .signInWithPhoneNumber(text);
                    if (bool)
                      Navigator.pop(context);
                    else
                      showToast(AppLocalizations.of(context)!.codeincorrect,
                          duration: const Duration(seconds: 2),
                          position: ToastPosition.bottom,
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          animationCurve: Curves.easeIn,
                          animationDuration: const Duration(milliseconds: 500),
                          radius: getProportionScreenration(10),
                          textStyle: TextStyle(
                              fontSize: getProportionScreenration(20.0),
                              color: Colors.white),
                          textAlign: TextAlign.center,
                          dismissOtherToast: true);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => MyColors.primaryColor),
                    shape: MaterialStateProperty.resolveWith((states) =>
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14)))),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.confirm,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: MyColors.primaryColorLight,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: getProportionScreenration(16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              NumericKeyboard(
                mainAxisAlignment: MainAxisAlignment.center,
                onKeyboardTap: _onKeyboardTap,
                textColor: MyColors.primaryColorLight,
                rightIcon: const Icon(
                  Icons.backspace,
                  color: MyColors.primaryColorLight,
                ),
                rightButtonFn: () {
                  setState(() {
                    text = text.substring(0, text.length - 1);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
