import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'homePage.dart';
import 'mult_provider.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'restfulApi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';
import 'qrCode.dart';

class SelectDeviceAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, designSize: Size(411, 890));
    return AlertDialog(
        content: Container(
      height: 350.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "搜尋裝置",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          InkWell(
            onTap: () {
              // 这里可以定义点击时的逻辑
              
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScanPage()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/qrcode.png',
                    width: 100.w,
                    height: 100.h,
                  ),
                  Spacer(),
                  Text(
                    "掃描搜尋",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.black, // 线的颜色
                  thickness: 1, // 线的厚度
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  '或',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // 这里可以定义点击时的逻辑
              print('整個 Row 被點擊了');
              Navigator.pop(context);
              showDialog(
                barrierDismissible: true, // 允许点击外部关闭
                context: context,
                builder: (BuildContext context) {
                  return P1WifiAlertDialog();
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/wifi.png',
                    width: 100.w,
                    height: 100.h,
                  ),
                  Spacer(),
                  Text(
                    "手動選擇",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class P1WifiAlertDialog extends StatefulWidget {
  @override
  _P1WifiAlertDialogState createState() => _P1WifiAlertDialogState();
}

class _P1WifiAlertDialogState extends State<P1WifiAlertDialog> {
  List<WiFiAccessPoint> _wifiList = [];

  @override
  void initState() {
    super.initState();
    _checkLocationServices();
  }

//下面三個function gpt生的
  Future<void> _checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _scanForWiFiNetworks();
    } else {
      // Handle the case when the permission is not granted
    }
  }

  Future<void> _scanForWiFiNetworks() async {
    await WiFiScan.instance.startScan();
    final results = await WiFiScan.instance.getScannedResults();

    setState(() {
      _wifiList = results;
      print(_wifiList[0].ssid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return AlertDialog(
      content: Container(
        height: 623.h,
        width: 328.8.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "請選擇P1 wifi",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Positioned(
                      left: 0,
                      child: Image.asset(
                        'assets/icons/pageBack.png',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Expanded widget ensures that the list has proper space
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(_wifiList.length, (index) {
                    if (_wifiList[index].ssid.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () async {
                        if (deviceInfo.ezCaringTemp.isEmpty) {
                          try {
                            deviceInfo.setEzCaringTemp(_wifiList[index].ssid);
                            bool shouldOpenSettings =
                                true; // Set to true to open native settings
                            await WiFiForIoTPlugin.setEnabled(true,
                                shouldOpenSettings: shouldOpenSettings);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please connect to ${_wifiList[index].ssid} from your system settings.')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Failed to open settings: $e')),
                            );
                          }
                        } else {
                          String connectedSSID =
                              await WiFiForIoTPlugin.getSSID() ?? "";
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Currently connected to: $connectedSSID')),
                          );
                          print("connectedSSID");
                          //0425659188
                          print(connectedSSID);
                          if (connectedSSID.contains("EZCARING")) {
                            String res = await getDeviceApiInfo(deviceInfo);
                            if (res == "success") {
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    HttpAlertDialog(errorMessage: res),
                              );
                            }
                            try {
                              String password = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController passwordController =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text('Enter Wi-Fi Password'),
                                    content: TextField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                      ),
                                      obscureText: true,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () async {
                                          Navigator.of(context)
                                              .pop(passwordController.text);
                                          deviceInfo.setWifiTemp(
                                              _wifiList[index].ssid);
                                          deviceInfo.setWifiPasswordTemp(
                                              passwordController.text);
                                          // bool shouldOpenSettings =
                                          //     true; // Set to true to open native settings
                                          // await WiFiForIoTPlugin.setEnabled(
                                          //     true,
                                          //     shouldOpenSettings:
                                          //         shouldOpenSettings);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //   SnackBar(
                                          //       content: Text(
                                          //           'Please connect to ${_wifiList[index].ssid} from your system settings.')
                                          //           ),
                                          // );
                                          final result = await configureDevice(
                                              _wifiList[index].ssid,
                                              passwordController.text,
                                              deviceInfo.ezCaringData["mac"]);
                                          if (result == "success") {
                                            // Navigator.pop(context);
                                            final result =
                                                await switchDeviceMode(
                                                    deviceInfo
                                                        .ezCaringData["mac"],
                                                    "station",
                                                    deviceInfo);
                                            if (result == "success") {
                                              // Navigator.pop(context);
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    HttpAlertDialog(
                                                        errorMessage: result),
                                              );
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  HttpAlertDialog(
                                                      errorMessage: result),
                                            );
                                          }
                                          // WidgetsBinding.instance
                                          //     .addPostFrameCallback((_) {
                                          //   if (mounted) {
                                          //     showDialog(
                                          //       context: context,
                                          //       builder:
                                          //           (BuildContext context) {
                                          //         return AlertDialog(
                                          //           title: Text('提示'),
                                          //           content: Text('請切回自己的網路'),
                                          //           actions: <Widget>[
                                          //             TextButton(
                                          //               child: Text('OK'),
                                          //               onPressed: () {
                                          //                 Navigator.of(context, rootNavigator: true).pop();
                                          //                 WidgetsBinding.instance.addPostFrameCallback((_) async {
                                          //                   bool shouldOpenSettings = true; // Set to true to open native settings
                                          //                   await WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: shouldOpenSettings);
                                          //                   ScaffoldMessenger.of(context).showSnackBar(
                                          //                     SnackBar(content: Text('Please connect to ${_wifiList[index].ssid} from your system settings.')),
                                          //                   );
                                          //                 });
                                          //               },
                                          //             ),
                                          //           ],
                                          //         );
                                          //       },
                                          //     );
                                          //   }
                                          // });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              // if (password != null) {
                              //   await WiFiForIoTPlugin.connect(
                              //     _wifiList[index].ssid,
                              //     password: password,
                              //   );
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content: Text(
                              //             'Connected to ${_wifiList[index].ssid}')),
                              //   );
                              //   deviceInfo.setWifiTemp(_wifiList[index].ssid);
                              //   Navigator.pop(context);
                              // }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to connect: $e')),
                              );
                              // deviceInfo.killEzCaringTemp();
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Connection Alert'),
                                  content: Text('Device not connected'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        deviceInfo.killEzCaringTemp();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 5.h),
                          height: 53.4.h,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/smallWifi.png',
                                width: 35.6.w,
                                height: 35.6.h,
                              ),
                              SizedBox(
                                width: 12.33.w,
                              ),
                              Expanded(
                                child: Text(
                                  _wifiList[index].ssid,
                                  style: TextStyle(
                                    color: Color(0XFF757575),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'assets/icons/lock.png',
                                width: 35.6.w,
                                height: 35.6.h,
                              ),
                            ],
                          )),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReNameAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _deviceNameController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return AlertDialog(
      content: Container(
        color: Colors.white,
        height: 623.h,
        width: 328.8.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "修改裝置名稱",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Positioned(
                      left: 0,
                      child: Image.asset(
                        'assets/icons/pageBack.png',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "新裝置名稱",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _deviceNameController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.w),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      ElevatedButton(
                        onPressed: () {
                          deviceInfo.setDeviceName(_deviceNameController.text);
                          Navigator.pop(context);
                        },
                        child: Text('確認',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFF70B1B8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "提示: 命名文字不可超過6字",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddDevice extends StatelessWidget {
  const AddDevice({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context);
    ScreenUtil.init(context, designSize: Size(411, 890));

    return Center(
      child: Container(
        margin: EdgeInsets.only(
          left: 20.55.w,
          right: 20.55.w,
          top: 40.h,
          bottom: 178.h,
        ),
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF), // 背景颜色
          borderRadius: BorderRadius.circular(20), // 设置圆角半径
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "新增裝置",
                      style: TextStyle(
                        color: Color(0XFF757575),
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        deviceInfo.killStatus();
                      },
                      child: Image.asset(
                        'assets/icons/X.png',
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 62.3.h,
            ),
            // 使用 Expanded 包裹 ListView.builder
            deviceInfo.ezCaringTemp.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: 2, // 设置项的数量
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0), // 每个项的间距
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: 53.43.w, right: 53.43.w),
                                    height: 80.2.h, // 容器高度
                                    decoration: BoxDecoration(
                                      color: Colors.white, // 背景颜色
                                      borderRadius:
                                          BorderRadius.circular(10), // 设置圆角半径
                                      border: Border.all(
                                        color: const Color(0XFF70B1B8), // 边框颜色
                                        width: 1.5, // 边框宽度
                                      ),
                                    ),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.w,
                                                top: 8.h,
                                                right: 8.w),
                                            child: Row(
                                              children: [
                                                Text(
                                                  deviceInfo.deviceName == ""
                                                      ? "裝置"
                                                      : deviceInfo.deviceName,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Spacer(),
                                                Image.asset(
                                                  'assets/icons/connect.png',
                                                  width: 18.w,
                                                  height: 18.h,
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.w, right: 8.w),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${deviceInfo.ezCaringTemp}",
                                                  style: TextStyle(
                                                    color: Color(0XFF757575),
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "已連線",
                                                  style: TextStyle(
                                                    color: Color(0XFF757575),
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              )
                            : deviceInfo.wifiTemp.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(8.0.w), // 每个项的间距
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: 53.43.w, right: 53.43.w),
                                        height: 71.2.h, // 容器高度
                                        decoration: BoxDecoration(
                                          color: Colors.white, // 背景颜色
                                          borderRadius: BorderRadius.circular(
                                              10), // 设置圆角半径
                                          border: Border.all(
                                            color:
                                                const Color(0XFF70B1B8), // 边框颜色
                                            width: 1.5, // 边框宽度
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              barrierDismissible:
                                                  true, // 允许点击外部关闭
                                              context: context,
                                              builder: (BuildContext context) {
                                                return P1WifiAlertDialog();
                                              },
                                            );
                                          },
                                          child: Container(
                                            child: Center(
                                              child: Text(
                                                "點選新增wifi",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(8.0.w), // 每个项的间距
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: 53.43.w, right: 53.43.w),
                                        height: 80.2.h, // 容器高度
                                        decoration: BoxDecoration(
                                          color: Colors.white, // 背景颜色
                                          borderRadius: BorderRadius.circular(
                                              10), // 设置圆角半径
                                          border: Border.all(
                                            color:
                                                const Color(0XFF70B1B8), // 边框颜色
                                            width: 1.5, // 边框宽度
                                          ),
                                        ),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.w,
                                                    top: 8.h,
                                                    right: 8.w),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "wifi",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Image.asset(
                                                      'assets/icons/connect.png',
                                                      width: 18.w,
                                                      height: 18.h,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.w, right: 8.w),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${deviceInfo.wifiTemp}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0XFF757575),
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "已連線",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0XFF757575),
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  );
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 53.43.w, right: 53.43.w),
                    height: 71.2.h, // 容器高度
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // 阴影颜色
                          spreadRadius: 1, // 阴影扩散半径
                          blurRadius: 5, // 阴影模糊半径
                          offset: Offset(0, 4), // 阴影偏移量（x轴为0，y轴为3，表示阴影在下方）
                        ),
                      ],
                      color: Colors.white, // 背景颜色
                      borderRadius: BorderRadius.circular(10), // 设置圆角半径
                      border: Border.all(
                        color: const Color(0XFF70B1B8), // 边框颜色
                        width: 1.5, // 边框宽度
                      ),
                    ),
                    child: Container(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            // 弹出对话框
                            showDialog(
                              barrierDismissible: true, // 允许点击外部关闭
                              context: context,
                              builder: (BuildContext context) {
                                return SelectDeviceAlertDialog();
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.w), // 添加容器的内边距
                            color: Colors.white, // 容器背景颜色
                            child: Center(
                              child: Text(
                                "點選新增裝置",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            deviceInfo.ezCaringTemp.isEmpty
                ? SizedBox.shrink()
                : deviceInfo.wifiTemp.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(right: 10.w, bottom: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0XFF70B1B8),
                                  width: 1.5,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Add your button action here
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "上一步",
                                    style: TextStyle(
                                      color: Color(0XFF70B1B8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(right: 10.w, bottom: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0XFF70B1B8),
                                  width: 1.5,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Add your button action here
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "上一步",
                                    style: TextStyle(
                                      color: Color(0XFF70B1B8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            deviceInfo.deviceName == ""
                                ? Container(
                                    margin: EdgeInsets.only(
                                        right: 10.w, bottom: 10.h),
                                    decoration: BoxDecoration(
                                      color: Color(0XFF70B1B8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        // Add your button action here
                                        showDialog(
                                          barrierDismissible: true, // 允许点击外部关闭
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ReNameAlertDialog();
                                          },
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "下一步",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        right: 10.w, bottom: 10.h),
                                    decoration: BoxDecoration(
                                      color: Color(0XFF70B1B8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        String result = await addUserDevice(
                                            deviceInfo.macAddress,
                                            deviceInfo.deviceName);
                                        if (result == "success") {
                                          String result2 =
                                              await getAllUserDevices(
                                                  deviceInfo);
                                          if (result2 == "success") {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage()));
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  HttpAlertDialog(
                                                      errorMessage: result2),
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                HttpAlertDialog(
                                                    errorMessage: result),
                                          );
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "完成",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300,
                                          ),
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
    );
  }
}
