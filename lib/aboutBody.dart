import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'longText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _AboutState createState() => _AboutState();
}

 class _AboutState extends State<About> {
  bool isEmergency = true;
  bool isEvent = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // emergency.setEmergency();
    // deviceInfo.setDeviceInfo();

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8.22.w, vertical: 26.7.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Container(
              width: 370.w,
              height: 623.h,
              decoration: BoxDecoration(
                color: Color(0xff70B1B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  width: 370.w,
                  height: 623.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              color: Color(0xff757575),
                              Icons.arrow_back,
                              size: 30.sp,
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: Text(
                              "關於我們",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                          SizedBox(width: 30.w),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff70B1B8),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Container(
                              height: 445.h,
                              child: SingleChildScrollView(
                              child: Text(
                                about,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                ),
                              ),
                            )
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
