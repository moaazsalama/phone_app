import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analyzer.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:phone_lap/widgets/custom_textfeilds.dart' show CustomTextField;
import 'package:provider/provider.dart';

class PcrDataScreen extends StatefulWidget {
  static const routName = 'Pcr-data-Page';
  @override
  State<PcrDataScreen> createState() => _PcrDataScreenState();
}

class _PcrDataScreenState extends State<PcrDataScreen> {
  final TextEditingController _lineController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  ImageProvider? image;
  final ImagePicker imagePicker = ImagePicker();
  File? _imageFile;
  File? _pickedImage;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (_imageFile == null)
      image = const AssetImage('assets/img/placeholder.png');
    else
      image = FileImage(_imageFile!);

    print('dd');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyzerProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
      body: isLoading
          ? Stack(
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
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      const Text(
                        'please wait seconds to compelete your request',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: SizeConfig.screenWidth,
                    height: getProportionateScreenHeight(100),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        )),
                    alignment: const Alignment(0, 0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        const Text(
                          'please compelete this information',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight -
                        getProportionateScreenHeight(100),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: _lineController,
                            labelText: 'Flight  Line',
                            hintText: 'please write your flight line',
                            icon: Icons.airplane_ticket_outlined,
                          ),
                          CustomTextField(
                            controller: _countryController,
                            labelText: 'Traveling country',
                            hintText: 'please write your traveling country ',
                            textInputType: TextInputType.text,
                            icon: Icons.flag_outlined,
                          ),
                          Stack(
                            children: [
                              Image(
                                image: image!,
                                fit: BoxFit.cover,
                                height: getProportionateScreenHeight(250),
                              ),
                              IconButton(
                                alignment: Alignment.center,
                                onPressed: () {
                                  setState(() {
                                    image = const AssetImage(
                                        'assets/img/placeholder.png');
                                    _pickedImage = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                ),
                                color: Colors.red,
                                highlightColor: Colors.red,
                              )
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Please attach the Passport info ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Button(
                                  width: getProportionateScreenWidth(150),
                                  height: 60,
                                  title: 'from Gallery',
                                  onPressed: () async {
                                    try {
                                      final result =
                                          await imagePicker.pickImage(
                                              source: ImageSource.gallery);

                                      if (result != null)
                                        setState(() {
                                          _imageFile = File(result.path);
                                          _pickedImage = _imageFile;
                                          image = FileImage(_imageFile!);
                                        });
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  }),
                              Button(
                                  height: 60,
                                  width: getProportionateScreenWidth(150),
                                  title: 'from Camera',
                                  onPressed: () async {
                                    try {
                                      final result =
                                          await imagePicker.pickImage(
                                              source: ImageSource.camera);

                                      if (result != null)
                                        setState(() {
                                          print(result.path);
                                          _imageFile = File(result.path);
                                          _pickedImage = _imageFile;
                                          image = FileImage(_imageFile!);
                                        });
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  }),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Button(
                            title: 'Submit',
                            onPressed: () {
                              onSubmit(provider.analyzer!);
                            },
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

  Future<void> onSubmit(Analyzer user) async {
    if (_countryController.text.isEmpty || _lineController.text.isEmpty) {
      showToast(
        "Don't Let any Empty Feilds",
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 30.0),
      );
    } else if (_pickedImage == null) {
      showToast(
        'please insert passport image',
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        animationCurve: Curves.easeIn,
        animationDuration: const Duration(milliseconds: 500),
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 20.0, color: Colors.black),
      );
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        final taskSnapshot = await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('${user.analyzerId}/${_pickedImage!.path.split('/').last}')
            .putFile(_pickedImage!);
        final s = await taskSnapshot.ref.getDownloadURL();
        final orderItem = OrderItem(
            analysis: Analysis(
                name: 'Pcr',
                analysisType: 'PCr',
                price: '100'),
            user: user,
            id: 'id',
            dateTime: DateTime.now(),
            passportImageUrl: s,
            flightLine: _lineController.text,
            travlingCountry: _countryController.text,
            isDeliverd: 'no');
        // ignore: prefer_final_locals
        var map = orderItem.toMap();
        map.remove('id');
        await Provider.of<Orders>(context, listen: false)
            .sendOrder(orderItem, 'pcrTravel');
      } catch (e) {
        print(e.toString());
      }

      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
      showToast(
        'Request Sent Successfuly',
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 20.0),
      );
    }
  }
}
