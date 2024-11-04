import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'restfulApi.dart';
import 'alertDialog.dart';

class CustomBar extends StatelessWidget {
  final List<dynamic> ratios; // 每段的比例
  final List<Color> colors; // 每段的顏色

  const CustomBar({Key? key, required this.ratios, required this.colors})
      : assert(ratios.length == colors.length,
            'ratios and colors must match${ratios}, ${colors}'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    print("ratios: ${ratios}");
    print("colors: ${colors}");
    // print("nO");
    // print(ratios);
    return Row(
      children: [
        for (int i = 0; i < ratios.length; i++)
          Expanded(
            flex: (ratios[i] * 100).toInt(), // 根據比例設定每段的長度
            child: Container(
              color: colors[i],
              height: 30, // 設定長條的高度
            ),
          ),
      ],
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime, bool) onDateSelected;

  const DatePickerWidget({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().subtract(Duration(days: 1));
  }

//跳出loading
  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 防止用戶通過點擊背景關閉對話框
      builder: (BuildContext context) {
        ScreenUtil.init(context, designSize: Size(411, 890));
        return WillPopScope(
          onWillPop: () async => false, // 防止用戶通過返回按鈕關閉對話框
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20.h),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );

    // 3秒後自動關閉對話框
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // 關閉對話框
    });
  }

  Future<void> _selectDate(BuildContext context, DeviceInfo deviceInfo,
      VisualCharts visualCharts) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.cyan,
            colorScheme: ColorScheme.light(primary: Colors.cyan),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate && visualCharts.tempDevice != "") {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked, true);
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      showLoadingDialog();

      final result = await getBehavioralData(
          deviceInfo.getDeviceIdByName(visualCharts.tempDevice),
          formatter.format(_selectedDate),
          visualCharts);
      if (result == "success") {
      } else {
        showDialog(
          context: context,
          builder: (context) => HttpAlertDialog(errorMessage: result),
        );
      }
      final result2 = await getSleepData(
          deviceInfo.getDeviceIdByName(visualCharts.tempDevice),
          formatter.format(_selectedDate),
          visualCharts);
      if (result2 == "success") {
      } else {
        showDialog(
          context: context,
          builder: (context) => HttpAlertDialog(errorMessage: result2),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final visualCharts = Provider.of<VisualCharts>(context, listen: false);
    return GestureDetector(
      onTap: () => _selectDate(context, deviceInfo, visualCharts),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('yyyy/MM/dd').format(_selectedDate),
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

//圓餅圖
class VisualChartsPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final screenHeight = MediaQuery.of(context).size.height;
    final visualCharts = Provider.of<VisualCharts>(context, listen: true);
    // visualCharts.setVisualCharts();

    double noPersonCount = visualCharts.noPersonCount.toDouble();
    double sittingCount = visualCharts.sittingCount.toDouble();
    double noDataCount = visualCharts.noDataCount.toDouble();
    double sleepCount = visualCharts.sleepCount.toDouble();
    double somePeopleCount = visualCharts.somePeopleCount.toDouble();
    double fallDownCount = visualCharts.fallDownCount.toDouble();

    return Container(
      height: 106.8.h, // 將容器高度設置為螢幕高度的 15%
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: [
            PieChartSectionData(
              color: Color(0xff96A5BD),
              value: noPersonCount,
              title: '',
              radius: 53.4.h, // 將半徑設置為螢幕高度的 7.5%
              titleStyle: TextStyle(
                fontSize: 0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Color(0xffFFD996),
              value: sittingCount,
              title: '',
              radius: 53.4.h, // 將半徑設置為螢幕高度的 7.5%
              titleStyle: TextStyle(
                fontSize: 0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Color(0xffD9D9D9),
              value: noDataCount,
              title: '',
              radius: 53.4.h, // 將半徑設置為螢幕高度的 7.5%
              titleStyle: TextStyle(
                fontSize: 0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Color(0xff80CAFF),
              value: sleepCount,
              title: '',
              radius: 53.4.h, // 將半徑設置為螢幕高度的 7.5%
              titleStyle: TextStyle(
                fontSize: 0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Color(0xff85E0A3),
              value: somePeopleCount,
              title: '',
              radius: 53.4.h, // 將半徑設置為螢幕高度的 7.5%
              titleStyle: TextStyle(
                fontSize: 0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Color(0xffFFAFA3),
              value: fallDownCount,
              title: '',
              radius: 53.4.h, // 將半徑設置為螢幕高度的 7.5%
              titleStyle: TextStyle(
                fontSize: 0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataImage extends StatelessWidget {
  final String action;
  const DataImage({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final visualCharts = Provider.of<VisualCharts>(context, listen: true);
    // visualCharts.setVisualCharts();

    return Container(
      child: Column(
        children: [
          Container(
            color: Color(0xffD7DADB),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(12, (index) {
                      // String status = visualCharts.visualCharts[index];
                      // Color boxColor;
                      // if (status == "NO_PEOPLE") {
                      //   boxColor = Color(0xff96A5BD);
                      // } else if (status == "SIT") {
                      //   boxColor = Color(0xffFFD996);
                      // } else if (status == "SLEEP") {
                      //   boxColor = Color(0xff80CAFF);
                      // } else if (status == "SOME_PEOPLE") {
                      //   boxColor = Color(0xff85E0A3);
                      // } else if (status == "FALL_DOWN") {
                      //   boxColor = Color(0xffFFAFA3);
                      // } else {
                      //   boxColor = Color(0xffD9D9D9);
                      // }
                      return Container(
                        child: Center(
                          child:
                              Text("${(index + 1).toString().padLeft(2, '0')}"),
                        ),
                      );
                      // return Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text("${(index + 1).toString().padLeft(2, '0')}"),
                      //     Container(
                      //       height: 20.h,
                      //       width: 22.w, // 稍微減小寬度以消除空隙
                      //       color: boxColor,
                      //     ),
                      //   ],
                      // );
                    }),
                  ),
                ),
              ],
            ),
          ),
          CustomBar(
            ratios: action == "行為"
                ? visualCharts.visualCharts["first"]
                : visualCharts.visualChartsSleep["first"], // 每段的比例
            colors: action == "行為"
                ? visualCharts.firstColor
                : visualCharts.firstColorSleep, // 每段的顏色
          ),
          SizedBox(height: 20.h),
          Container(
            color: Color(0xffD7DADB),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(12, (index) {
                      // String status = visualCharts.visualCharts[index + 12];
                      // Color boxColor;
                      // if (status == "NO_PEOPLE") {
                      //   boxColor = Color(0xff96A5BD);
                      // } else if (status == "SIT") {
                      //   boxColor = Color(0xffFFD996);
                      // } else if (status == "SLEEP") {
                      //   boxColor = Color(0xff80CAFF);
                      // } else if (status == "SOME_PEOPLE") {
                      //   boxColor = Color(0xff85E0A3);
                      // } else if (status == "FALL_DOWN") {
                      //   boxColor = Color(0xffFFAFA3);
                      // } else {
                      //   boxColor = Color(0xffD9D9D9);
                      // }
                      // return Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //         "${(index + 12 + 1).toString().padLeft(2, '0')}"),
                      //     Container(
                      //       height: 20.h,
                      //       width: 22.w, // 稍微減小寬度以消除空隙
                      //       color: boxColor,
                      //     ),
                      //   ],
                      // );
                      return Container(
                        child: Center(
                          child: Text(
                              "${(index + 12 + 1).toString().padLeft(2, '0')}"),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          CustomBar(
            ratios: action == "行為"
                ? visualCharts.visualCharts["second"]
                : visualCharts.visualChartsSleep["second"], // 每段的比例
            colors: action == "行為"
                ? visualCharts.secondColor
                : visualCharts.secondColorSleep, // 每段的顏色
          ),
          // ... existing code ...

          SizedBox(height: 10.h),
          action == "行為"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: VisualChartsPieChart(),
                    ),
                    // SizedBox(width: 5.w),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 22.w, // 稍微減小寬度以消除空隙
                                color: Color(0xff80CAFF),
                              ),
                              SizedBox(width: 5.w),
                              Text("睡眠"),
                              SizedBox(width: 3.w),
                              Text(visualCharts.sleepTime),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 22.w, // 稍微減小寬度以消除空隙
                                color: Color(0xff85E0A3),
                              ),
                              SizedBox(width: 5.w),
                              Text("有人"),
                              SizedBox(width: 3.w),
                              Text(visualCharts.somePeopleTime),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 22.w, // 稍微減小寬度以消除空隙
                                color: Color(0xffFFD996),
                              ),
                              SizedBox(width: 5.w),
                              Text("坐"),
                              SizedBox(width: 3.w),
                              Text(visualCharts.sittingTime),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 22.w, // 稍微減小寬度以消除空隙
                                color: Color(0xffFFAFA3),
                              ),
                              SizedBox(width: 5.w),
                              Text("跌倒"),
                              SizedBox(width: 3.w),
                              Text(visualCharts.fallDownTime),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 22.w, // 稍微減小寬度以消除空隙
                                color: Color(0xff96A5BD),
                              ),
                              SizedBox(width: 5.w),
                              Text("無人"),
                              SizedBox(width: 3.w),
                              Text(visualCharts.noPersonTime),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 22.w, // 稍微減小寬度以消除空隙
                                color: Color(0xffD9D9D9),
                              ),
                              SizedBox(width: 5.w),
                              Text("無資料"),
                              SizedBox(width: 3.w),
                              Text(visualCharts.noDataTime),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20.h,
                          width: 22.w, // 稍微減小寬度以消除空隙
                          color: Color(0xff80CAFF),
                        ),
                        SizedBox(width: 5.w),
                        Text("睡眠總時間"),
                        SizedBox(width: 10.w),
                        Text(visualCharts.allSleepTime),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20.h,
                          width: 22.w, // 稍微減小寬度以消除空隙
                          color: Color(0xff007AFF),
                        ),
                        SizedBox(width: 5.w),
                        Text("在床總時間"),
                        SizedBox(width: 10.w),
                        Text(visualCharts.allOnBedTime),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20.h,
                          width: 22.w, // 稍微減小寬度以消除空隙
                          color: Color(0xffFFAFA3),
                        ),
                        SizedBox(width: 5.w),
                        Text("離床總時間"),
                        SizedBox(width: 10.w),
                        Text(visualCharts.allOffBedTime),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class DeviceDropdown extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? value;

  const DeviceDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFFD0D0D0),
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: SizedBox(),
        hint: Text("選擇裝置"),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class DataAnalyze extends StatefulWidget {
  const DataAnalyze({super.key});

  @override
  _DataAnalyzeState createState() => _DataAnalyzeState();
}

class _DataAnalyzeState extends State<DataAnalyze> {
  bool isAction = true;
  bool isSleep = false;
  String? selectedDevice;
  DateTime selectedDate = DateTime.now();
  bool dataAvailable = false;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    final visualCharts = Provider.of<VisualCharts>(context, listen: false);
    // emergency.setEmergency();
    // deviceInfo.setDeviceInfo();

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 26.7.h),
        child: Column(
          children: [
            Text(
              "資訊分析",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 370.w,
              height: 590.h,
              decoration: BoxDecoration(
                color: Color(0xff70B1B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  width: 370.w,
                  height: 623.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAction = true;
                                  isSleep = false;
                                });
                                // visualCharts.killAllStatus();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isAction
                                      ? Colors.white
                                      : Color(0xff79747E),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "行為",
                                    style: TextStyle(
                                      color: isAction
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAction = false;
                                  isSleep = true;
                                });
                                // visualCharts.killAllStatus();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isSleep
                                      ? Colors.white
                                      : Color(0xff79747E),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "睡眠",
                                    style: TextStyle(
                                      color:
                                          isSleep ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "裝置",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.sp,
                              ),
                            ),
                            SizedBox(height: 10),
                            DeviceDropdown(
                              items: deviceInfo.getAllDeviceName(),
                              value: selectedDevice, // 添加这一行
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDevice = newValue; // 更新这一行
                                  visualCharts.setTempDevice(newValue!);
                                });
                              },
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "日期",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            DatePickerWidget(
                              onDateSelected: (DateTime date, bool isData) {
                                setState(() {
                                  selectedDate = date;
                                  dataAvailable = isData;
                                });
                                // 在這裡可以處理選擇的日期
                                print(
                                    'Selected date: ${DateFormat('yyyy/MM/dd').format(date)}');
                              },
                            ),
                            SizedBox(height: 20.h),
                            dataAvailable
                                ? DataImage(action: isAction ? "行為" : "睡眠")
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
