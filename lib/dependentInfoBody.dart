import 'package:flutter/material.dart';
import 'homePage.dart';
import 'restfulApi.dart';
import 'loginPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';

class HorizontalScrollingCheckboxes extends StatefulWidget {

  final Function(List<bool>) onCheckedChanged; // 新增一個回調函數

  HorizontalScrollingCheckboxes({required this.onCheckedChanged});
  @override
  _HorizontalScrollingCheckboxesState createState() =>
      _HorizontalScrollingCheckboxesState();
}

class _HorizontalScrollingCheckboxesState
    extends State<HorizontalScrollingCheckboxes> {
  List<bool> isChecked = List.generate(18, (index) => false);
  final List<String> optionTexts = [
    "無疾病史",
    "肺結核",
    "心臟病",
    "肝炎",
    "氣喘",
    "腎臟病",
    "癲癇",
    "紅斑性狼瘡",
    "血友病",
    "蠶豆症",
    "關節炎",
    "糖尿病",
    "心理或精神疾病",
    "癌症",
    "海洋性貧血",
    "重大手術",
    "藥物過敏",
    "其他"
  ];
  
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6.0,
      radius: Radius.circular(10),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate((optionTexts.length + 1) ~/ 2, (index) {
                  return _buildCheckboxItem(index);
                }),
              ),
            ),
            SizedBox(width: 8.w), // Add some space between columns
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(optionTexts.length ~/ 2, (index) {
                  return _buildCheckboxItem(
                      index + ((optionTexts.length + 1) ~/ 2));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(int index) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isChecked[index],
            onChanged: (bool? value) {
              setState(() {
                isChecked[index] = value!;
                widget.onCheckedChanged(isChecked);
              });
            },
          ),
          Flexible(
            child: Text(
              optionTexts[index],
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp ,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class DependentInfo extends StatefulWidget {
  const DependentInfo({super.key});

  @override
  _DependentInfoState createState() => _DependentInfoState();
}

class _DependentInfoState extends State<DependentInfo> {
  // bool isChecked = false; // 添加用于按钮状态的状态变量
  late TextEditingController nameController;
  List<bool> isCheck = List.generate(18, (index) => false);
  // var buttonColor = Color(0xff757575);
  // bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(); // 初始化名称控制器器
  }

  @override
  void dispose() {
    nameController.dispose(); // 释放名称控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, designSize: Size(411, 890));

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Container(
        margin: EdgeInsets.only(top: 133.5.h),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 10.h),
                width: 328.8.w,
                height: 650.h,
                decoration: BoxDecoration(
                  color: Color(0XFFFFFFFF), // 背景颜色
                  borderRadius: BorderRadius.circular(20), // 设置圆角半径
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "被照顧者資訊設定",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            " *此項可稍後設定",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        // Use SizedBox to set width
                        width: 287.7.w,
                        child: Divider(
                          // Add 'const' keyword
                          color: Color(0xffD9D9D9), // 線的顏色
                          thickness: 2.0, // 線的厚度
                        ),
                      ),
                      Container(
                        width: 287.7.w,
                        decoration: BoxDecoration(
                          // 設定背景顏色
                          border: Border.all(
                            color: Color(0xffD9D9D9), // 邊框顏色
                            width: 1.0, // 邊框寬度
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 15.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "被照護者名稱",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Color(0XFFD9D9D9),
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Color(0XFF70B1B8),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    "被照護者疾病史",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 16.w, right: 16.w),
                                    padding: EdgeInsets.only(
                                        bottom: 1.h), // 文本和底线之间的间距
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xff98CDD4), // 底线颜色
                                          width: 1, // 底线厚度
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '隱私條款:使用範圍聲明',
                                      style: TextStyle(
                                        color: Color(0xff98CDD4),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                // width: screenWidth * 0.7,
                                height: 267.h,
                                decoration: BoxDecoration(
                                  // 設定背景顏色
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Color(0xffD9D9D9), // 邊框顏色
                                    width: 1.0, // 邊框寬度
                                  ),
                                ),
                                child: HorizontalScrollingCheckboxes(
                                  onCheckedChanged: (updatedList) {
                                    // 在這裡處理 isChecked 陣列的更新
                                    setState(() {
                                      isCheck = updatedList;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 按钮背景色
                              foregroundColor: Color(0xff70B1B8), // 按钮文字颜色
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  // 添加边框
                                  color: Color(0xff70B1B8), // 边框颜色
                                  width: 1.0, // 边框宽度
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 8.h), // 减少垂直内边距
                            ),
                            child: Text(
                              '略過',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          ElevatedButton(
                            onPressed: () async {
                              Map<String, bool> medicalHistory = {
                                "noMedicalHistory": isCheck[0],
                                "tuberculosis": isCheck[1],
                                "heartDisease": isCheck[2],
                                "hepatitis": isCheck[3],
                                "asthma": isCheck[4],
                                "kidneyDisease": isCheck[5],
                                "epilepsy": isCheck[6],
                                "lupus": isCheck[7],
                                "hemophilia": isCheck[8],
                                "g6pdDeficiency": isCheck[9],
                                "arthritis": isCheck[10],
                                "diabetes": isCheck[11],
                                "mentalIllness": isCheck[12],
                                "cancer": isCheck[13],
                                "thalassemia": isCheck[14],
                                "majorSurgery": isCheck[15],
                                "drugAllergy": isCheck[16]
                              };
                              String result = await updateCareRecipient(
                                  name: nameController.text,
                                  medicalHistory: medicalHistory,
                                  notes: "");
                              if (result == "success") {
                                print("Care recipient updated successfully");
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => HttpAlertDialog(errorMessage: result),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff70B1B8), // 按钮背景色
                              foregroundColor: Colors.white, // 按钮文字颜色
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 8.h), // 减少垂直内边距
                            ),
                            child: Text(
                              '完成',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
