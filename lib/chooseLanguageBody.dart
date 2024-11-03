import 'package:flutter/material.dart';

import 'checkTermsPage.dart';
import 'privacyPolicyPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class LanguageRadioButton extends StatefulWidget {
  @override
  _LanguageRadioButtonState createState() => _LanguageRadioButtonState();
}

class _LanguageRadioButtonState extends State<LanguageRadioButton> {
  String _selectedOption = '中文'; // 默认选中的值

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RadioListTile<String>(
          title: Text('中文'),
          value: '中文',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: Text('English'),
          value: 'English',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: Text('日本語'),
          value: '日本語',
          groupValue: _selectedOption,
          onChanged: (value) {
            print(798798789446);
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: Text('Deutsch'),
          value: 'Option 4',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
      ],
    );
  }
}

class ChooseLanguage extends StatelessWidget {
  const ChooseLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          // left: screenWidth * 0.05,
          // right: screenWidth * 0.05,
          top: 133.5.h,
          bottom: 180.h,
        ),
        width: 328.8.w,
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF), // 背景颜色
          borderRadius: BorderRadius.circular(20), // 设置圆角半径
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Text(
              "選擇您的語系",
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
                  color: Colors.white, // Container 的背景色
                  border: Border.all(
                    // 使用 Border.all() 为所有边添加相同的边框
                    color: Color(0XFFD9D9D9), // 边框的颜色
                    width: 2.0, // 边框的宽度
                  ),
                  borderRadius: BorderRadius.circular(10), // 可选：设置圆角
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // 将内容对齐到顶部
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // 可选：让内容宽度充满容器
                  children: [
                    LanguageRadioButton(), // 您的组件
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 按钮点击时执行的操作
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckTermsPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff70B1B8), // 按钮背景色
                      foregroundColor: Colors.white, // 按钮文字颜色
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 圆角半径
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.w, vertical: 10.h), // 内边距
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
