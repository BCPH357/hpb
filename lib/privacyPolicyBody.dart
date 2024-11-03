import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'longText.dart';
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

 class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
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
              width: 369.9.w,
              height: 623.h,
              decoration: BoxDecoration(
                color: Color(0xff70B1B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Container(
                  width: 337.89.w,
                  height: 561.h,
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
                              size: 30.w,
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: Text(
                              "Privacy Policy",
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
                        margin: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff70B1B8),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: 445.h,
                              child: SingleChildScrollView(
                              child: Text(
                                privacy,
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
