import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
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
                          onPressed: () =>
                              Provider.of<AuthProvider>(context, listen: false)
                                  .signOut(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      const Text(
                        'Controll Panel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
                                ? const Center(
                                    child: Text(
                                      'No Orders Yet',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      var orderItem =
                                          OrderItem.fromMap(docs[index].data());
                                      if (orderItem.id == null)
                                        orderItem = orderItem.copyWith(id: '');
                                      return OrderWidgetAdmin(
                                          request: orderItem);
                                    },
                                    itemCount: docs.length,
                                  ),
                          ),
                        );
                      }
                    }),
              ],
            )
          ],
        ));
      },
    );
  }
}

class OrderWidgetAdmin extends StatefulWidget {
  OrderWidgetAdmin({
    Key? key,
    required this.request,
  }) : super(key: key);

  OrderItem request;

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
    return Card(
      child: ExpansionTile(
        collapsedBackgroundColor:
            widget.request.resultUrl == null ? Colors.red : Colors.green,
        subtitle: widget.request.travlingCountry == null
            ? null
            : Text(
                widget.request.travlingCountry!,
                textAlign: TextAlign.start,
                softWrap: true,
                style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.request.analysis.name.toUpperCase(),
                textAlign: TextAlign.start,
                softWrap: true,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${DateFormat('y/M/d hh:mm ').add_j().format(widget.request.dateTime)}',
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        expandedAlignment: Alignment.bottomLeft,
        children: [
          if (widget.request.passportImageUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PassPort Image',
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image(
                      image: NetworkImage(
                        widget.request.passportImageUrl!,
                      ),
                      fit: BoxFit.cover,
                      height: getProportionateScreenHeight(80),
                      width: getProportionateScreenWidth(80),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.request.travlingCountry != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Travling Country',
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.request.travlingCountry!,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          if (widget.request.flightLine != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Flight Line',
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.request.flightLine!,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          if (widget.request.flightLine != null)
            Divider(
              color: Theme.of(context).primaryColor,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analysis Name',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.request.analysis.name,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Prcie',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.request.analysis.price,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'IsNeccessary',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.request.analysis.isNecessary
                      ? 'Neccessary ${widget.request.analysis.isNecessary}'
                      : 'Normal',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analyzer Phone',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.request.user.phone,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analyzer Address',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.request.user.address,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analyzer Gender',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.request.user.gender ? 'Male' : 'Female',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analyzer Date',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.request.user.date,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analsis Is Deliverd ?!',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.request.isDeliverd.toUpperCase(),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Result Link',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  child: Text(
                    widget.request.resultUrl ?? 'Not Avalibale',
                    textAlign: TextAlign.start,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Button(
              title: 'Send The Resuilt By Photo',
              onPressed: () async {
                try {
                  final result =
                      await imagePicker.pickImage(source: ImageSource.gallery);

                  if (result != null) _imageFile = File(result.path);
                  print('${_imageFile!.path}');
                  createpdf(_imageFile);
                  await savepdf(widget.request.id!);
                  final url = await uploadPdf(context);
                  await widget.request.deliver(url);
                } catch (e) {
                  print(e.toString());
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
                    await widget.request.deliver(url);
                    widget.request = widget.request
                        .copyWith(resultUrl: url, isDeliverd: 'yes');
                    setState(() {});
                  }
                } on Exception {
                  // TODO
                }

                print(widget.request.id);
              })
        ],
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

  Future<String> uploadPdf(context) async {
    final analyzer =
        Provider.of<AnalyzerProvider>(context, listen: false).userId;
    final task = await FirebaseStorage.instance
        .ref()
        .child('${analyzer!}/${finalpdf!.path.split('/').last}')
        .putFile(finalpdf!);
    final String url = await task.ref.getDownloadURL();
    print(url);
    return url;
  }

  Future<void> savepdf(String name) async {
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/$name.pdf');
    print(file.path);

    finalpdf = await file.writeAsBytes(await pdf.save());
    print('sucess');
  }
}
