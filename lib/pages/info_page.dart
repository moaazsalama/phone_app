import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  GlobalKey<FormState> Key = GlobalKey<FormState>();
  DateTime? selectedDate;
  bool isMale = true;
  String city = 'Cario';
  @override
  void initState() {
    super.initState();

    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _nameController = TextEditingController(text: widget.user.displayName);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
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
              child: const Text(
                'Your Information',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
                      controller: _nameController,
                      labelText: 'Name',
                      hintText: 'please write your name',
                      icon: Icons.account_circle_outlined,
                    ),
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'please write your phone number',
                      textInputType: TextInputType.phone,
                      icon: Icons.phone_outlined,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'please write your name(Optional).',
                      icon: Icons.email_outlined,
                      textInputType: TextInputType.emailAddress,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Area',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(15)),
                                height: getProportionateScreenHeight(40),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton(
                                    isDense: false,
                                    value: city,
                                    items: ['Cario', 'Giza']
                                        .map((e) => DropdownMenuItem<String>(
                                              child: Text(
                                                e,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 20),
                                              ),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        city = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: CustomTextField(
                              labelText: 'Address',
                              hintText: 'Enter your address',
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
                          key: Key,
                          child: TextFormField(
                            controller: _dateController,
                            validator: (value) {
                              var last = value!.split('/').last;
                              var tryParse = int.tryParse(last);
                              if (tryParse != null) {
                                var parse = int.parse(last);
                                if (parse > 2005) {
                                  return 'No Avaliable under 16 years ';
                                }
                              }
                              return value;
                            },
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              suffixIcon: const Icon(Icons.calendar_today),
                              labelText: 'Date',
                              enabled: false,
                              hintText: selectedDate == null
                                  ? null
                                  : selectedDate!.toIso8601String(),
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
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
                        const Text(
                          'Gender',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Male',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
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
                                const Text(
                                  'Female',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
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
                      title: 'Save and Countinue',
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
        "Don't Let any Empty Feilds",
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 20.0),
      );
    } else if (selectedDate!.year > 2005) {
      Key.currentState!.validate();
      showToast(
        'السن صغير',
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 20.0),
      );
    } else {
      Provider.of<AnalyzerProvider>(context, listen: false)
          .addAnlayzer(Analyzer(
              analyzerId: widget.user.uid,
              name: _nameController.text,
              phone: _phoneController.text,
              address: city + '-' + _addressController.text,
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
      print(e.toString());
    }
    return false;
  }
}
