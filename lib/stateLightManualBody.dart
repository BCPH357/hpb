import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'mult_provider.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'longText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class StateLightManual extends StatefulWidget {
  const StateLightManual({super.key});

  @override
  _StateLightManualState createState() => _StateLightManualState();
}

class _StateLightManualState extends State<StateLightManual> {
  int autotune = 0;
  int handTune = 0;
  int moreSetting = 0;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // deviceInfo.setDeviceInfo();

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 13.35.h),  
        width: 390.45.w,
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF), // 背景颜色
          borderRadius: BorderRadius.circular(20), // 设置圆角半径
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.w,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "狀態指示燈說明",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w),
                ],
              ),
              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, -3),
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(3, 0),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(-3, 0),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/stateLight.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
