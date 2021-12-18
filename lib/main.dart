import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/pages/admin_page.dart';
import 'package:phone_lap/pages/blood_page.dart';
import 'package:phone_lap/pages/confirm_page.dart';
import 'package:phone_lap/pages/home_page.dart';
import 'package:phone_lap/pages/info_page.dart';
import 'package:phone_lap/pages/login_page.dart';
import 'package:phone_lap/pages/orders_page.dart';
import 'package:phone_lap/pages/otp_page.dart';
import 'package:phone_lap/pages/pcr_data_page.dart';
import 'package:phone_lap/pages/prescription_data.dart';
import 'package:phone_lap/pages/search_page.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/auth.dart';
import 'package:phone_lap/providers/google_sheets_Api.dart';
import 'package:phone_lap/providers/languagesprovider.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:phone_lap/theme.dart';
import 'package:provider/provider.dart';

import 'helpers/language/language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageChangeProvider().getLanguage();
  await UserSheetApi.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(), child: App()));
}

class App extends StatelessWidget {
  ///toz feekooo
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AnalyzerProvider>(
            create: (context) => AnalyzerProvider(),
            update: (context, authvalue, previous) {
              if (authvalue.auth.currentUser == null) return AnalyzerProvider();
              return previous!..getData(authvalue.auth.currentUser!.uid);
            }),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (context) => Orders(),
          update: (context, authvalue, previous) {
            if (authvalue.auth.currentUser == null) return Orders();
            return previous!..getData(authvalue.auth.currentUser!.uid);
          },
        )
      ],
      child: OKToast(
        child: MaterialApp(
          locale: Provider.of<LanguageChangeProvider>(context, listen: true)
              .current,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: MyColors.primaryColor,
              fontFamily: Provider.of<LanguageChangeProvider>(context)
                          .current!
                          .languageCode ==
                      'ar'
                  ? 'Arabic'
                  : null,
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
            PrescriptionData.routeName: (context) => PrescriptionData(),
          },
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              SizeConfig().init(context);
              return StreamBuilder<User?>(
                stream: authProvider.auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (authProvider.isNew)
                      return InfoScreen(
                        user: authProvider.auth.currentUser!,
                      );
                    else {
                      return FutureBuilder<bool>(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return const Center(
                                child: CircularProgressIndicator());
                          else {
                            if (snapshot.hasData) {
                              if (snapshot.data == true) {
                                return const AdminPage();
                              } else {
                                return const HomePage();
                              }
                            } else
                              return const HomePage();
                          }
                        },
                        future: authProvider
                            .isAdmin(authProvider.auth.currentUser!.email),
                      );
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
