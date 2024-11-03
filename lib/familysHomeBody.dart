import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAlertDialog extends StatelessWidget {
  final int index;
  const DeleteAlertDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
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
            Expanded(
              child: Container(
                // color: Colors.red,
                width: 267.15.w,
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
                        deviceInfo.familyDevice[index]["warnings"].length, (i) {
                      var warning = deviceInfo.familyDevice[index]["warnings"][i];
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

class FamilySHome extends StatefulWidget {
  final int index;
  const FamilySHome({super.key, required this.index});

  @override
  _FamilySHomeState createState() => _FamilySHomeState();
}

class _FamilySHomeState extends State<FamilySHome> {
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
    
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // deviceInfo.setDeviceInfo();
    // deviceInfo.setFamilyData();
    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 26.715.w, vertical: 26.7.h),
        child: Column(
          children: [
            Text(
              deviceInfo.familyData[widget.index]["familyName"],
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30.h),
            Scrollbar(
                    thumbVisibility: true, // 总是显示滚动条
                    thickness: 6.0, // 滚动条厚度
                    radius: Radius.circular(10), // 滚动条圆角
                    child: Container(
                      height: 578.5.h, // Assuming 890 is the total height you want for the ListView
                      child: ListView.builder(
                        itemCount: deviceInfo.familyDevice.length + 1, // 增加一个项目
                        itemBuilder: (context, index) {
                          if (index < deviceInfo.familyDevice.length) {
                            return Column(children: [
                              GestureDetector(
                                onTap: () {
                                  // if (deviceInfo.device[index]["status"] ==
                                  //     "connected") {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           DeviceFunctionPage(index: index),
                                  //     ),
                                  //   );
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
                                    color: deviceInfo.familyDevice[index]["status"] ==
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
                                            deviceInfo.familyDevice[index]["name"]
                                                        .length >
                                                    3
                                                ? '${deviceInfo.familyDevice[index]["name"].substring(0, 3)}...'
                                                : deviceInfo.familyDevice[index]
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
                                                        deviceInfo.familyDevice[index]
                                                                    [
                                                                    "status"] ==
                                                                "connected"
                                                            ? 'assets/icons/temperature.png'
                                                            : 'assets/icons/disconnected.png',
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        deviceInfo.familyDevice[index]
                                                                    [
                                                                    "status"] ==
                                                                "connected"
                                                            ? "${deviceInfo.familyDevice[index]["temperature"].toString()}°C"
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
                                                                  .familyDevice[index]
                                                              ["status"] ==
                                                          "connected") ...[
                                                        for (var icon in deviceInfo
                                                                        .familyDevice[
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
                                                        (deviceInfo.familyDevice[index]
                                                                        [
                                                                        "status"] ==
                                                                    "connected" &&
                                                                deviceInfo
                                                                    .familyDevice[
                                                                        index][
                                                                        "warnings"]
                                                                    .isNotEmpty)
                                                            ? Image.asset(
                                                                'assets/icons/warning.png',
                                                              )
                                                            : SizedBox(),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                          (deviceInfo.familyDevice[index]
                                                                          [
                                                                          "status"] ==
                                                                      "connected" &&
                                                                  deviceInfo
                                                                      .familyDevice[
                                                                          index]
                                                                          [
                                                                          "warnings"]
                                                                      .isNotEmpty)
                                                              ? "${deviceInfo.setDeviceWarningHash(deviceInfo.familyDevice[index]["warnings"][0].toString())}"
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
                                                    (deviceInfo.familyDevice[index][
                                                                    "status"] ==
                                                                "connected" &&
                                                            deviceInfo
                                                                .familyDevice[index]
                                                                    ["warnings"]
                                                                .isNotEmpty)
                                                        ? InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) =>
                                                                    DeleteAlertDialog(
                                                                        index:
                                                                            index),
                                                              );
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
