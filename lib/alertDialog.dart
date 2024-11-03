import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mult_provider.dart';
import 'restfulApi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HttpAlertDialog extends StatelessWidget {
  final String errorMessage;
  const HttpAlertDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 356.h,
        width: 390.45.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 10.h),
            Expanded(
              child: Container(
                width: 267.15.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Spacer(),
                    Image.asset(
                      'assets/icons/bigWarning.png',
                    ),
                    SizedBox(height: 20.h),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Color(0xffE99194),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Spacer(),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '關閉',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xffffffff),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff757575),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(5),
                        minimumSize: Size(double.infinity, 36), // Set the width to infinity
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}