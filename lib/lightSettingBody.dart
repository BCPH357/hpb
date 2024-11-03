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
            divisions: 5,
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
            children: [0, 20, 40, 60, 80, 100]
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

class SingleCheckbox extends StatefulWidget {
  final double screenWidth;
  final int initialSelectedCheckbox; // 新增一個參數來設置初始選中的選項
  final int index;
  SingleCheckbox(
      {Key? key,
      required this.screenWidth,
      required this.index,
      this.initialSelectedCheckbox = 1 // 預設選中第一個選項
      })
      : super(key: key);

  @override
  _SingleCheckboxState createState() => _SingleCheckboxState();
}

class _SingleCheckboxState extends State<SingleCheckbox> {
  late int _selectedCheckbox;

  @override
  void initState() {
    super.initState();
    _selectedCheckbox = widget.initialSelectedCheckbox; // 使用傳入的初始值
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildCheckboxWithLabel(0, "白光"),
          _buildCheckboxWithLabel(1, "黃光"),
          _buildCheckboxWithLabel(2, "混光"),
        ],
      ),
    );
  }

  Widget _buildCheckboxWithLabel(int value, String label) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: true);
    return Expanded(
      child: Row(
        children: [
          Checkbox(
            value: _selectedCheckbox == value,
            onChanged: (bool? isChecked) async {
              setState(() {
                _selectedCheckbox = isChecked! ? value : -1;
              });
              String result = await setDeviceLightColor(deviceInfo.device[widget.index]["deviceId"], value);
              if (result == "success") {
              } else {
                showDialog(
                  context: context,
                  builder: (context) => HttpAlertDialog(errorMessage: result),
                );
              }
            },
            fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Color(0xff70B1B8);
                }
                return Colors.transparent;
              },
            ),
            side: BorderSide(color: Color(0xff70B1B8)),
          ),
          Text(
            label,
            style: TextStyle(
              color: Color(0xff757575),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class LightSetting extends StatefulWidget {
  final int index;
  final int mode;
  const LightSetting({super.key, required this.index, required this.mode});

  @override
  _LightSettingState createState() => _LightSettingState();
}
class _LightSettingState extends State<LightSetting> {
  late int selectedCheckbox;

  @override
  void initState() {
    super.initState();
    selectedCheckbox = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // autotune = deviceInfo.device[widget.index]["lightStatus"]["mode"] == 0 ? 1 : 0;
    // handTune = deviceInfo.device[widget.index]["lightStatus"]["mode"] == 1 ? 1 : 0;
    // moreSetting = deviceInfo.device[widget.index]["lightStatus"]["mode"] == 2 ? 1 : 0;
    // int autotune = deviceInfo.device[widget.index]["lightStatus"]["mode"] == 0 ? 1 : 0;
    // int handTune = deviceInfo.device[widget.index]["lightStatus"]["mode"] == 1 ? 1 : 0;
    // int moreSetting = deviceInfo.device[widget.index]["lightStatus"]["mode"] == 2 ? 1 : 0;

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
                        "燈光設定",
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
              SizedBox(height: 5.h),
              Container(
                margin: EdgeInsets.only(left: 20.w),
                child: Text(
                  "色溫",
                  style: TextStyle(
                    color: Color(0XFF757575),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SingleCheckbox(
                  screenWidth: 369.9.w,
                  index: widget.index,
                  initialSelectedCheckbox: deviceInfo.device[widget.index]
                      ["lightStatus"]["color"]),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                child: Divider(
                  color: Color(0XFF70B1B8), // 线的颜色
                  thickness: 1.0.w, // 线的厚度
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: selectedCheckbox == 1,
                    onChanged: (bool? value) async {
                      setState(() {
                        if (value == true) {
                          selectedCheckbox = 1;
                        } else if (selectedCheckbox == 1) {
                          selectedCheckbox = -1;
                        }
                      });
                      String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 1, null);
                      if (result == "success") {
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => HttpAlertDialog(errorMessage: result),
                        );
                      }
                    },
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Color(0xff70B1B8); // 选中时的颜色
                      }
                      return Colors.transparent; // 未选中时的颜色
                    }),
                    side: BorderSide(color: Color(0xff70B1B8)), // 边框颜色
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "自動調節",
                    style: TextStyle(
                      color: Color(0xff757575),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20.w),
                child: Text(
                  notice,
                  style: TextStyle(
                    color: selectedCheckbox == 1
                        ? Color(0xffE99E94)
                        : Color(0xff757575),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: selectedCheckbox == 0,
                    onChanged: (bool? value) async {
                      setState(() {
                        if (value == true) {
                          selectedCheckbox = 0;
                        } else if (selectedCheckbox == 0) {
                          selectedCheckbox = -1;
                        }
                      });
                      String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 0, deviceInfo.device[widget.index]["lightStatus"]["level"]);
                      if (result == "success") {
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => HttpAlertDialog(errorMessage: result),
                        );
                      }
                    },
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Color(0xff70B1B8); // 选中时的颜色
                      }
                      return Colors.transparent; // 未选中时的颜色
                    }),
                    side: BorderSide(color: Color(0xff70B1B8)), // 边框颜色
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "手動調節",
                    style: TextStyle(
                      color: Color(0xff757575),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SliderWidget(
                initialValue: deviceInfo.device[widget.index]["lightStatus"]
                        ["level"]
                    .toDouble(),
                onChanged: (value) async {
                  print("Slider value: $value");
                  String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 0, value);
                  if (result == "success") {
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => HttpAlertDialog(errorMessage: result),
                    );
                  }
                },
                isEnabled: selectedCheckbox == 0, // 确保这里为 true
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                child: Divider(
                  color: Color(0XFF70B1B8), // 线的颜色
                  thickness: 1.0, // 线的厚度
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: selectedCheckbox == 2,
                    onChanged: (bool? value) async {
                      setState(() {
                        if (value == true) {
                          selectedCheckbox = 2;
                        } else if (selectedCheckbox == 2) {
                          selectedCheckbox = -1;
                        }
                      });
                      String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 2, deviceInfo.device[widget.index]["lightStatus"]["advencedLevel"]);
                      if (result == "success") {
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => HttpAlertDialog(errorMessage: result),
                        );
                      }
                    },
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Color(0xff70B1B8); // 选中时的颜色
                      }
                      return Colors.transparent; // 未选中时的颜色
                    }),
                    side: BorderSide(color: Color(0xff70B1B8)), // 边框颜色
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "進階設定",
                    style: TextStyle(
                      color: Color(0xff757575),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              selectedCheckbox == 2
                  ? Expanded(
                      child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 8,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Text(
                                    "在床",
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SliderWidget(
                                  initialValue: deviceInfo.device[widget.index]
                                          ["lightStatus"]["advencedLevel"]
                                          ["onBed"]
                                      .toDouble(),
                                  onChanged: (value) async {
                                    print("Slider value: $value");
                                    deviceInfo.setLightLevel(widget.index, "onBed", value);
                                    String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 2, deviceInfo.device[widget.index]["lightStatus"]["advencedLevel"]);
                                    if (result == "success") {
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => HttpAlertDialog(errorMessage: result),
                                      );
                                    }
                                  },
                                  isEnabled: selectedCheckbox == 2, // 确保这里为 true
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Text(
                                    "坐床上",
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SliderWidget(
                                  initialValue: deviceInfo.device[widget.index]
                                          ["lightStatus"]["advencedLevel"]
                                          ["rise"]
                                      .toDouble(),
                                  onChanged: (value) async {
                                    print("Slider value: $value");
                                    deviceInfo.setLightLevel(widget.index, "rise", value);
                                    String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 2, deviceInfo.device[widget.index]["lightStatus"]["advencedLevel"]);
                                    if (result == "success") {
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => HttpAlertDialog(errorMessage: result),
                                      );
                                    }
                                  },
                                  isEnabled: selectedCheckbox == 2, // 确保这里为 true
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Text(
                                    "坐在床邊",
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SliderWidget(
                                  initialValue: deviceInfo.device[widget.index]
                                          ["lightStatus"]["advencedLevel"]
                                          ["sitSide"]
                                      .toDouble(),
                                  onChanged: (value) async {
                                    print("Slider value: $value");
                                    deviceInfo.setLightLevel(widget.index, "sitSide", value);
                                    String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 2, deviceInfo.device[widget.index]["lightStatus"]["advencedLevel"]);
                                    if (result == "success") {
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => HttpAlertDialog(errorMessage: result),
                                      );
                                    } 
                                  },
                                  isEnabled: selectedCheckbox == 2, // 确保这里为 true
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Text(
                                    "不在床",
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SliderWidget(
                                  initialValue: deviceInfo.device[widget.index]
                                          ["lightStatus"]["advencedLevel"]
                                          ["offBed"]
                                      .toDouble(),
                                  onChanged: (value) async {
                                    print("Slider value: $value");
                                    deviceInfo.setLightLevel(widget.index, "offBed", value);
                                    String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 2, deviceInfo.device[widget.index]["lightStatus"]["advencedLevel"]);
                                    if (result == "success") {
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => HttpAlertDialog(errorMessage: result),
                                      );
                                    }
                                  },
                                  isEnabled: selectedCheckbox == 2, // 确保这里为 true
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Text(
                                    "無人",
                                    style: TextStyle(
                                      color: Color(0xff757575),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SliderWidget(
                                  initialValue: deviceInfo.device[widget.index]
                                          ["lightStatus"]["advencedLevel"]
                                          ["empty"]
                                      .toDouble(),
                                  onChanged: (value) async {
                                    print("Slider value: $value");
                                    deviceInfo.setLightLevel(widget.index, "empty", value);
                                    String result = await setDeviceLight(deviceInfo.device[widget.index]["deviceId"], 2, deviceInfo.device[widget.index]["lightStatus"]["advencedLevel"]);
                                    if (result == "success") {
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => HttpAlertDialog(errorMessage: result),
                                      );
                                    }
                                  },
                                    isEnabled: selectedCheckbox == 2, // 确保这里为 true
                                  ),
                                // 在这里添加更多的 Container 或其他 Widgets
                              ],
                            ),
                          )))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
