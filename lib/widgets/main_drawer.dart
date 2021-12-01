import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_lap/pages/orders_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function() tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
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
                      radius: 30,
                    ),
                  ),
                  onDetailsPressed: () {
                    print('hello');
                  },
                  accountName: Text(user.name),
                  accountEmail: Text('${user.email} ')),
              const SizedBox(
                height: 20,
              ),
              buildListTile('My Analysis', Icons.analytics_outlined, () {
                Navigator.pushNamed(context, OrdersPage.routeName);
              }),
              buildListTile('Logout', Icons.logout_outlined, () async {
                await FirebaseAuth.instance.signOut();
                print(FirebaseAuth.instance.currentUser!.displayName);
              }),
            ],
          ),
        );
      },
    );
  }
}
