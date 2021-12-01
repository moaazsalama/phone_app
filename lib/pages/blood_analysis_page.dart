import 'package:flutter/material.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:phone_lap/widgets/button.dart';
import 'package:provider/provider.dart';

class BloodAnalysisPage extends StatelessWidget {
  static String routeName = 'bloodAnalysis-page';
  final AnalysisType type;
  const BloodAnalysisPage({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: SizeConfig.orientation == Orientation.portrait
                    ? SizeConfig.screenHeight * 0.10
                    : SizeConfig.screenHeight * 0.25,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.7),
                      child: Text(
                        '${type.anaysisType}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: FutureBuilder<List<Analysis>>(
                future: UserSheetApi.fetchAnalysis(key: type.key),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) =>
                                AnalysisItem(snapshot.data![index]),
                          ),
              ))
            ],
          )
        ],
      ),
    );
  }
}

class AnalysisItem extends StatelessWidget {
  final Analysis analysis;
  const AnalysisItem(this.analysis);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            builder: (context) {
              return Container(
                alignment: Alignment.center,
                height: SizeConfig.screenHeight / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Are You Sure about order !?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight / 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Button(
                          title: 'Yes',
                          onPressed: () async {
                            final analyzer = Provider.of<AnalyzerProvider>(
                                    context,
                                    listen: false)
                                .analyzer;
                            await Provider.of<Orders>(context, listen: false)
                                .sendOrder(
                                    OrderItem(
                                        analysis: analysis,
                                        user: analyzer!,
                                        id: 'uid',
                                        dateTime: DateTime.now(),
                                        isDeliverd: 'no'),
                                    analysis.isNecessary ? '' : 'blood');
                            Navigator.pop(context);
                          },
                        ),
                        Button(
                          title: 'No',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Image.asset(
                        'assets/img/mask.png',
                        height: getProportionateScreenHeight(250),
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 10,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Text(
                          analysis.name,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: const <Widget>[
                        Icon(
                          Icons.work,
                          size: 16,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text('Order', style: TextStyle(fontSize: 26)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${analysis.price} LE',
                          style: const TextStyle(fontSize: 26),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
