import 'package:flutter/material.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/pages/blood_analysis_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';
import 'package:provider/provider.dart';

class BloodPage extends StatefulWidget {
  static String routeName = 'blood-page';
  const BloodPage({Key? key}) : super(key: key);

  @override
  State<BloodPage> createState() => _BloodPageState();
}

class _BloodPageState extends State<BloodPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AnalyzerProvider>(context).analyzer;
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
                    ? SizeConfig.screenHeight * 0.15
                    : SizeConfig.screenHeight * 0.25,
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
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white)),
                        padding: const EdgeInsets.all(2),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CircleAvatar(
                          child: Image.asset(
                              user!.gender
                                  ? 'assets/icon/business-man.png'
                                  : 'assets/icon/woman.png',
                              fit: BoxFit.cover),
                          radius: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${user.name}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            '${user.phone}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                  ],
                ),
              ),
              Container(
                width: getProportionateScreenWidth(200),
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                padding: const EdgeInsets.all(15),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(15))),
                child: const Text(
                  'Blood Analysis ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<AnalysisType>>(
                    future: UserSheetApi.fetchAnalysisTypes(isNecessary: null),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      if (!snapshot.hasData) {
                        return SizedBox(
                          height: SizeConfig.screenHeight / 2,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.network_check_outlined,
                                    size: 50,
                                    color: Theme.of(context).primaryColor),
                                Text(
                                  'No Connection',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return GridProducts(analysis: snapshot.data!);
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}

class GridProducts extends StatelessWidget {
  final List<AnalysisType> analysis;
  const GridProducts({
    Key? key,
    required this.analysis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BloodAnalysisPage(type: analysis[index]),
              ));
        },
        child: Container(
          height: 70,
          child: Stack(
            children: [
              Positioned(
                left: getProportionateScreenWidth(10),
                top: getProportionateScreenHeight(10),
                child: Text(
                  analysis[index].anaysisType,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decorationStyle: TextDecorationStyle.double,
                      textBaseline: TextBaseline.alphabetic),
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_outlined),
              )
            ],
          ),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:
                  Colors.blueGrey.withOpacity(0.7), // gradient: LinearGradient(
              //     colors: index.isOdd
              //         ? [
              //             Colors.primaries[index % Colors.primaries.length],
              //             Colors.primaries[index % Colors.primaries.length]
              //                 .withOpacity(0.6),
              //           ]
              //         : [
              //             Colors.primaries[index % Colors.primaries.length],
              //             Colors.primaries[index % Colors.primaries.length]
              //                 .withOpacity(0.6),
              //           ].reversed.toList()),
              // // borderRadius: BorderRadius.horizontal(
              //   right: Radius.circular(index.isEven ? 30 : 0),
              //   left: Radius.circular(index.isEven ? 0 : 30),
              // ),
              border: Border.all(width: 1, color: Colors.black54)),
        ),
      ),
      itemCount: analysis.length,
    );
  }
}
