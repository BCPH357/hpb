import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'jwtDecode.dart';
import 'restfulApi.dart';
import 'dependentInfoPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';
//
class CountryCodeDropdown extends StatefulWidget {
  final String initialValue;
  final Function(String) onValueChange;

  CountryCodeDropdown({
    Key? key,
    required this.initialValue,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _CountryCodeDropdownState createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue; // 使用外部提供的初始值
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24.sp,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 0,
        color: Colors.transparent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
        widget.onValueChange(newValue!); // 通知外部值已更改
      },
      items: <String>['+1', '+86', '+91', '+44', '+81', "+886"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class SingleCheckbox extends StatefulWidget {
  final Function(bool?) onChanged; // 添加一个回调函数作为参数

  const SingleCheckbox({Key? key, required this.onChanged}) : super(key: key);

  @override
  _SingleCheckboxState createState() => _SingleCheckboxState();
}

class _SingleCheckboxState extends State<SingleCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.7, // 调整这个值来放大或缩小
      child: Checkbox(
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
            widget.onChanged(value); // 调用回调函数传递状态
          });
        },
      ),
    );
  }
}

class SetEmergencyContact extends StatefulWidget {
  const SetEmergencyContact({super.key});

  @override
  _SetEmergencyContactState createState() => _SetEmergencyContactState();
}

class _SetEmergencyContactState extends State<SetEmergencyContact> {
  // bool isChecked = false; // 添加用于按钮状态的状态变量
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  String selectedCountryCode = '+86';
  Key countryCodeKey = UniqueKey();
  // var buttonColor = Color(0xff757575);
  // bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(); // 初始化名称控制器器
    phoneController = TextEditingController(); // 初始化名称控制器器
    emailController = TextEditingController(); // 初始化名称控制器器
  }

  @override
  void dispose() {
    nameController.dispose(); // 释放名称控制器
    phoneController.dispose(); // 释放名称控制器
    emailController.dispose(); // 释放名称控制器
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
                height: 712.h,
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
                            "緊急聯絡人設定",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.sp,
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
                        child: const Divider(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SingleCheckbox(
                                  onChanged: (bool? value) async {
                                    if (value == true) {
                                      String name =
                                          await getFromLocal('selfName');
                                      String phone =
                                          await getFromLocal('selfPhone');
                                      String email =
                                          await getFromLocal('selfEmail');
                                      String countryCode =
                                          await getFromLocal('selfCountryCode');
                                      setState(() {
                                        nameController.text = name;
                                        phoneController.text = phone;
                                        emailController.text = email;
                                        selectedCountryCode = countryCode;
                                        countryCodeKey = UniqueKey();
                                        print(selectedCountryCode);
                                      });
                                    } else {
                                      setState(() {
                                        nameController.text = '';
                                        phoneController.text = '';
                                        emailController.text = '';
                                        selectedCountryCode = '+86';
                                        countryCodeKey = UniqueKey();
                                      });
                                    }
                                  },
                                ),
                                Text(
                                  "同個人資訊",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 15.w, right: 15.w, bottom: 15.h),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "名稱",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxHeight: 40.0.h, // 設置最大高度
                                        ),
                                        child: TextField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4.0.h,
                                                    horizontal: 16.w),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Color(0XFFD9D9D9),
                                                width: 1.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Color(0XFF70B1B8),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        "手機",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 70.w, // 根据实际需要调整宽度
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xffD9D9D9),
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 5),
                                                child: CountryCodeDropdown(
                                                  key: countryCodeKey,
                                                  initialValue:
                                                      selectedCountryCode,
                                                  onValueChange: (newValue) {
                                                    setState(() {
                                                      selectedCountryCode =
                                                          newValue; // 直接在這裡處理狀態更新
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: TextField(
                                            controller: phoneController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 4.0.h,  
                                                      horizontal: 16.w),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      12.0), // 右上角圆角
                                                  bottomRight: Radius.circular(
                                                      12.0), // 右下角圆角
                                                ),
                                                borderSide: BorderSide(
                                                  color: Color(0XFFD9D9D9),
                                                  width: 1.0,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      12.0), // 右上角圆角
                                                  bottomRight: Radius.circular(
                                                      12.0), // 右下角圆角
                                                ),
                                                borderSide: BorderSide(
                                                  color: Color(0XFF70B1B8),
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                      SizedBox(height: 10.h ),
                                      Text(
                                        "信箱",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxHeight: 40.0.h, // 設置最大高度
                                        ),
                                        child: TextField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4.0.h,
                                                    horizontal: 16.w),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Color(0XFFD9D9D9),
                                                width: 1.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Color(0XFF70B1B8),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      ElevatedButton.icon(
                                        icon: Icon(Icons.add), // 加号图标
                                        label: Text("其他通知方式"), // 按钮文字
                                        onPressed: () {
                                          // 按钮点击事件
                                          print("按钮被点击了");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color(0xff70B1B8), // 按钮背景颜色
                                          foregroundColor:
                                              Colors.white, // 文字和图标的颜色
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 10.h), // 减少水平内边距，垂直内边距保持
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // 圆角大小
                                          ),
                                        ),
                                      )
                                    ])),
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DependentInfoPage()));
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
                              String result = await addEmergencyContact(
                                  name: nameController.text,
                                  phoneNumber: phoneController.text,
                                  email: emailController.text,
                                  countryCode: selectedCountryCode);

                              if (result == "success") {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DependentInfoPage()));
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
                              '下一步',
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
