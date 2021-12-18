import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/pages/orders_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/languagesprovider.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function() tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: getProportionScreenration(26),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: getProportionScreenration(24),
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyzerProvider>(
      builder: (context, val, child) {
        final user = val.analyzer;

        return Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  currentAccountPicture: Container(
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
                      radius: getProportionScreenration(30),
                    ),
                  ),
                  accountName: Text(user.name),
                  accountEmail: Text('${user.email}')),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    AppLocalizations.of(context)!.languages,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Consumer<LanguageChangeProvider>(
                    builder: (BuildContext context, value, child) {
                      final selects = <bool>[];
                      selects.add(
                          // ignore: avoid_bool_literals_in_conditional_expressions
                          value.current!.languageCode == 'en' ? true : false);
                      selects.add(
                          // ignore: avoid_bool_literals_in_conditional_expressions
                          value.current!.languageCode == 'en' ? false : true);
                      return ToggleButtons(
                        constraints: BoxConstraints(
                          maxWidth: getProportionateScreenWidth(80),
                          minWidth: getProportionateScreenWidth(40),
                          maxHeight: getProportionateScreenWidth(80),
                          minHeight: getProportionateScreenWidth(40),
                        ),
                        children: const [Text('EN'), Text('AR')],
                        isSelected: selects,
                        borderRadius: BorderRadius.circular(60),
                        onPressed: (index) {
                          if (index == 0) {
                            if (!(value.current!.languageCode == 'en'))
                              value.toggleLanguage();
                          } else {
                            if (!(value.current!.languageCode == 'ar'))
                              value.toggleLanguage();
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              buildListTile(AppLocalizations.of(context)!.myanalysis,
                  Icons.analytics_outlined, () {
                Navigator.pushNamed(context, OrdersPage.routeName);
              }),
              buildListTile(
                  AppLocalizations.of(context)!.logout, Icons.logout_outlined,
                  () async {
                await FirebaseAuth.instance.signOut();
              }),
            ],
          ),
        );
      },
    );
  }
}
