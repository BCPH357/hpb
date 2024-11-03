import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hpb/stateLightManualBody.dart';
import 'package:hpb/stateLightManualPage.dart';
import 'package:hpb/voiceSettingPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'lightSettingBody.dart';
import 'mult_provider.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'voiceSettingBody.dart';
import 'lightSettingPage.dart';
import 'restfulApi.dart';
import 'bedSettingPage.dart';
import 'alertDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BedWalking extends StatefulWidget {
  final int index;

  const BedWalking({Key? key, required this.index}) : super(key: key);

  @override
  _BedWalkingState createState() => _BedWalkingState();
}

class _BedWalkingState extends State<BedWalking> {
  bool isWaiting = false;
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));

    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final imageWidth = 287.7.w;
    final imageHeight = 215.775.h;
    // deviceInfo.setDeviceInfo();

    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 44.5.h),
          width: 390.45.w,
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "床緣邊界設定",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Image.asset(
                        isWaiting
                            ? "assets/images/bedWaiting.png"
                            : "assets/images/bedWalking.png",
                        width: 369.9.w,
                      ),
                      SizedBox(height: 40.h),
                      GestureDetector(
                        onTap: () async {
                          // Add your onTap functionality here
                          if (!isCompleted) {
                            setState(() {
                              isWaiting = true;
                            });
                            final result = await getBoundaryImage(
                                deviceInfo.device[widget.index]["deviceId"],
                                deviceInfo,
                                imageWidth,
                                imageHeight);
                            if (result == "success") {}
                            else{
                              showDialog(
                                context: context,
                                builder: (context) => HttpAlertDialog(errorMessage: result),
                              );
                            }
                            setState(() {
                              isCompleted = true;
                            });
                          } else {
                            String result = await stopBoundarySetting(
                                deviceInfo.device[widget.index]["deviceId"]);
                            if (result == "success") {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BedSettingPage(index: widget.index)));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    HttpAlertDialog(errorMessage: result),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: (isCompleted && isWaiting)
                                ? Color(0xFF70B1B8)
                                : isWaiting
                                    ? Color(0xFFD9D9D9)
                                    : Color(0xFF70B1B8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "完成",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
