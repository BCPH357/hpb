import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:hpb/chooseLanguagePage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'addDevicePage.dart';
class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String _androidVersion = "Unknown";

  @override
  void initState() {
    super.initState();
    _getAndroidVersion();

    // 2秒后跳转到下一页
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChooseLanguagePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Container(
      height: 890.h,
      width: 411.w,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/APP_start_page.png',
            ),
          ),
          Positioned(
            bottom: 106.8.h,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "APP 1.0.0",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Android ${_androidVersion}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ),
        ],
      )
    );
  }
  Future<void> _getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _androidVersion = androidInfo.version.release; // 获取Android版本
    });
  }
}