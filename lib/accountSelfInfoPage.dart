import 'package:flutter/material.dart';
import 'package:hpb/addDeviceBody.dart';

import 'abNormalHistoryBody.dart';
import 'appBar.dart';
import 'homeBody.dart';
import 'accountSelfInfoBody.dart';
import 'custom_drawer.dart';
import 'abNormalHistoryPage.dart';
import 'dataAnalyzePage.dart';
import 'homePage.dart';
import 'familyPage.dart';
import 'restfulApi.dart';
import 'package:provider/provider.dart';
import 'mult_provider.dart';
import 'alertDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';  
class AccountSelfInfoPage extends StatelessWidget {
  const AccountSelfInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emergency = Provider.of<Emergency>(context, listen: false);
    final peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    final appBar = PreferredSize(
      preferredSize: const Size.fromHeight(25.0),
      child: AppBar(
        // this argument(automaticallyImplyLeading) can cancel built-in back button.
        automaticallyImplyLeading: false,
        //sending user name to appbar to change the staff name
        //the user name is from login page

        title: const Appbar(),
        backgroundColor: Colors.white,
        // backgroundColor: const Color(0XFFF1F1F1),
      ),
    );

    final page = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: AccountSelfInfo(), // Assuming Home is a widget you have defined elsewhere
      backgroundColor: const Color(0XFFD9D9D9),
      drawer: CustomDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        onTap: (int index) async {
          switch (index) {
            case 0:
              final res = await getEmergencyWarningLogs(
                  getFormattedTodayDate(), emergency);
              if (res == "success") {
                final res2 = await getEventWarningLogs(
                    getFormattedTodayDate(), emergency);
                if (res2 == "success") {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AbnormalHistoryPage()));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => HttpAlertDialog(errorMessage: res2),
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) => HttpAlertDialog(errorMessage: res),
                );
              }
              break;
            case 1:
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DataAnalyzePage()));
              break;
            case 2:
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
              break;
            case 3:
              final res = await getUserFollows(deviceInfo);
              if (res == "success") {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FamilyPage()));
              } else {
                showDialog(
                  context: context,
                  builder: (context) => HttpAlertDialog(errorMessage: res),
                );
              }
              break;
            case 4:
              final res = await getUserInfo(peopleInfo);
              if (res == "success") {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountSelfInfoPage()));
              } else {
                showDialog(
                  context: context,
                  builder: (context) => HttpAlertDialog(errorMessage: res),
                );
              }
              break;
          }
        },
        type: BottomNavigationBarType
            .fixed, // Fixed type for more than three items
        selectedItemColor: const Color(0XFF75B6CF), // Color for selected item
        unselectedItemColor: const Color(0xffC1C1C1),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/abnormalHistory.png',
              height: 50.h  ,
            ),
            label: '異常歷史',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/dataAnalyze.png',
              height: 50.h,
            ),
            label: '資訊分析',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png', 
              height: 50.h,
            ),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/family.png',
              height: 50.h,
            ),
            label: '家庭',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/accountGreen.png',
              height: 50.h,
            ),
            label: '帳戶',
          ),
        ],
      ),
    );

    return page;
  }
}
