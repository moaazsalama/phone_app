import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/pages/admin_page.dart';
import 'package:phone_lap/pages/blood_page.dart';
import 'package:phone_lap/pages/confirm_page.dart';
import 'package:phone_lap/pages/home_page.dart';
import 'package:phone_lap/pages/info_page.dart';
import 'package:phone_lap/pages/login_page.dart';
import 'package:phone_lap/pages/orders_page.dart';
import 'package:phone_lap/pages/otp_page.dart';
import 'package:phone_lap/pages/pcr_data_page.dart';
import 'package:phone_lap/pages/search_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/auth.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:phone_lap/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSheetApi.init();

  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AnalyzerProvider>(
          create: (context) => AnalyzerProvider(),
          update: (context, authvalue, previous) =>
              previous!..getData(authvalue.auth.currentUser!.uid),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (context) => Orders(),
          update: (context, authvalue, previous) =>
              previous!..getData(authvalue.auth.currentUser!.uid),
        )
      ],
      child: OKToast(
        child: MaterialApp(
          supportedLocales: const [
            Locale('af'),
            Locale('am'),
            Locale('ar'),
            Locale('az'),
            Locale('be'),
            Locale('bg'),
            Locale('bn'),
            Locale('bs'),
            Locale('ca'),
            Locale('cs'),
            Locale('da'),
            Locale('de'),
            Locale('el'),
            Locale('en'),
            Locale('es'),
            Locale('et'),
            Locale('fa'),
            Locale('fi'),
            Locale('fr'),
            Locale('gl'),
            Locale('ha'),
            Locale('he'),
            Locale('hi'),
            Locale('hr'),
            Locale('hu'),
            Locale('hy'),
            Locale('id'),
            Locale('is'),
            Locale('it'),
            Locale('ja'),
            Locale('ka'),
            Locale('kk'),
            Locale('km'),
            Locale('ko'),
            Locale('ku'),
            Locale('ky'),
            Locale('lt'),
            Locale('lv'),
            Locale('mk'),
            Locale('ml'),
            Locale('mn'),
            Locale('ms'),
            Locale('nb'),
            Locale('nl'),
            Locale('nn'),
            Locale('no'),
            Locale('pl'),
            Locale('ps'),
            Locale('pt'),
            Locale('ro'),
            Locale('ru'),
            Locale('sd'),
            Locale('sk'),
            Locale('sl'),
            Locale('so'),
            Locale('sq'),
            Locale('sr'),
            Locale('sv'),
            Locale('ta'),
            Locale('tg'),
            Locale('th'),
            Locale('tk'),
            Locale('tr'),
            Locale('tt'),
            Locale('uk'),
            Locale('ug'),
            Locale('ur'),
            Locale('uz'),
            Locale('vi'),
            Locale('zh')
          ],
          localizationsDelegates: const [
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: MyColors.primaryColor,
              colorScheme: const ColorScheme.light(onSecondary: Colors.amber)),
          routes: {
            HomePage.routeName: (context) => const HomePage(),
            LoginPage.routeName: (context) => const LoginPage(),
            OtpPage.routeName: (context) => const OtpPage(),
            AdminPage.routeName: (context) => const AdminPage(),
            ConfirmPage.routeName: (context) => const ConfirmPage(),
            PcrDataScreen.routName: (context) => PcrDataScreen(),
            OrdersPage.routeName: (context) => const OrdersPage(),
            BloodPage.routeName: (context) => const BloodPage(),
            SearchPage.routeName: (context) => SearchPage(),
            AdminPage.routeName: (context) => const AdminPage(),
          },
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              authProvider.getAdmins();
              return StreamBuilder<User?>(
                stream: authProvider.auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    return const AdminPage();
                  } else if (snapshot.data != null) {
                    if (authProvider.isNew)
                      return InfoScreen(
                        user: authProvider.auth.currentUser!,
                      );
                    else {
                      var isadmin = authProvider
                          .isAdmin(authProvider.auth.currentUser!.email);
                      print(isadmin);
                      if (isadmin) return const AdminPage();
                      return const HomePage();
                    }
                  } else {
                    return const LoginPage();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
