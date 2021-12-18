import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analyzer.dart';
import 'package:phone_lap/pages/home_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/theme.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:phone_lap/widgets/custom_textfeilds.dart' show CustomTextField;
import 'package:provider/provider.dart';

class InfoScreen extends StatefulWidget {
  final User user;

  const InfoScreen({required this.user});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dateController =
      TextEditingController(text: DateFormat.yMd().format(DateTime(2000)));
  GlobalKey<FormState> key = GlobalKey<FormState>();
  DateTime? selectedDate;
  bool isMale = true;
  String? city;
  @override
  void initState() {
    super.initState();

    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _nameController = TextEditingController(text: widget.user.displayName);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> list = {
      'elmohandseen': AppLocalizations.of(context)!.elmohandseen,
      'elzamalek': AppLocalizations.of(context)!.elzamalek,
      'elharm': AppLocalizations.of(context)!.elharm,
      'faisel': AppLocalizations.of(context)!.faisel,
      'giza': AppLocalizations.of(context)!.giza,
      'elagooza': AppLocalizations.of(context)!.elagooza,
      'octobar': AppLocalizations.of(context)!.octobar,
      'zayed': AppLocalizations.of(context)!.zayed,
      'eltgm3': AppLocalizations.of(context)!.eltgm3,
      'elrehab': AppLocalizations.of(context)!.elrehab,
      'madenty': AppLocalizations.of(context)!.madenty,
      'elshrouk': AppLocalizations.of(context)!.elshrouk,
      'elmostkbal': AppLocalizations.of(context)!.elmostkbal,
      'eldoki': AppLocalizations.of(context)!.eldoki,
      'nasr': AppLocalizations.of(context)!.nasr,
      'elmarg': AppLocalizations.of(context)!.elmarg,
      'helwan': AppLocalizations.of(context)!.helwan,
      'shobra': AppLocalizations.of(context)!.shobra,
      'eltahrir': AppLocalizations.of(context)!.eltahrir,
      'elmaadi': AppLocalizations.of(context)!.elmaadi,
      'elsayda': AppLocalizations.of(context)!.elsayda,
      'kerdasa': AppLocalizations.of(context)!.kerdasa,
      'nahya': AppLocalizations.of(context)!.nahya,
      'dahshoor': AppLocalizations.of(context)!.dahshoor,
      'newgiza': AppLocalizations.of(context)!.newgiza,
      'elnozha': AppLocalizations.of(context)!.elnozha,
      'ainshams': AppLocalizations.of(context)!.ainshams,
      'sherton': AppLocalizations.of(context)!.sherton,
      'fayoum': AppLocalizations.of(context)!.fayoum,
      'alex': AppLocalizations.of(context)!.alex
    };

    final values = list.values.toList();
    final keys = list.keys.toList();
    city ??= keys[0];

    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: getProportionateScreenHeight(60),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  )),
              alignment: const Alignment(0, 0),
              child: Text(
                AppLocalizations.of(context)!.complete,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionScreenration(20),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                shadowColor: Colors.grey,
                borderOnForeground: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      length: 20,
                      controller: _nameController,
                      labelText: AppLocalizations.of(context)!.name,
                      hintText: AppLocalizations.of(context)!.hintname,
                      icon: Icons.account_circle_outlined,
                    ),
                    CustomTextField(
                      controller: _phoneController,
                      labelText: AppLocalizations.of(context)!.phoneNumber,
                      hintText: AppLocalizations.of(context)!.hintNumber,
                      textInputType: TextInputType.phone,
                      icon: Icons.phone_outlined,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      labelText: AppLocalizations.of(context)!.email,
                      hintText: AppLocalizations.of(context)!.hintemail,
                      icon: Icons.email_outlined,
                      textInputType: TextInputType.emailAddress,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.area,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: getProportionScreenration(20)),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(15)),
                                  height: getProportionateScreenHeight(40),
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton<String>(
                                    // isExpanded: true,
                                    value: city,
                                    items: values
                                        .map((e) => DropdownMenuItem<String>(
                                              child: Text(
                                                e,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize:
                                                        getProportionScreenration(
                                                            12)),
                                              ),
                                              value: keys[values.indexOf(e)],
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        city = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              labelText: AppLocalizations.of(context)!.adress,
                              controller: _addressController,
                              textInputType: TextInputType.streetAddress,
                              icon: Icons.location_city_outlined,
                            ),
                          ),
                        ].reversed.toList(),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        datePicker(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20),
                            vertical: getProportionateScreenHeight(20)),
                        child: Form(
                          key: key,
                          child: TextFormField(
                            controller: _dateController,
                            validator: (value) {
                              final last = value!.split('/').last;
                              final tryParse = int.tryParse(last);
                              if (tryParse != null) {
                                final parse = int.parse(last);
                                if (parse > 2005) {
                                  return AppLocalizations.of(context)!.underage;
                                }
                              }
                              return value;
                            },
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.red),
                              suffixIcon: const Icon(Icons.calendar_today),
                              labelText: AppLocalizations.of(context)!.date,
                              enabled: false,
                              hintText: selectedDate == null
                                  ? null
                                  : selectedDate!.toIso8601String(),
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionScreenration(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: MyColors.primaryColor, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: MyColors.primaryColor, width: 2)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: MyColors.primaryColor, width: 2)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.gender,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionScreenration(18)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.male,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionScreenration(16),
                                      fontWeight: FontWeight.bold),
                                ),
                                Checkbox(
                                  value: isMale,
                                  onChanged: (value) {
                                    setState(() {
                                      isMale = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.female,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionScreenration(16),
                                      fontWeight: FontWeight.bold),
                                ),
                                Checkbox(
                                  value: !isMale,
                                  onChanged: (value) {
                                    setState(() {
                                      isMale = !value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Button(
                      title: AppLocalizations.of(context)!.submittwo,
                      onPressed: onSave,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSave() {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      showToast(
        AppLocalizations.of(context)!.validatepcr,
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: TextStyle(fontSize: getProportionScreenration(20.0)),
      );
    } else if (selectedDate!.year > 2005) {
      key.currentState!.validate();
      showToast(
        AppLocalizations.of(context)!.underage,
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: TextStyle(fontSize: getProportionScreenration(20.0)),
      );
    } else {
      Provider.of<AnalyzerProvider>(context, listen: false)
          .addAnlayzer(Analyzer(
              analyzerId: widget.user.uid,
              name: _nameController.text,
              phone: _phoneController.text,
              address: city! + '-' + _addressController.text,
              date: selectedDate.toString(),
              email: _emailController.text,
              gender: isMale))
          .then((value) {
        return Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      });
    }
  }

  Future<bool> datePicker(context) async {
    try {
      final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime(2030),
      );
      if (dateTime == null) return false;
      setState(() {
        selectedDate = dateTime;

        _dateController =
            TextEditingController(text: DateFormat.yMd().format(selectedDate!));
      });
      return true;
    } catch (e) {
      showToast(
        AppLocalizations.of(context)!.noconnection,
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: getProportionScreenration(3),
        textStyle: TextStyle(fontSize: getProportionScreenration(20.0)),
      );
    }
    return false;
  }
}
