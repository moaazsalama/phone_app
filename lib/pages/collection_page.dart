import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/providers/cart.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

// ignore: must_be_immutable
class CollectionPage extends StatefulWidget {
  CollectionPage({required this.analysisList, required this.analysisType}) {
    selctors = List.generate(analysisList.length, (index) => true);
  }
  final List<Analysis> analysisList;
  final AnalysisType analysisType;
  late List<bool> selctors;

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.analysisType.anaysisType,
          style: const TextStyle(color: Colors.black),
        ),
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
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                        widget.analysisList.length,
                        (index) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: widget.selctors[index],
                                  splashRadius: 16,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.selctors[index] = value!;
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                                Text(widget.analysisList[index].name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ))
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Button(
                    title: isLoading ? 'Loading' : 'Submit',
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      for (var analysis in widget.analysisList) {
                        if (widget
                            .selctors[widget.analysisList.indexOf(analysis)]) {
                          try {
                            Provider.of<Cart>(context, listen: false)
                                .addItem(analysis);
                            // final orderItem = OrderItem(
                            //     isDeliverd: 'no',
                            //     analysis: analysis,
                            //     user: Provider.of<AnalyzerProvider>(context,
                            //             listen: false)
                            //         .analyzer!,
                            //     id: 'id',
                            //     dateTime: DateTime.now());
                            // await Provider.of<Orders>(context, listen: false)
                            //     .sendOrder(orderItem, 'blood');
                          } catch (e) {
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
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                      showToast(
                        AppLocalizations.of(context)!.requestsuccessful,
                        duration: const Duration(seconds: 2),
                        position: ToastPosition.center,
                        backgroundColor: Colors.black.withOpacity(0.8),
                        radius: getProportionScreenration(3),
                        textStyle: TextStyle(
                            fontSize: getProportionScreenration(20.0)),
                      );

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
