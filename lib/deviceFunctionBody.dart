import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hpb/stateLightManualBody.dart';
import 'package:hpb/stateLightManualPage.dart';
import 'package:hpb/voiceSettingPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'bedExplainPage.dart';
import 'lightSettingBody.dart';
import 'mult_provider.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'voiceSettingBody.dart';
import 'lightSettingPage.dart';
import 'restfulApi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';

class DeleteAlertDialog extends StatelessWidget {
  final int index;
  const DeleteAlertDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: screenHeight * 0.4,
        width: screenWidth * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        // color: Colors.green,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: Container(
                // color: Colors.red,
                width: screenWidth * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "客廳警告一覽",
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    SizedBox(height: 15.h),
                    ...List<Widget>.generate(
                        deviceInfo.device[index]["warnings"].length, (i) {
                      var warning = deviceInfo.device[index]["warnings"][i];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/warning.png',
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                deviceInfo.setDeviceWarningHash(warning),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                        ],
                      );
                    })
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

class ResetAlertDialog extends StatelessWidget {
  final String option;
  final int index;
  ResetAlertDialog({required this.option, required this.index});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: true);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
            height: 356.h,
            width: 370.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            // color: Colors.green,

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/bigWarning.png',
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        '警告',
                        style: TextStyle(
                            fontSize: 23.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  option == "wifi"
                      ? Column(
                          children: [
                            Text(
                              '確定要重設網路連線嗎?',
                              style: TextStyle(
                                  fontSize: 23.sp, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '執行後需重新增裝置',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffE99194)),
                            ),
                          ],
                        )
                      : Container(
                          child: Text(
                            '確定要重啟設備嗎?',
                            style: TextStyle(
                                fontSize: 23.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 110, 110, 110),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // 执行重置或重启操作
                          if (option == "wifi") {
                            String result = await resetDevice(
                                deviceInfo.device[index]["deviceId"]);
                            if (result == "success") {
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    HttpAlertDialog(errorMessage: result),
                              );
                            }
                          } else {
                            String result = await restartDevice(
                                deviceInfo.device[index]["deviceId"]);
                            if (result == "success") {
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    HttpAlertDialog(errorMessage: result),
                              );
                            }
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('確定'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff70B1B8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}

class ReNameAlertDialog extends StatelessWidget {
  final int index;
  const ReNameAlertDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: true);
    TextEditingController _deviceNameController = TextEditingController();
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
        // color: Colors.green,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                    "重新命名裝置",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
                SizedBox(width: 30.w),
              ],
            ),
            Expanded(
              child: Container(
                // color: Colors.red,
                width: 205.5.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '裝置名稱',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _deviceNameController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.w),
                          border: InputBorder.none,
                          hintText: deviceInfo.device[index]["name"],
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // Add your button action here
                              String result = await updateDeviceName(
                                  deviceInfo.device[index]["deviceId"],
                                  _deviceNameController.text,
                                  deviceInfo);
                              if (result == "success") {
                                Navigator.pop(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      HttpAlertDialog(errorMessage: result),
                                );
                              }
                            },
                            child: Text(
                              '確認',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff70B1B8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 15.h),
                            ),
                          ),
                        ),
                      ],
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

class SwitchButton extends StatefulWidget {
  final int index;
  final bool initialValue;
  final Function(bool) onChanged;

  const SwitchButton({
    Key? key,
    required this.index,
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
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: true);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return GestureDetector(
      onTap: () async {
        setState(() {
          _isOn = !_isOn;
        });

        widget.onChanged(_isOn);
        print(_isOn);
        String result = await setDeviceSentryMode(
            deviceInfo.device[widget.index]["deviceId"], _isOn ? 1 : 0);
        if (result == "success") {
        } else {
          showDialog(
            context: context,
            builder: (context) => HttpAlertDialog(errorMessage: result),
          );
        }
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

class DeviceFunction extends StatelessWidget {
  final int index; // 添加一个 int 类型的成员变量来存储传入的 index

  // 修改构造函数以接受一个 index 参数
  const DeviceFunction({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: true);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // deviceInfo.setDeviceInfo();

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.5.h),
        width: 390.45.w,
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF), // 背景颜色
          borderRadius: BorderRadius.circular(20), // 设置圆角半径
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Column(
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
                      deviceInfo.device[index]["name"],
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                  SizedBox(width: 30.w),
                ],
              ),
              SizedBox(height: 5.h),
              Container(
                margin: EdgeInsets.only(bottom: 10.h),
                height: 115.7.h,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // 阴影颜色
                      spreadRadius: 1, // 阴影扩散半径
                      blurRadius: 5, // 阴影模糊半径
                      offset: Offset(0, 4), // 阴影偏移量（x轴为0，y轴为3，表示阴影在下方）
                    ),
                  ],
                  color: deviceInfo.device[index]["status"] == "connected"
                      ? Color(0XFF98CDD4)
                      : Color(0xffb3b3b3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    InkWell(
                      onTap: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return ReNameAlertDialog(index: index);
                          },
                        );
                      },
                      child: Container(
                        width: 102.35.w,
                        height: 102.35.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                deviceInfo.device[index]["name"].length > 3
                                    ? '${deviceInfo.device[index]["name"].substring(0, 3)}...'
                                    : deviceInfo.device[index]["name"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ReNameAlertDialog(index: index);
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0XFFD9D9D9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/deviceNameRevised.png',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Image.asset(
                                      deviceInfo.device[index]["status"] ==
                                              "connected"
                                          ? 'assets/icons/temperature.png'
                                          : 'assets/icons/disconnected.png',
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      deviceInfo.device[index]["status"] ==
                                              "connected"
                                          ? "${deviceInfo.device[index]["temperature"].toString()}°C"
                                          : "",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    if (deviceInfo.device[index]["status"] ==
                                        "connected") ...[
                                      for (var icon in deviceInfo.device[index]
                                              ["behavioralType"] ??
                                          []) ...[
                                        icon == "NO_PEOPLE"
                                            ? SizedBox(height: 10.h)
                                            : Image.asset(
                                                deviceInfo.setImageHash(icon)),
                                        SizedBox(width: 5.w),
                                      ],
                                    ],
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                // deviceInfo.device[index][
                                //             "behavioralType"] !=
                                //         "NO_PEOPLE"
                                //     ? Image.asset(
                                //         deviceInfo.setImageHash(
                                //             deviceInfo.device[
                                //                     index][
                                //                 "behavioralType"]),
                                //       )
                                //     : SizedBox(height: 10.h),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      (deviceInfo.device[index]["status"] ==
                                                  "connected" &&
                                              deviceInfo
                                                  .device[index]["warnings"]
                                                  .isNotEmpty)
                                          ? Image.asset(
                                              'assets/icons/warning.png',
                                            )
                                          : SizedBox(),
                                      SizedBox(width: 10.w),
                                      Text(
                                        (deviceInfo.device[index]["status"] ==
                                                    "connected" &&
                                                deviceInfo
                                                    .device[index]["warnings"]
                                                    .isNotEmpty)
                                            ? "${deviceInfo.setDeviceWarningHash(deviceInfo.device[index]["warnings"][0].toString())}"
                                            : "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  (deviceInfo.device[index]["status"] ==
                                              "connected" &&
                                          deviceInfo.device[index]["warnings"]
                                              .isNotEmpty)
                                      ? InkWell(
                                          onTap: () {
                                            // Add action for tap here
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DeleteAlertDialog(
                                                      index: index),
                                            );
                                          },
                                          child: Text(
                                            "...更多警告",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  Spacer(), // This empty SizedBox will push the Row to the top
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0XFF98CDD4), // 边框颜色
                      width: 1.2, // 边框宽度
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/sentinel.png',
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          '哨兵模式',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xff757575),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '開關',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xff757575),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        SwitchButton(
                          index: index,
                          initialValue: deviceInfo.device[index]
                                      ["behavioralType"]
                                  .contains("SENTRY_MODE")
                              ? true
                              : false,
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 10.h),
              Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0XFF98CDD4), // 边框颜色
                      width: 1.2, // 边框宽度
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            String result = await getDeviceSettings(
                                deviceInfo.device[index]["deviceId"],
                                deviceInfo,
                                index);
                            if (result == "success") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LightSettingPage(
                                        index: index,
                                        mode: deviceInfo.device[index]
                                            ["lightStatus"]["mode"])),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    HttpAlertDialog(errorMessage: result),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/light.png',
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                '燈光設定',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        InkWell(
                          onTap: () async {
                            String result = await getDeviceSettings(
                                deviceInfo.device[index]["deviceId"],
                                deviceInfo,
                                index);
                            if (result == "success") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VoiceSettingPage(index: index)),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    HttpAlertDialog(errorMessage: result),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/voice.png',
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                '聲音設定',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        InkWell(
                          onTap: () async {
                            String result = await getDeviceSettings(
                                deviceInfo.device[index]["deviceId"],
                                deviceInfo,
                                index);
                            if (result == "success") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BedExplainPage(
                                        index: index,
                                        isOn: deviceInfo.device[index]
                                                        ["boundaryParameters"]
                                                    ["status"] ==
                                                1
                                            ? true
                                            : false)),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    HttpAlertDialog(errorMessage: result),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/bed.png',
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                '床緣邊界設定',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StateLightManualPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/stateLight.png',
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                '狀態指示燈說明',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        InkWell(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true, // 允许点击外部关闭
                              context: context,
                              builder: (BuildContext context) {
                                return ResetAlertDialog(
                                    option: "wifi", index: index);
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/resetWifi.png',
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                '重置網路連線',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        InkWell(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true, // 允许点击外部关闭
                              context: context,
                              builder: (BuildContext context) {
                                return ResetAlertDialog(
                                    option: "device", index: index);
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/resetDevice.png',
                              ),
                              SizedBox(width: 20.w),
                              Column(
                                children: [
                                  Text(
                                    '重啟設備',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xff757575),
                                    ),
                                  ),
                                  Text(
                                    '設備異常時使用',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Color(0xff757575),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
