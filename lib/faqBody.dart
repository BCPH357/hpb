import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqBody extends StatefulWidget {
  const FaqBody({Key? key}) : super(key: key);

  @override
  _FaqBodyState createState() => _FaqBodyState();
}

class _FaqBodyState extends State<FaqBody> {
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

  void _scrollToSelectedIndex(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double position = (index * 60) -
        (screenWidth / 2) +
        30; // 60 is the approximate width of each button
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final faq = Provider.of<FaqInfo>(context, listen: false);
    faq.setFaq();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 将数据分组，每组最多8条
    List<List<dynamic>> pagedData = [];
    for (int i = 0; i < faq.faq.length; i += 8) {
      pagedData.add(
        faq.faq.sublist(
            i,
            i + 8 > faq.faq.length
                ? faq.faq.length
                : i + 8),
      );
    }

    return Container(
        height: 534.h,
        width: 369.9.w,
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff70B1B8), width: 1.0)
                ),
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
                    return ListView.builder(
                      itemCount: pagedData[pageIndex].length,
                      itemBuilder: (context, index) {
                        final e = pagedData[pageIndex][index];
                        print(e);
                        return ExpansionTile(
                          title: Text(e[0]["question"], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400,)),
                          children: [
                            // 这里可以添加展开后的详细内容
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: index == 3 ? e[0]["answer"] : Text(e[0]["answer"]),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
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
                  icon: Image.asset('assets/icons/lastPage.png'),
                  onPressed: () =>
                      _pageController.jumpToPage(pagedData.length - 1),
                ),
              ],
            ),
          ],
        ));
  }
}

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
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
            horizontal: 8.22, vertical: 26.7),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Container(
              width: 369.9.w,
              height: 623.h,
              decoration: BoxDecoration(
                color: Color(0xff70B1B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Container(
                  width: 369.9.w,
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
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              color: Color(0xff757575),
                              Icons.arrow_back,
                              size: 30.w,
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: Text(
                              "FAQ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                          SizedBox(width: 30.w),
                        ],
                      ),
                      FaqBody()
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
