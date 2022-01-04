import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analyzer.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:provider/provider.dart';

class PrescriptionData extends StatefulWidget {
  static String routeName = 'prescription_data';
  @override
  State<PrescriptionData> createState() => _PrescriptionDataState();
}

class _PrescriptionDataState extends State<PrescriptionData> {
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
                      Text(
                        AppLocalizations.of(context)!.wait,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionScreenration(16),
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
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.complete,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    SizeConfig.screenWidth > 400 ? 20 : 16,
                                fontWeight: FontWeight.bold),
                          ),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.qimage,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: getProportionScreenration(20),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Button(
                                  //    width: getProportionateScreenWidth(150),
                                  //     height: 60,
                                  titleSize:
                                      SizeConfig.screenWidth < 400 ? 16 : null,
                                  title: AppLocalizations.of(context)!.gallery,
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
                                      showToast(
                                        AppLocalizations.of(context)!
                                            .noconnection,
                                        duration: const Duration(seconds: 2),
                                        position: ToastPosition.center,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
                                        radius: getProportionScreenration(3),
                                        textStyle: TextStyle(
                                            fontSize: getProportionScreenration(
                                                20.0)),
                                      );
                                    }
                                  }),
                              Button(
                                  //    height: 60,
                                  //    width: getProportionateScreenWidth(150),
                                  title: AppLocalizations.of(context)!.camera,
                                  titleSize:
                                      SizeConfig.screenWidth < 400 ? 16 : null,
                                  onPressed: () async {
                                    try {
                                      final result =
                                          await imagePicker.pickImage(
                                              source: ImageSource.camera);

                                      if (result != null)
                                        setState(() {
                                          _imageFile = File(result.path);
                                          _pickedImage = _imageFile;
                                          image = FileImage(_imageFile!);
                                        });
                                    } catch (e) {
                                      showToast(
                                        AppLocalizations.of(context)!
                                            .noconnection,
                                        duration: const Duration(seconds: 2),
                                        position: ToastPosition.center,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
                                        radius: getProportionScreenration(3),
                                        textStyle: TextStyle(
                                            fontSize: getProportionScreenration(
                                                20.0)),
                                      );
                                    }
                                  }),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Button(
                            title: AppLocalizations.of(context)!.submit,
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
    if (_pickedImage == null) {
      showToast(
        AppLocalizations.of(context)!.qpassport,
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        animationCurve: Curves.easeIn,
        animationDuration: const Duration(milliseconds: 500),
        radius: 3.0,
        textStyle: TextStyle(
            fontSize: getProportionScreenration(20.0), color: Colors.black),
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
                name: 'PrescriptionData',
                analysisType: 'PrescriptionData',
                price: '500'),
            user: user,
            id: 'id',
            dateTime: DateTime.now(),
            passportImageUrl: s,
            //flightLine: _lineController.text,
            //travlingCountry: _countryController.text,
            isDeliverd: 'no');
        // ignore: prefer_final_locals
        var map = orderItem.toMap();
        map.remove('id');
        await Provider.of<Orders>(context, listen: false)
            .sendOrder(orderItem, 'blood');
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

      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
      showToast(
        AppLocalizations.of(context)!.requestsuccessful,
        duration: const Duration(seconds: 2),
        position: ToastPosition.center,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: TextStyle(fontSize: getProportionScreenration(20.0)),
      );
    }
  }
}
