import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addDevicePage.dart';
import 'mult_provider.dart';
import 'deviceFunctionPage.dart';
import 'restfulApi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';

//首頁有資料下面要加
//燈光設定要間格修改

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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      // 從 Provider 獲取 DeviceInfo 和 PeopleInfo 實例
      DeviceInfo deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
      PeopleInfo peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
      // 先調用 getUserInfo 函數
      String result = await getUserInfo(peopleInfo);
      if (result == "success") {
        // 若成功，再調用 getAllUserDevices 函數
        String result2 = await getAllUserDevices(deviceInfo);
        if (result2 == "success") {
          print("Device and user info fetched successfully");
        } else {
          showDialog(
            context: context,
            builder: (context) => HttpAlertDialog(errorMessage: result2),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => HttpAlertDialog(errorMessage: result),
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: true);
    final peopleInfo = Provider.of<PeopleInfo>(context, listen: true);
    ScreenUtil.init(context, designSize: Size(411, 890));
    print(screenWidth);
    print(screenHeight);
    // deviceInfo.setDeviceInfo();

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.7.w, vertical: 26.7.h),
        child: Column(
          children: [
            Text(
              "${peopleInfo.selfName}的家",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30.h),
            deviceInfo.device.isEmpty
                ? Column(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DevicePage(),
                          ),
                        );
                      },
                      child: Container(
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
                          color: Color(0XFF98CDD4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            Container(
                              width: 89.w, // Diameter of the circle
                              height: 89.h, // Diameter of the circle
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the circle
                                shape: BoxShape
                                    .circle, // Makes the container circular
                              ),
                              child: Center(
                                  child: Icon(Icons.add,
                                      color: Color(0xff757575), size: 66.75.h)),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "新增裝置",
                                  style: TextStyle(
                                    color: Color(0xff757575),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 89.h + 10.w),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Image.asset(
                      'assets/icons/noDeviceIcon.png',
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "目前還沒有裝置",
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ])
                : Scrollbar(
                    thumbVisibility: true, // 总是显示滚动条
                    thickness: 6.0, // 滚动条厚度
                    radius: Radius.circular(10), // 滚动条圆角
                    child: Container(
                      height: 578.5
                          .h, // Assuming screenHeight is the total height you want for the ListView
                      child: ListView.builder(
                        itemCount: deviceInfo.device.length + 1, // 增加一个项目
                        itemBuilder: (context, index) {
                          if (index < deviceInfo.device.length) {
                            return Column(children: [
                              GestureDetector(
                                onTap: () {
                                  // if (deviceInfo.device[index]["status"] ==
                                  //     "connected") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DeviceFunctionPage(index: index),
                                      ),
                                    );
                                  // }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  height: 115.7.h,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.2), // 阴影颜色
                                        spreadRadius: 1, // 阴影扩散半径
                                        blurRadius: 5, // 阴影模糊半径
                                        offset: Offset(
                                            0, 4), // 阴影偏移量（x轴为0，y轴为3，表示阴影在下方）
                                      ),
                                    ],
                                    color: deviceInfo.device[index]["status"] ==
                                            "connected"
                                        ? Color(0XFF98CDD4)
                                        : Color(0XFFB3B3B3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Container(
                                        width: 102.35.w,
                                        height: 102.35.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            deviceInfo.device[index]["name"]
                                                        .length >
                                                    3
                                                ? '${deviceInfo.device[index]["name"].substring(0, 3)}...'
                                                : deviceInfo.device[index]
                                                    ["name"],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        deviceInfo.device[index]
                                                                    [
                                                                    "status"] ==
                                                                "connected"
                                                            ? 'assets/icons/temperature.png'
                                                            : 'assets/icons/disconnected.png',
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        deviceInfo.device[index]
                                                                    [
                                                                    "status"] ==
                                                                "connected"
                                                            ? "${deviceInfo.device[index]["temperature"].toString()}°C"
                                                            : "",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    children: [
                                                      if (deviceInfo
                                                                  .device[index]
                                                              ["status"] ==
                                                          "connected") ...[
                                                        for (var icon in deviceInfo
                                                                        .device[
                                                                    index][
                                                                "behavioralType"] ??
                                                            []) ...[
                                                          icon == "NO_PEOPLE"
                                                              ? SizedBox(
                                                                  height: 10.h)
                                                              : Image.asset(
                                                                  deviceInfo
                                                                      .setImageHash(
                                                                          icon)),
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
                                                padding: EdgeInsets.only(
                                                    right: 10.w),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(height: 10.h),
                                                    Row(
                                                      children: [
                                                        (deviceInfo.device[index]
                                                                        [
                                                                        "status"] ==
                                                                    "connected" &&
                                                                deviceInfo
                                                                    .device[
                                                                        index][
                                                                        "warnings"]
                                                                    .isNotEmpty)
                                                            ? Image.asset(
                                                                'assets/icons/warning.png',
                                                              )
                                                            : SizedBox(),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                          (deviceInfo.device[index]
                                                                          [
                                                                          "status"] ==
                                                                      "connected" &&
                                                                  deviceInfo
                                                                      .device[
                                                                          index]
                                                                          [
                                                                          "warnings"]
                                                                      .isNotEmpty)
                                                              ? "${deviceInfo.setDeviceWarningHash(deviceInfo.device[index]["warnings"][0].toString())}"
                                                              : "",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    (deviceInfo.device[index][
                                                                    "status"] ==
                                                                "connected" &&
                                                            deviceInfo
                                                                .device[index]
                                                                    ["warnings"]
                                                                .isNotEmpty)
                                                        ? InkWell(
                                                            onTap: () {
                                                              // // Add action for tap here
                                                              // showDialog(
                                                              //   context:
                                                              //       context,
                                                              //   builder: (context) =>
                                                              //       DeleteAlertDialog(
                                                              //           index:
                                                              //               index),
                                                              // );
                                                            },
                                                            child: Text(
                                                              "...更多警告",
                                                              style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
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
                              ),
                              SizedBox(height: 10),
                            ]);
                          } else {
                            // 在列表末尾添加新增设备的项目
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DevicePage()),
                                );
                              },
                              child: Container(
                                height: 115.7.h,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: Color(0XFF98CDD4),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Container(
                                      width: 89.w,
                                      height: 89.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Icon(Icons.add,
                                              color: Color(0xff757575),
                                              size: 66.75.h)),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "新增裝置",
                                          style: TextStyle(
                                            color: Color(0xff757575),
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 89.w + 10.w),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
