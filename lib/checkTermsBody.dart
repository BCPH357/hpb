import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'longText.dart';
import 'jwtDecode.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CheckTerms extends StatefulWidget {
  const CheckTerms({super.key});

  @override
  _CheckTermsState createState() => _CheckTermsState();
}

class _CheckTermsState extends State<CheckTerms> {
  // 在这里定义任何你需要的状态变量
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));

    return Center(
      child: Container(
        margin: EdgeInsets.only(
          top: 133.5.h,
          bottom: 222.5.h,
        ),
        width: 328.8.w,
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF), // 背景颜色
          borderRadius: BorderRadius.circular(20), // 设置圆角半径
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5.h,),
            Text(
              "條款與隱私權",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(
              color: Color(0XFFD9D9D9), // 横线颜色
              thickness: 2.0, // 横线厚度
              indent: 16.0.w, // 左边距
              endIndent: 16.0.w, // 右边距
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,  // Container 的背景色
                  border: Border.all(   // 使用 Border.all() 为所有边添加相同的边框
                    color: Color(0XFFD9D9D9),  // 边框的颜色
                    width: 2.0,  // 边框的宽度
                  ),
                  borderRadius: BorderRadius.circular(10), // 可选：设置圆角
                ),
                child:  SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,  // 将内容对齐到顶部
                      crossAxisAlignment: CrossAxisAlignment.stretch,  // 可选：让内容宽度充满容器
                      children: [
                        Text(
                          term,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                    side: MaterialStateBorderSide.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return BorderSide(
                            color: Color(0xfff5f5f5), // 边框颜色
                            width: 2.0, // 边框宽度
                          );
                        }
                        return BorderSide(
                          color: Color(0xfff5f5f5), // 边框颜色
                          width: 2.0, // 边框宽度
                        );
                      },
                    ),
                  ),
                  Text(
                    '我已閱讀上述條款', // 按钮文字
                    style: TextStyle(
                      fontSize: 15.sp, // 文字大小
                      fontWeight: FontWeight.w300, // 文字粗细
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (isChecked) {
                        saveToLocal("notFirst", "true");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isChecked ? Color(0xff70B1B8) : Color(0xff757575), // 按钮背景色
                      foregroundColor: Colors.white, // 按钮文字颜色
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 圆角半径
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h), // 内边距
                    ),
                    child: Text(
                      '下一步', // 按钮文字
                      style: TextStyle(
                        fontSize: 15.sp, // 文字大小
                        fontWeight: FontWeight.w300, // 文字粗细
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
