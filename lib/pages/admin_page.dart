// ignore_for_file: empty_catches

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/auth.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:phone_lap/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

class AdminPage extends StatefulWidget {
  static String routeName = 'admin-Page';
  const AdminPage({Key? key}) : super(key: key);
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ImagePicker imagePicker = ImagePicker();
  List<OrderItem> list = [];
  var s = FirebaseFirestore.instance.collection('users').doc();
  Future<QuerySnapshot<Map<String, dynamic>>> dataSet =
      FirebaseFirestore.instance.collection('users').get();
  bool isFirst = true;
  bool showFinshed = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        drawer: MainDrawer(),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: SizeConfig.orientation == Orientation.portrait
                      ? SizeConfig.screenHeight * 0.15
                      : SizeConfig.screenHeight * 0.20,
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
                          onPressed: () async {
                            try {
                              await Navigator.pushReplacementNamed(
                                  context, LoginPage.routeName);

                              await Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .signOut();
                              Provider.of<AnalyzerProvider>(context,
                                      listen: true)
                                  .clear();
                            } catch (e) {}
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      Text(
                        'Controll Panel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionScreenration(24),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Show Finished Oreders ?'),
                    Checkbox(
                      value: showFinshed,
                      onChanged: (value) {
                        setState(() {
                          showFinshed = value!;
                        });
                      },
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: Provider.of<Orders>(context).fetchAllOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasData == false) {
                        return const CircularProgressIndicator();
                      } else {
                        final docs = snapshot.data!.docs;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: docs.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Orders Yet',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize:
                                              getProportionScreenration(24),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Builder(builder: (context) {
                                    List<OrderWidgetAdmin> finish = [];
                                    List<OrderWidgetAdmin> notFinished = [];
                                    for (var index = 0;
                                        index < docs.length;
                                        index++) {
                                      var orderItem =
                                          OrderItem.fromMap(docs[index].data());
                                      if (orderItem.id == null)
                                        orderItem = orderItem.copyWith(id: '');
                                      bool finished = true;
                                      for (var item in orderItem.analysis) {
                                        if (item.resultUrl == null) {
                                          finished = false;
                                          break;
                                        }
                                      }
                                      if (finished) {
                                        finish.add(OrderWidgetAdmin(
                                            request: orderItem));
                                      } else
                                        notFinished.add(OrderWidgetAdmin(
                                            request: orderItem));
                                    }

                                    return Column(
                                      children: [
                                        if (!showFinshed)
                                          Expanded(
                                            flex: 2,
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                return notFinished[index];
                                              },
                                              itemCount: notFinished.length,
                                            ),
                                          ),
                                        if (showFinshed)
                                          const Text('Finished Orders'),
                                        if (showFinshed)
                                          Expanded(
                                            flex: 1,
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                return finish[index];
                                              },
                                              itemCount: finish.length,
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                          ),
                        );
                      }
                    }),
              ],
            )
          ],
        ));
  }
}

class OrderWidgetAdmin extends StatefulWidget {
  const OrderWidgetAdmin({
    Key? key,
    required this.request,
  }) : super(key: key);

  final OrderItem request;

  @override
  State<OrderWidgetAdmin> createState() => _OrderWidgetAdminState();
}

class _OrderWidgetAdminState extends State<OrderWidgetAdmin> {
  final pdf = pw.Document();

  final ImagePicker imagePicker = ImagePicker();

  File? _imageFile;

  File? finalpdf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.request.totalPrice}\$',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(DateFormat('dd/MM/yyyy').format(widget.request.dateTime)),
          ],
        ),
        subtitle: Text('عدد المنتجات ${widget.request.analysis.length}'),
        children: widget.request.analysis.map((product) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.analysisname,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.analysis.name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                if (product.passportImageUrl != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          product.passportImageUrl!,
                          fit: BoxFit.cover,
                          width: getProportionateScreenWidth(100),
                          height: getProportionateScreenHeight(100),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Image',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ].reversed.toList(),
                  ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.price,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      product.analysis.price,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                if (product.flightLine != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.flightline,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        product.flightLine!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.result,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (product.resultUrl != null)
                      TextButton(
                          onPressed: () {
                            launch(product.resultUrl!);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.result,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ))
                    else
                      Text(
                        AppLocalizations.of(context)!.noresults,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
                Button(
                    title: 'Send The Resuilt By Photo',
                    onPressed: () async {
                      try {
                        final result = await imagePicker.pickImage(
                            source: ImageSource.gallery);

                        if (result != null) {
                          _imageFile = File(result.path);
                          createpdf(_imageFile);
                          await savepdf(widget.request.id!);
                          final url = await uploadPdf(context);
                          print(url);
                          await Provider.of<Orders>(context, listen: false)
                              .deliverAnalysis(
                                  url!, widget.request, product.analysis);
                        }
                        //await widget.request.deliver(url);
                      } catch (e) {
                        print(e.toString() + 'hello');
                      }
                    }),
                Button(
                    title: 'Send The Resuilt By PDF ',
                    onPressed: () async {
                      try {
                        final pickFiles = await FilePicker.platform.pickFiles();
                        if (pickFiles != null) {
                          finalpdf = File(pickFiles.files.single.path!);
                          final url = await uploadPdf(context);
                          await Provider.of<Orders>(context, listen: false)
                              .deliverAnalysis(
                                  url!, widget.request, product.analysis);
                          // await widget.request.deliver(url);
                        }
                      } on Exception {}
                    }),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 10,
                  color: Colors.black,
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void createpdf(File? imageFile) {
    final image = pw.MemoryImage(imageFile!.readAsBytesSync());
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(child: pw.Image(image));
      },
    ));
  }

  Future<String?> uploadPdf(context) async {
    try {
      final analyzer =
          Provider.of<AnalyzerProvider>(context, listen: false).userId;
      final task = await FirebaseStorage.instance
          .ref()
          .child('${analyzer!}/${finalpdf!.path.split('/').last}')
          .putFile(finalpdf!);
      final String url = await task.ref.getDownloadURL();

      return url;
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> savepdf(String name) async {
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/$name.pdf');

    finalpdf = await file.writeAsBytes(await pdf.save());
  }
}
