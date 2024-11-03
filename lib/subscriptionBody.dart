import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool basic = true;
  bool premium = false;
  bool ultimate = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));

    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    // emergency.setEmergency();
    // deviceInfo.setDeviceInfo();

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8.22.w, vertical: 17.8.h),
        child: Container(
          height: 801.h,
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
                      color: Color(0xff757575),
                      Icons.arrow_back,
                      size: 30.w,
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: Text(
                      "訂閱服務",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                  SizedBox(width: 30.w),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  SizedBox(width: 40.w),
                  Text(
                    "配對即想",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff757575),
                    ),
                  ),
                  Text(
                    "30天",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff70B1B8),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.w),
                child: Text(
                  "免費試用Premium服務",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff757575),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 1.h,
                color: Color(0xff70B1B8),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                basic ? Color(0xff70B1B8) : Colors.transparent,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Basic",
                                    style: TextStyle(
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff70B1B8)),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your button action here
                                      setState(() {
                                        basic = true;
                                        premium = false;
                                        ultimate = false;
                                      });
                                    },
                                    child: Text(
                                      basic ? "目前" : "訂閱",
                                      style: TextStyle(
                                        color: basic
                                            ? Colors.white
                                            : Color(0xff70B1B8),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: basic
                                          ? Color(0xff70B1B8)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: basic
                                              ? Colors.transparent
                                              : Color(0xff70B1B8),
                                          width: 1,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 2.h),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "免費",
                                style: TextStyle(
                                  color: Color(0xff70B1B8),
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "內建基本功能:\n行為偵測、跌倒示警、環境監測、意外通知",
                                style: TextStyle(
                                  color: Color(0xff757575),
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                premium ? Color(0xff70B1B8) : Colors.transparent,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Premium",
                                    style: TextStyle(
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff70B1B8)),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your button action here
                                      setState(() {
                                        basic = false;
                                        premium = true;
                                        ultimate = false;
                                      });
                                    },
                                    child: Text(
                                      premium ? "目前" : "訂閱",
                                      style: TextStyle(
                                        color: premium
                                            ? Colors.white
                                            : Color(0xff70B1B8),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: premium
                                          ? Color(0xff70B1B8)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: premium
                                              ? Colors.transparent
                                              : Color(0xff70B1B8),
                                          width: 1,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 2.h),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "NT\$99/月",
                                style: TextStyle(
                                  color: Color(0xff70B1B8),
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Basic方案加上:\n行為、睡眠分析資訊保留30天",
                                style: TextStyle(
                                  color: Color(0xff757575),
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                ultimate ? Color(0xff70B1B8) : Colors.transparent,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Ultimate",
                                    style: TextStyle(
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff70B1B8)),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your button action here
                                      setState(() {
                                        basic = false;
                                        premium = false;
                                        ultimate = true;
                                      });
                                    },
                                    child: Text(
                                      ultimate ? "目前" : "訂閱",
                                      style: TextStyle(
                                        color: ultimate
                                            ? Colors.white
                                            : Color(0xff70B1B8),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ultimate
                                          ? Color(0xff70B1B8)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: ultimate
                                              ? Colors.transparent
                                              : Color(0xff70B1B8),
                                          width: 1,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 2.h),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "NT\$999/年",
                                style: TextStyle(
                                  color: Color(0xff70B1B8),
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Basic方案加上:\n行為、睡眠分析資訊保留資料1年",
                                style: TextStyle(
                                  color: Color(0xff757575),
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
