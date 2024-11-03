import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homePage.dart';
import 'mult_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BedComplete extends StatefulWidget {
  final int index;

  const BedComplete({super.key, required this.index});

  @override
  _BedCompleteState createState() => _BedCompleteState();
}

class _BedCompleteState extends State<BedComplete> {
  bool isComplete = true;
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    final imageWidth = 287.7.w;
    final imageHeight = 215.775.h;
    // deviceInfo.setDeviceInfo();

    return Center(
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Image.asset(
                              "assets/images/bedSetting.png",
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.contain,
                      ), 
                      SizedBox(height: 40.h),
                      isComplete
                          ? Text(
                              "上傳完成",
                              style: TextStyle(
                                color: Color(0xFF757575),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : SizedBox(),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your button action here
                            setState(() {
                              isComplete = true;
                            });
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isComplete
                                ? Color(0xFF70B1B8)
                                : Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 10.h),
                          ),
                          child: Text(
                            isComplete ? '點擊返回首頁' : '確定上傳',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
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
