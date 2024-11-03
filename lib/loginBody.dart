import 'package:flutter/material.dart';
import 'package:hpb/setSelfInfoBody.dart';

import 'forgetPasswordPage.dart';
import 'setSelfInfoPage.dart';
import 'signUpPage.dart';
import 'restfulApi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homePage.dart';
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    print(screenWidth);
    print(screenHeight);
    ScreenUtil.init(context, designSize: Size(411, 890));
    print(133.5.sp);
    print(133.5.h);
    print(133.5.w);



    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Container(
        margin: EdgeInsets.only(top: 133.5.h),
        child: Column(
          children: [
            Text(
              "登入",
              style: TextStyle(
                color: Color(0xff757575),
                fontSize: 30.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.sp),
              width: 328.8.w,
              height: 267.w,
               // 顶部间距
              decoration: BoxDecoration(
                color: Color(0XFFFFFFFF), // 背景颜色
                borderRadius: BorderRadius.circular(20), // 设置圆角半径
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 5,),
                  Container(
                    margin: EdgeInsets.all(16.sp),
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(
                        color: Colors.black, // 提示文本颜色
                        fontSize: 20.sp, // 提示文本大小
                      ),
                      decoration: InputDecoration(
                        // 设置底部边框
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD9D9D9)), // 默认底部边框颜色
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD9D9D9)), // 未激活状态下的边框颜色
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // 激活状态下的边框颜色
                        ),
                        hintText: '帳號',
                        hintStyle: TextStyle(
                          color: Colors.black, // 提示文本颜色
                          fontSize: 20.sp, // 提示文本大小
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.sp,),
                  Container(
                    margin: EdgeInsets.only(left: 16.sp, right: 16.sp),
                    child: TextField(
                      controller: passwordController,
                      style: TextStyle(
                        color: Colors.black, // 提示文本颜色
                        fontSize: 20.sp, // 提示文本大小
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        // 设置底部边框
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD9D9D9)), // 默认底部边框颜色
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD9D9D9)), // 未激活状态下的边框颜色
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // 激活状态下的边框颜色
                        ),
                        hintText: '密碼',
                        hintStyle: TextStyle(
                          color: Colors.black, // 提示文本颜色
                          fontSize: 20.sp, // 提示文本大小
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.sp,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordPage()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16.sp, right: 16.sp),
                      padding: const EdgeInsets.only(bottom: 1), // 文本和底线之间的间距
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xff98CDD4), // 底线颜色
                            width: 1, // 底线厚度
                          ),
                        ),
                      ),
                      child: Text(
                        '忘記密碼?',
                        style: TextStyle(
                          color: Color(0xff98CDD4),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:30.h,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        String result = await loginUser(emailController.text, passwordController.text);
                        if (result == "success") {
                          if (prefs.containsKey('firstLogin')) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                            
                          }
                          else{
                            
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SetSelfInfoPage()));
                          }
                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (context) => HttpAlertDialog(errorMessage: result),
                          );
                        }
                      },
                      child: Container(
                        width: 328.8.w,
                        decoration: BoxDecoration(
                          color: Color(0XFF70B1B8), // 背景颜色
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20), // 底部左角圆角
                            bottomRight: Radius.circular(20), // 底部右角圆角
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "登入",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.sp,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 41.1.w),
                    child: Divider(
                      color: Color(0xff757575), // 线的颜色
                      thickness: 1, // 线的厚度
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    '或',
                    style: TextStyle(
                      color: Color(0xff757575),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 41.1.w),
                    child: Divider(
                      color: Color(0xff757575), // 线的颜色
                      thickness: 1, // 线的厚度
                    ),
                  )
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Container(
              width: 328.8.w,
              // height: screenHeight * 0.06,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // 阴影颜色
                    spreadRadius: 1, // 阴影扩散半径
                    blurRadius: 5,   // 阴影模糊半径
                    offset: Offset(0, 4), // 阴影偏移量（x轴为0，y轴为3，表示阴影在下方）
                  ),
                ],
                color: Colors.white,  // 背景颜色
                borderRadius: BorderRadius.circular(10), // 设置圆角半径
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/fb.png',
                    ),
                    SizedBox(
                      width: 41.w,
                    ),
                    Text(
                      "使用facebook登入",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ),
            ),
            SizedBox(height: 20.h,),
            Container(
              width: 328.8.w,
              // height: screenHeight * 0.06,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // 阴影颜色
                    spreadRadius: 1, // 阴影扩散半径
                    blurRadius: 5,   // 阴影模糊半径
                    offset: Offset(0, 4), // 阴影偏移量（x轴为0，y轴为3，表示阴影在下方）
                  ),
                ],
                color: Colors.white,  // 背景颜色
                borderRadius: BorderRadius.circular(10), // 设置圆角半径
              ),
              child: Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/line.png',
                      ),
                      SizedBox(
                        width: 41.w,
                      ),
                      Text(
                        "使用line登入",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Spacer(),
            Text(
              "沒有帳號?",
              style: TextStyle(
                color: Color(0xff757575),
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                      // color: Colors.red,
                      margin: EdgeInsets.only(right: 41.1.w, left: 41.1.w),
                      child: Divider(
                        color: Color(0xff757575), // 线的颜色
                        thickness: 1, // 线的厚度
                      ),
                    )
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                // TODO: Add navigation to registration page
                // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Container(
                width: 328.8.w,
                // height: screenHeight * 0.06,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // 阴影颜色
                      spreadRadius: 1, // 阴影扩散半径
                      blurRadius: 5,   // 阴影模糊半径
                      offset: Offset(0, 4), // 阴影偏移量（x轴为0，y轴为3，表示阴影在下方）
                    ),
                  ],
                  color: Colors.white,  // 背景颜色
                  borderRadius: BorderRadius.circular(10), // 设置圆角半径
                  border: Border.all(
                    color: const Color(0XFF70B1B8), // 边框颜色
                    width: 1.5, // 边框宽度
                  ),
                ),
                child: Padding(
                    padding: EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "點此註冊",
                          style: TextStyle(
                            color: Color(0xff70b1b8),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
            // SizedBox(height: 50.h,),
          ],
        ),
      ),
    );
  }

}