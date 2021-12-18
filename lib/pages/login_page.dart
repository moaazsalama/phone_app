// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/pages/otp_page.dart';
import 'package:phone_lap/providers/auth.dart';
import 'package:phone_lap/providers/languagesprovider.dart';
import 'package:phone_lap/theme.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static String routeName = 'Login-Page';
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  late String countryCode;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        alignment: Alignment.topLeft,
                        height: getProportionateScreenHeight(200),
                        constraints: BoxConstraints(
                          maxWidth: getProportionateScreenWidth(400),
                        ),
                        child: Consumer<LanguageChangeProvider>(
                          builder: (BuildContext context, value, child) {
                            final selects = <bool>[];
                            selects.add(value.current!.languageCode == 'en'
                                ? true
                                : false);
                            selects.add(value.current!.languageCode == 'en'
                                ? false
                                : true);
                            return ToggleButtons(
                              constraints: BoxConstraints(
                                maxWidth: getProportionateScreenWidth(80),
                                minWidth: getProportionateScreenWidth(40),
                                maxHeight: getProportionateScreenWidth(80),
                                minHeight: getProportionateScreenWidth(40),
                              ),
                              children: const [
                                Text('AR'),
                                Text('EN'),
                              ],
                              isSelected: selects,
                              borderRadius: BorderRadius.circular(60),
                              onPressed: (index) {
                                if (index == 1) {
                                  if (!(value.current!.languageCode == 'en')) {
                                    selects[index] = true;
                                    selects[0] = false;
                                    value.toggleLanguage();
                                  }
                                } else {
                                  if (!(value.current!.languageCode == 'ar')) {
                                    selects[index] = true;
                                    selects[1] = false;
                                    value.toggleLanguage();
                                  }
                                }
                              },
                            );
                          },
                        ),

                        //  margin: const EdgeInsets.only(top: 100),
                        decoration: const BoxDecoration(
                            color: Color(0xFFE1E0F5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                    ),
                    Center(
                      child: Container(
                          constraints: BoxConstraints(
                              maxHeight: getProportionateScreenHeight(200)),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.asset('assets/img/login.png')),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Phone Lap',
                      style: TextStyle(
                          color: MyColors.primaryColor,
                          fontSize: getProportionScreenration(30),
                          fontWeight: FontWeight.bold))),
              Container(
                height: getProportionateScreenHeight(60),
                width: getProportionateScreenWidth(60),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(getProportionScreenration(30)),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/img/logo.png',
                      ),
                    )),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                      maxWidth: getProportionateScreenWidth(250)),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: AppLocalizations.of(context)!.sending,
                          style: TextStyle(
                            color: MyColors.primaryColor,
                            fontSize: getProportionScreenration(18),
                          )),
                      TextSpan(
                          text: AppLocalizations.of(context)!.onetime,
                          style: TextStyle(
                              color: MyColors.primaryColor,
                              fontSize: getProportionScreenration(18),
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: AppLocalizations.of(context)!.mobile,
                          style: TextStyle(
                            color: MyColors.primaryColor,
                            fontSize: getProportionScreenration(18),
                          )),
                    ]),
                  )),
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (value) {
                      countryCode = value.dialCode!;
                    },
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'EG',
                    favorite: const ['+39', 'FR', 'EG'],

                    showFlagDialog: false,
                    comparator: (a, b) => b.name!.compareTo(a.name!),
                    //Get the country information relevant to the initial selection
                    onInit: (code) => countryCode = code!.dialCode!,
                  ),
                  Expanded(
                    child: Container(
                      height: getProportionateScreenHeight(40),
                      constraints: const BoxConstraints(maxWidth: 500),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        controller: phoneController,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                constraints:
                    BoxConstraints(maxWidth: getProportionateScreenWidth(500)),
                child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (phoneController.text.isNotEmpty &&
                        isPhoneNoValid(phoneController.text)) {
                      try {
                        final bool result = await Provider.of<AuthProvider>(
                                context,
                                listen: false)
                            .sendOTP(countryCode + phoneController.text);
                        if (result)
                          Navigator.of(context).pushNamed(OtpPage.routeName);
                      } catch (e) {
                        showToast(
                          e.toString(),
                          duration: const Duration(seconds: 2),
                          position: ToastPosition.center,
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          animationCurve: Curves.easeIn,
                          animationDuration: const Duration(milliseconds: 500),
                          radius: getProportionScreenration(3),
                          textStyle: TextStyle(
                              fontSize: getProportionScreenration(20.0),
                              color: Colors.black),
                        );
                      }
                    } else {
                      showToast(
                          AppLocalizations.of(context)!.unvalidphoneNumber,
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
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => MyColors.primaryColor),
                    shape: MaterialStateProperty.resolveWith((states) =>
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                getProportionScreenration(14))))),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.next,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: getProportionScreenration(24),
                              fontWeight: FontWeight.bold),
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
              Center(
                  child: Text(
                AppLocalizations.of(context)!.signwithGoogle,
                style: TextStyle(fontSize: getProportionScreenration(18)),
              )),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                constraints:
                    BoxConstraints(maxWidth: getProportionateScreenWidth(500)),
                child: ElevatedButton.icon(
                  label: const Text('Google'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.grey),
                    shape: MaterialStateProperty.resolveWith((states) =>
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14)))),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .googleLogin();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

bool isPhoneNoValid(String? phoneNo) {
  if (phoneNo == null) return false;
  final RegExp regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  return regExp.hasMatch(phoneNo);
}
