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
import 'bedWalkingPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';
class SwitchButton extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChanged;

  const SwitchButton({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
        });
        widget.onChanged(_isOn);
      },
      child: Container(
        width: 60.w,
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _isOn ? Color(0xff70B1B8) : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 200),
          alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26.w,
            height: 26.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class BedExplain extends StatefulWidget {
  final int index;
  final bool isOn;

  BedExplain({super.key, required this.index, required this.isOn});

  @override
  _BedExplainState createState() => _BedExplainState();
}

class _BedExplainState extends State<BedExplain> {
  late bool isOpen;
  @override
  void initState() {
    super.initState();
    isOpen = widget.isOn;
    print(isOpen);
  }
  

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // deviceInfo.setDeviceInfo();

    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 44.5.h),
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
                        "床緣邊界設定",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    SizedBox(width: 30.w),
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "床緣邊界設定",
                            style: TextStyle(
                              color: Color(0xff797471),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          SizedBox(width: 10.w),
                          SwitchButton(
                            initialValue: isOpen,
                            onChanged: (value) async {
                              String result = await updateBoundarySetting(
                                  deviceInfo.device[widget.index]["deviceId"], value == true ? 1 : 0);
                              if (result == "success") {
                                setState(() {
                                  isOpen = value;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => HttpAlertDialog(errorMessage: result),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Image.asset(
                        "assets/images/bedExplain.png",
                        width: MediaQuery.of(context).size.width - 80.w,
                        fit: BoxFit.fitWidth,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Add your onTap functionality here
                          print('Container tapped');
                        },
                        child: GestureDetector(
                          onTap: () async {
                            if (isOpen) {
                              String result = await startBoundarySetting(
                                  deviceInfo.device[widget.index]["deviceId"]);
                              if (result == "success") {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => BedWalkingPage(index: widget.index)));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => HttpAlertDialog(errorMessage: result),
                                );
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: isOpen ? Color(0xFF70B1B8) : Color(0xffD9D9D9),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              '開始設定',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
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
