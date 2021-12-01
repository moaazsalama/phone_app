import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/pages/otp_page.dart';
import 'package:phone_lap/providers/auth.dart';
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
                        height: getProportionateScreenHeight(200),
                        constraints: BoxConstraints(
                          maxWidth: getProportionateScreenWidth(400),
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
                  child: const Text('Phone Lap',
                      style: TextStyle(
                          color: MyColors.primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w800)))
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                      maxWidth: getProportionateScreenWidth(180)),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'We will send you an ',
                          style: TextStyle(color: MyColors.primaryColor)),
                      TextSpan(
                          text: 'One Time Password ',
                          style: TextStyle(
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: 'on this mobile number',
                          style: TextStyle(color: MyColors.primaryColor)),
                    ]),
                  )),
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (value) {
                      countryCode = value.dialCode!;
                      print(countryCode);
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
                    print(phoneController.text);
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
                          radius: 3.0,
                          textStyle: const TextStyle(
                              fontSize: 20.0, color: Colors.black),
                        );
                      }
                    } else {
                      showToast('Unvalid phoneNumber ',
                          duration: const Duration(seconds: 2),
                          position: ToastPosition.bottom,
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          animationCurve: Curves.easeIn,
                          animationDuration: const Duration(milliseconds: 500),
                          radius: 10.0,
                          textStyle: const TextStyle(
                              fontSize: 20.0, color: Colors.white),
                          textAlign: TextAlign.center,
                          dismissOtherToast: true);
                    }
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
                        const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: MyColors.primaryColorLight,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Center(child: Text('Or Sign with Google')),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
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
