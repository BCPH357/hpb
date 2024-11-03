import 'package:flutter/material.dart';
import 'package:hpb/setSelfInfoBody.dart';

import 'setSelfInfoPage.dart';
import 'restfulApi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';
import 'mult_provider.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class CountdownButton extends StatefulWidget {
  final Function(bool)? onCountdownComplete;
  String email;

  CountdownButton(
      {this.onCountdownComplete,
      required this.email,
});

  @override
  _CountdownButtonState createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  bool _isCountingDown = false;
  int _countdown = 60;
  Timer? _timer;

  void _startCountdown() async {
    print(widget.email);
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    bool success = false;
    if (_countdown == 60) {
      String result = await sendRegistrationEmail(widget.email);
      if (result == "success") {
        success = true;
        setState(() {
          _isCountingDown = true;
        });
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (_countdown > 0) {
            setState(() {
              _countdown--;
            });
          } else {
            _timer?.cancel();
            setState(() {
              _isCountingDown = false;
              _countdown = 60;
            });
            // Invoke the callback function with the result when countdown completes
            if (widget.onCountdownComplete != null) {
              widget.onCountdownComplete!(success);
            }
          }
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => HttpAlertDialog(errorMessage: result),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return ElevatedButton(
      onPressed: _isCountingDown ? null : _startCountdown,
      child: Text(_isCountingDown ? '${_countdown}s' : '送信', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Color(0xff757575);
            }
            return Color(0xff70B1B8);
          },
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        ),
      ),
    );
  }
}

class SignUpAlertDialog extends StatelessWidget {
  const SignUpAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                            fontSize: 25.sp,
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
                  "        註冊成功!\n點選確認重新登入",
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

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isChecked = false; // 添加用于按钮状态的状态变量
  late TextEditingController verificationController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  var buttonColor = Color(0xff757575);
  bool _obscureText = true;
  bool canRegister = false;

  @override
  void initState() {
    super.initState();
    verificationController = TextEditingController(); // 初始化名称控制器器
    emailController = TextEditingController(); // 初始化名称控制器器
    passwordController = TextEditingController(); // 初始化名称控制器器
    usernameController = TextEditingController(); // 初始化名称控制器器
  }

  @override
  void dispose() {
    verificationController.dispose(); // 释放名称控制器
    emailController.dispose(); // 释放名称控制器
    passwordController.dispose(); // 释放名称控制器
    usernameController.dispose(); // 释放名称控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Container(
        margin: EdgeInsets.only(top: 133.5.h),
        child: Column(
          children: [
            Text(
              "註冊",
              style: TextStyle(
                color: Color(0xff757575),
                fontSize: 30.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              width: 287.7.w,
              height: 600.h,
              decoration: BoxDecoration(
                color: Color(0XFFFFFFFF), // 背景颜色
                borderRadius: BorderRadius.circular(20), // 设置圆角半径
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 16.h),
                    child: Text(
                      "名稱",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.w, top: 10.h, right: 30.w),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 6.0.h, horizontal: 16.w),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0), // 设置圆角
                          borderSide: BorderSide(
                            color: Color(0XFFD9D9D9), // 未聚焦时边框的颜色
                            width: 2.0, // 边框的宽度
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0), // 设置圆角
                          borderSide: BorderSide(
                            color: Color(0XFF70B1B8), // 聚焦时边框的颜色
                            width: 2.0, // 边框的宽度
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 16.h),
                    child: Row(
                      children: [
                        Text(
                          "帳號",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "(信箱)",
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
                    margin: EdgeInsets.only(left: 30.w, top: 10.h, right: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                                setState(() {
                                  
                                });
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6.0.h, horizontal: 16.w),
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
                        SizedBox(width: 5.w),
                        CountdownButton(
                          onCountdownComplete: (bool success) {
                            setState(() {
                               isChecked = !isChecked; // 切换按钮状态
                             });
                          },
                          email: emailController.text,
                        ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     print(emailController.text);
                        //     String result = await sendRegistrationEmail(
                        //         emailController.text);
                        //     if (result == "success") {
                        //       print("success");
                        //     } else {
                        //       showDialog(
                        //         context: context,
                        //         builder: (context) =>
                        //             HttpAlertDialog(errorMessage: result),
                        //       );
                        //     }
                        //     // setState(() {
                        //     //   isChecked = !isChecked; // 切换按钮状态
                        //     // });
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Color(0xff70B1B8), // 按钮背景色
                        //     foregroundColor: Colors.white, // 按钮文字颜色
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 15.w, vertical: 15.h),
                        //   ),
                        //   child: Text(
                        //     '送信',
                        //     style: TextStyle(
                        //       fontSize: 15.sp,
                        //       fontWeight: FontWeight.w300,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 16.h),
                    child: Text(
                      "輸入信箱驗證碼",
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.w, top: 10.h, right: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              if (verificationController.text.isNotEmpty) {
                                setState(() {
                                  buttonColor = Color(0XFF70B1B8);
                                });
                              } else {
                                setState(() {
                                  buttonColor = Color(0xff757575);
                                });
                              }
                            },
                            controller: verificationController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6.0.h, horizontal: 16.w),
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
                        SizedBox(width: 5.w),
                        // CountdownButton(
                        //   onCountdownComplete: (bool success) {
                        //     setState(() {
                        //       canRegister = success;
                        //     });
                        //   },
                        //   email: emailController.text,
                        //   verificationCode: verificationController.text,
                        // ),
                        ElevatedButton(
                          onPressed: () async {
                            String result = await verifyRegistrationCode(
                                emailController.text,
                                verificationController.text);
                            if (result == "success") {
                              setState(() {
                                canRegister = true; // 切换按钮状态
                              });
                              print("success");
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => HttpAlertDialog(errorMessage: result),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor, // 按钮背景色
                            foregroundColor: Colors.white, // 按钮文字颜色
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 15.h),
                          ),
                          child: Text(
                            '確認',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 16.h),
                    child: Row(
                      children: [
                        Text(
                          "密碼",
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
                    margin: EdgeInsets.only(left: 30.w, top: 10.h, right: 30.w),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscureText, // 控制是否隐藏文本
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 6.0.h, horizontal: 16.w),
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility, // 切换眼睛图标
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText; // 切换显示/隐藏密码
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 35.h),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      if (canRegister) {
                        String result = await registerUser(
                            usernameController.text,
                            passwordController.text,
                            emailController.text,
                            verificationController.text);
                        if (result == "success") {
                          showDialog(
                            barrierDismissible: true, // 允许点击外部关闭
                            context: context,
                            builder: (BuildContext context) {
                              return SignUpAlertDialog();
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                HttpAlertDialog(errorMessage: result),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 328.8.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color:
                            canRegister ? Color(0XFF70B1B8) : Color(0XFF757575),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "註冊",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
