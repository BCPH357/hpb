import 'package:flutter/material.dart';
import 'dart:async';
import 'restfulApi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';
class ResetAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, designSize: Size(411, 890));
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: 311.5.h,
          width: 287.7.w,
          // color: Colors.green,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 287.7.w,
                  height: 44.5.h,
                  decoration: BoxDecoration(
                    color: Color(0XFF757575),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20.w),
                        child: Text(
                          "提示",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  )),
              Expanded(
                  child: Center(
                child: Text(
                  "    重設密碼成功!\n點選確認重新登入",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 关闭当前对话框
                  Navigator.pop(context);
                },
                child: Container(
                  height: 44.5.h,
                  width: 287.7.w,
                  decoration: BoxDecoration(
                    color: Color(0XFF70B1B8),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "確認",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController verificationController;
  late TextEditingController accountController;
  late TextEditingController passwordController;

  bool isCountingDown = false; // 用来跟踪按钮是否正在倒计时
  int countdownTime = 60; // 倒计时时间
  Timer? _timer;

  bool firstPress = false;

  bool showReset = false;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    verificationController = TextEditingController(); // 初始化名称控制器器
    accountController = TextEditingController(); // 初始化名称控制器器
    passwordController = TextEditingController(); // 初始化名称控制器器
  }

  @override
  void dispose() {
    verificationController.dispose(); // 释放名称控制器
    accountController.dispose(); // 释放名称控制器
    passwordController.dispose(); // 释放名称控制器
    _timer?.cancel(); // 页面销毁时取消计时器
    super.dispose();
  }

  void startCountdown() {
    setState(() {
      firstPress = true;
      isCountingDown = true;
      countdownTime = 60;
    });

    // 使用 Timer 每秒更新一次倒计时
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdownTime > 0) {
        setState(() {
          countdownTime--;
        });
      } else {
        // 倒计时结束，恢复到初始状态
        setState(() {
          isCountingDown = false;
        });
        _timer?.cancel(); // 停止计时器
      }
    });
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
            Text(
              "忘記密碼",
              style: TextStyle(
                color: Color(0xff757575),
                fontSize: 30.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              width: 328.8.w,
              height: 489.5.h,
              decoration: BoxDecoration(
                color: Color(0XFFFFFFFF), // 背景颜色
                borderRadius: BorderRadius.circular(20), // 设置圆角半径
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, top: 16.h),
                    child: Row(
                      children: [
                        Text(
                          "輸入你的帳號",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "(xxx@mail.com)",
                          style: TextStyle(
                            color: Color(0XFF757575),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.w, top: 10.h, right: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {},
                            controller: accountController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Color(0XFFD9D9D9),
                                  width: 2.0,
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
                        ),
                        SizedBox(width: 10.w),
                        ElevatedButton(
                          onPressed: isCountingDown
                              ? null
                              : () async {
                                  String result = await sendPasswordResetEmail(
                                      accountController.text);
                                  if (result == "success") {
                                    startCountdown();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => HttpAlertDialog(errorMessage: result),
                                    );
                                  }
                                }, // 如果正在倒计时，按钮将禁用
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCountingDown
                                ? Color(0XFF757575)
                                : Color(0XFF70B1B8), // 按钮倒计时期间变灰色
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 15.h),
                          ),
                          child: Text(
                            isCountingDown
                                ? '$countdownTime 秒'
                                : '送信', // 根据倒计时状态切换文本
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, top: 16.h),
                    child: Text(
                      "輸入驗證碼",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.w, top: 10.h, right: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {},
                            controller: verificationController,
                            decoration: InputDecoration(
                              fillColor: firstPress
                                  ? Colors.white
                                  : Color(0xffb3b3b3), // 填充背景色
                              filled: true, // 确保填充颜色有效
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Color(0XFFD9D9D9),
                                  width: 2.0,
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
                        ),
                        SizedBox(width: 10.w),
                        ElevatedButton(
                          onPressed: firstPress
                              ? () async {
                                  String result = await verifyResetPasswordCode(
                                      accountController.text,
                                      verificationController.text);
                                  if (result == "success") {
                                    setState(() {
                                      showReset = true;
                                    });
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => HttpAlertDialog(errorMessage: result),
                                    );
                                  }
                                }
                              : null, // 如果正在倒计时，按钮将禁用

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            backgroundColor: firstPress
                                ? Color(0XFF70B1B8)
                                : Color(0xffb3b3b3), // 填充背景色
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 15.h),
                          ),

                          child: Text(
                            "確認", // 根据倒计时状态切换文本
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Divider(
                      color: Color(0xffD9D9D9), // 线的颜色
                      thickness: 1, // 线的厚度
                    ),
                  ),
                  showReset
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, top: 16.h),
                              child: Row(
                                children: [
                                  Text(
                                    "重設密碼",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "(6~8位數)",
                                    style: TextStyle(
                                      color: Color(0XFF757575),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 15.w, top: 10.h, right: 5.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: passwordController,
                                      obscureText: _obscureText, // 控制是否隐藏文本
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.0, horizontal: 16),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                            color: Color(0XFFD9D9D9),
                                            width: 2.0,
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
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility, // 切换眼睛图标
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText =
                                                  !_obscureText; // 切换显示/隐藏密码
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  ElevatedButton(
                                    onPressed: () async {
                                      String result = await resetPassword(accountController.text, verificationController.text, passwordController.text);
                                      if (result == "success") {
                                        showDialog(
                                          barrierDismissible: true, // 允许点击外部关闭
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ResetAlertDialog();
                                        },
                                      );
                                    }
                                    else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => HttpAlertDialog(errorMessage: result),
                                      );
                                    }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0XFF70B1B8),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 15.h),
                                    ),
                                    child: Text(
                                      "確認",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
