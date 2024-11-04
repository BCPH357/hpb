import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// class AbnormalHistoryBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final emergency = Provider.of<Emergency>(context, listen: false);
//     emergency.setEmergency();
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     // 将数据分组，每组最多10条
//     List<List<dynamic>> pagedData = [];
//     for (int i = 0; i < emergency.emergency.length; i += 10) {
//       pagedData.add(
//         emergency.emergency.sublist(
//             i,
//             i + 10 > emergency.emergency.length
//                 ? emergency.emergency.length
//                 : i + 10),
//       );
//     }

//     return Container(
//       color: Colors.red,
//       height: screenHeight * 0.6,
//       width: screenWidth * 0.9,
//       child: PageView.builder(
//       itemCount: pagedData.length,
//       itemBuilder: (context, pageIndex) {
//         return Column(
//           children: [
//             ...pagedData[pageIndex]
//                 .map((e) => Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Container(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             child: Center(
//                               child: Text(
//                                 e[0], // 警告
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Center(
//                               child: Text(
//                                 e[1], // 设备
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Center(
//                               child: Text(
//                                 e[2], // 日期
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ))
//                 .toList(),
//             Spacer(),
//             Text("Page ${pageIndex + 1} of ${pagedData.length}"), // 显示当前页码
//           ],
//         );
//       },
//     ));
//   }
// }

class AbnormalHistoryBody extends StatefulWidget {
  final String option;

  const AbnormalHistoryBody({Key? key, required this.option}) : super(key: key);

  @override
  _AbnormalHistoryBodyState createState() => _AbnormalHistoryBodyState();
}

class _AbnormalHistoryBodyState extends State<AbnormalHistoryBody> {
  late PageController _pageController;
  late ScrollController _scrollController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

//控制畫面最底部<< < 1 2 3 > >>
  void _scrollToSelectedIndex(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    ScreenUtil.init(context, designSize: Size(411, 890));
    double position = (index * 60) -
        (411.w / 2) +
        30.w; // 60 is the approximate width of each button
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final emergency = Provider.of<Emergency>(context, listen: false);
    // emergency.setEmergency();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, designSize: Size(411, 890));
    // 将数据分组，每组最多8条
    List<List<dynamic>> pagedData = [];
    if (widget.option == "emergency") {
      for (int i = 0; i < emergency.emergency.length; i += 8) {
        pagedData.add(
          emergency.emergency.sublist(
              i,
              i + 8 > emergency.emergency.length
                  ? emergency.emergency.length
                  : i + 8),
        );
      }
    }
    if (widget.option == "event") {
      for (int i = 0; i < emergency.event.length; i += 8) {
        pagedData.add(
          emergency.event.sublist(
              i,
              i + 8 > emergency.event.length
                  ? emergency.event.length
                  : i + 8),
        );
      }
    }

    return Container(
        height: 500.h,
        width: 370.w,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pagedData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                  _scrollToSelectedIndex(page);
                },
                itemBuilder: (context, pageIndex) {
                  return Column(
                    children: [
                      ...pagedData[pageIndex]
                          .map((e) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Center(
                                        child: Text(
                                          e[0], // 警告
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          e[1], // 设备
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          e[2], // 日期
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //   icon: Icon(Icons.skip_previous),
                //   onPressed: () => _pageController.jumpToPage(0),
                // ),
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: _currentPage > 0
                      ? () => _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut)
                      : null,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pagedData.length,
                        (index) => GestureDetector(
                          onTap: () {
                            _pageController.jumpToPage(index);
                            _scrollToSelectedIndex(index);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: _currentPage == index
                                    ? Colors.blue
                                    : Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: _currentPage < pagedData.length - 1
                      ? () => _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut)
                      : null,
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/lastPage.png'
                  ),
                  onPressed: () =>
                      _pageController.jumpToPage(pagedData.length - 1),
                ),
              ],
            ),
          ],
        ));
  }
}

class AbnormalHistory extends StatefulWidget {
  const AbnormalHistory({super.key});

  @override
  _AbnormalHistoryState createState() => _AbnormalHistoryState();
}

class _AbnormalHistoryState extends State<AbnormalHistory> {
  bool isEmergency = true;
  bool isEvent = false;
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
    // emergency.setEmergency();
    // deviceInfo.setDeviceInfo();

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8.22.w, vertical: 10.7.h),
        child: Column(
          children: [
            Text(
              "異常歷史",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              width: 370.w,
              height: 630.h,
              decoration: BoxDecoration(
                color: Color(0xffE99194),
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
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEmergency = true;
                                  isEvent = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isEmergency
                                      ? Colors.white
                                      : Color(0xff79747E),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text("緊急警告"),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEmergency = false;
                                  isEvent = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isEvent
                                      ? Colors.white
                                      : Color(0xff79747E),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text("事件通知"),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Center(
                                child: Text(
                                  "警告",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Center(
                                child: Text(
                                  "裝置",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Center(
                                child: Text(
                                  "日期",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      isEmergency
                          ? AbnormalHistoryBody(option: "emergency")
                          : AbnormalHistoryBody(option: "event"),
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
