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
import 'restfulApi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';
class SliderWidget extends StatefulWidget {
  final double initialValue;
  final Function(double)? onChanged;
  final bool isEnabled;

  SliderWidget(
      {Key? key,
      required this.initialValue,
      this.onChanged,
      this.isEnabled = true})
      : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double _currentSliderValue;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Color(0xff70B1B8), // 活动部分的颜色
            inactiveTrackColor: Color(0xff808080), // 非活动部分的颜色
            thumbColor: Color(0xff70B1B8), // 滑块颜色
            disabledActiveTrackColor: Color(0xff757575), // 禁用状态下活动部分的颜色
            disabledInactiveTrackColor: Color(0xff757575), // 禁用状态下非活动部分的颜色
            disabledThumbColor: Color(0xff757575), // 禁用状态下滑块的颜色
          ),
          child: Slider(
            value: _currentSliderValue,
            min: 0,
            max: 100,
            divisions: 3,
            onChanged: widget.isEnabled
                ? (double value) {
                    setState(() {
                      _currentSliderValue = value; // 在这里更新 _currentSliderValue
                      if (widget.onChanged != null) {
                        widget.onChanged!(value); // 调用外部传入的 onChanged
                      }
                    });
                  }
                : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [0, 60, 80, 100]
                .map((e) => Text(
                      e.toString(),
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class CustomDropdown extends StatefulWidget {
  @override
  _CustomDropdownState createState() => _CustomDropdownState();
  final int index;
  final String initialValue;
  
  CustomDropdown({super.key, required this.index, required this.initialValue});
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 61.65.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0), // 內部間距
      decoration: BoxDecoration(
        color: Colors.white, // 白色背景
        border: Border.all(color: Color(0xffD9D9D9)), // 灰色邊框
        borderRadius: BorderRadius.circular(8), // 圓角邊框
      ),
      child: DropdownButton<String>(
        isExpanded: true, // 讓下拉選單展開填滿容器
        value: dropdownValue, // 當前選中的值
        icon: const Icon(Icons.arrow_drop_down), // 下拉箭頭圖標
        elevation: 16, // 下拉列表的陰影高度
        style: const TextStyle(color: Colors.black), // 文本樣式
        underline: Container(
          height: 2,
          color: Colors.transparent,
        ),
        onChanged: (String? newValue) async {
          setState(() {
            dropdownValue = newValue!;
          });
          String result = await setDeviceSpeakerLanguage(deviceInfo.device[widget.index]["deviceId"], 
          dropdownValue == "中文" ? 0 :
          dropdownValue == "English" ? 1 :
          dropdownValue == "日文" ? 2 :
          dropdownValue == "德文" ? 3 :
          -1);
          if (result == "success") {
          } else {
            showDialog(
              context: context,
              builder: (context) => HttpAlertDialog(errorMessage: result),
            );
          }
        },
        items: <String>['中文', 'English', "日文", "德文"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.w, vertical: 0), // 調整文字的 padding
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class VoiceSetting extends StatefulWidget {
  final int index;
  const VoiceSetting({super.key, required this.index});

  @override
  _VoiceSettingState createState() => _VoiceSettingState();
}

class _VoiceSettingState extends State<VoiceSetting> {
  
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
                        "聲音設定",
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
              SizedBox(height: 133.5.h),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 61.65.w),
                      child: Text(
                        "語音撥放語言",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    CustomDropdown(
                      index: widget.index,
                      initialValue: deviceInfo.device[widget.index]["speakerStatus"]["mode"] == 0 ? "中文" :
                                    deviceInfo.device[widget.index]["speakerStatus"]["mode"] == 1 ? "English" :
                                    deviceInfo.device[widget.index]["speakerStatus"]["mode"] == 2 ? "日文" :
                                    deviceInfo.device[widget.index]["speakerStatus"]["mode"] == 3 ? "德文" :
                                    "其他"
                    ),
                    SizedBox(height: 62.3.h),
                    Container(
                      margin: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "音量",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SliderWidget(
                      initialValue: deviceInfo.device[widget.index]["speakerStatus"]["volumeValue"].toDouble(),
                      onChanged: (value) async {
                        String result = await setDeviceSpeakerVolume(deviceInfo.device[widget.index]["deviceId"], value.toInt());
                        if (result == "success") {
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => HttpAlertDialog(errorMessage: result),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      margin: EdgeInsets.only(left: 20.w),
                      height: 200.h, // Subtracting approximate heights of other widgets
                      child: SingleChildScrollView(
                        child: Text(
                          warning,
                          style: TextStyle(
                            color: Color(0xffE99E94),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
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
    );
  }
}
