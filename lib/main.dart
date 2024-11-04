import 'package:flutter/material.dart';
import 'package:hpb/dependentInfoPage.dart';
import 'accountEmergencyAddingPage.dart';
import 'accountEmergencyEditPage.dart';
import 'bedWalkingPage.dart';
import 'chooseLanguagePage.dart';
import 'deviceFunctionPage.dart';
import 'homePage.dart';
import 'lightSettingPage.dart';
import 'setEmergencyContactPage.dart';
import 'setSelfInfoPage.dart';
import 'package:provider/provider.dart';
import 'addDevicePage.dart';
import 'appBar.dart';
import 'checkTermsPage.dart';
import 'forgetPasswordPage.dart';
import 'loadingPage.dart';
import 'loginPage.dart';
import 'mult_provider.dart';
import 'signUpPage.dart';
import 'voiceSettingPage.dart';
import 'stateLightManualPage.dart';
import 'familyPage.dart';
import 'accountEmergencyPage.dart';
import 'accountSelfInfoPage.dart';
import 'accountEmergencyBody.dart';
import 'accountEmergencyEditBody.dart';
import 'faqPage.dart';
import 'warrantyTermsPage.dart';
import 'subscriptionPage.dart';
import 'dataAnalyzePage.dart';
import 'bedSettingPage.dart';
import 'bedCompleteBody.dart';
import 'bedExplainPage.dart';
import 'bedCompletePage.dart';
import 'abNormalHistoryPage.dart';
import 'dependentInfoPage.dart';
import 'accountDependentInfoPage.dart';
import 'addDevicePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
//檔案page結尾的是畫面上的topbar bottombar leftDrawer
//檔案body結尾的是畫面主要內容

void main() async {
  runApp(MyApp(homePage: await determineHomePage()));
}

//根據手機的內部記憶去選擇第一頁是首頁 登陸頁 或者選擇語言
Future<Widget> determineHomePage() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget homePage;
  if (prefs.containsKey('notFirst')) {
    if (prefs.containsKey('jwtToken')) {
      homePage = const HomePage();
    } else {
      homePage = const LoginPage();
    }
  } else {
    homePage = const ChooseLanguagePage();
  }
  return homePage;
}

class MyApp extends StatelessWidget {
  final Widget homePage;
  const MyApp({super.key, required this.homePage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DeviceInfo()),
        ChangeNotifierProvider.value(value: PeopleInfo()),
        ChangeNotifierProvider.value(value: Emergency()),
        ChangeNotifierProvider.value(value: EmergencyContact()),
        ChangeNotifierProvider.value(value: FaqInfo()),
        ChangeNotifierProvider.value(value: VisualCharts()),
      ],
      child: MaterialApp(
        title: 'hpb',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          useMaterial3: true,
        ),
        home: homePage,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

//哨兵模式初始值還沒設定
//略過API9
//fire base clouding message