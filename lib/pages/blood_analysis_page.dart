import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/models/analysisType.dart';
import 'package:phone_lap/pages/cart_screen.dart';
import 'package:phone_lap/providers/cart.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';
import 'package:phone_lap/theme.dart';
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
                    ? SizeConfig.screenHeight * 0.12
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
                      alignment: const Alignment(-0.9, 1),
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.5),
                      child: Hero(
                        tag: type.anaysisType,
                        child: Text(
                          '${type.anaysisType}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: getProportionScreenration(24),
                              fontWeight: FontWeight.bold),
                        ),
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
      floatingActionButton: Container(
        alignment: Alignment.center,
        height: getProportionateScreenHeight(60),
        width: getProportionateScreenWidth(60),
        decoration: BoxDecoration(
            color: MyColors.primaryColor,
            borderRadius: BorderRadius.circular(30)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Navigator.pushReplacementNamed(
                        context, CartScreen.routname);
                  },
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    size: getProportionScreenration(30),
                  )),
            ),
            Positioned(
              right: getProportionateScreenWidth(10),
              top: getProportionateScreenHeight(10),
              child: Container(
                alignment: Alignment.center,
                height: getProportionateScreenHeight(20),
                width: getProportionateScreenWidth(20),
                child: Text(
                  Provider.of<Cart>(context).itemCount.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnalysisItem extends StatelessWidget {
  final Analysis analysis;
  const AnalysisItem(this.analysis);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final cart = Provider.of<Cart>(context, listen: false);
        final addItem = cart.addItem(analysis);
        if (addItem == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.addcart),
            duration: const Duration(seconds: 1),
            dismissDirection: DismissDirection.horizontal,
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.undo,
              onPressed: () {
                cart.removeItem(analysis);
              },
            ),
          ));
        }
      },
      child: SizedBox(
        height: getProportionateScreenHeight(200),
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
                        width: SizeConfig.screenWidth * 0.60,
                        color: Colors.black54,
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          analysis.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: getProportionScreenration(26),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.work,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(AppLocalizations.of(context)!.order,
                            style: TextStyle(
                                fontSize: getProportionScreenration(16))),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${analysis.price}',
                          style: TextStyle(
                              fontSize: getProportionScreenration(16)),
                        ),
                        Text(
                          AppLocalizations.of(context)!.le,
                          style: TextStyle(
                              fontSize: getProportionScreenration(16)),
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
