import 'package:flutter/material.dart';
import 'package:hpb/mult_provider.dart';
import 'package:provider/provider.dart';

import 'aboutPage.dart';
import 'cookiesPolicyPage.dart';
import 'faqPage.dart';
import 'privacyPolicyPage.dart';
import 'subscriptionPage.dart';
import 'warrantyTermsPage.dart';
import 'loginPage.dart';
import 'restfulApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'alertDialog.dart';
class SwitchButton extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChanged;

  const SwitchButton({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
        });
        widget.onChanged(_isOn);
      },
      child: Container(
        width: 60.w,
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _isOn ? Color(0xff70B1B8) : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 200),
          alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26.w,
            height: 26.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool phoneSwitch = false;

  @override
  Widget build(BuildContext context) {
    DeviceInfo deviceInfo = Provider.of<DeviceInfo>(context);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: 100.h),
          Divider(height: 1, color: Color(0xff70b1b8)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: ListTile(
              leading: Image.asset(
                'assets/icons/credit.png',
              ),
              title: Text(
                '訂閱服務',
                style: TextStyle(
                  color: Color(0xff757575),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubscriptionPage()));
              },
            ),
          ),
          Divider(height: 1, color: Color(0xff70b1b8)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: ExpansionTile(
              leading: Image.asset(
                'assets/icons/support.png',
              ),
              title: Text(
                '支援',
                style: TextStyle(
                  color: Color(0xff757575),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              children: [
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      'FAQ',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FaqPage()));
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0.w),
                  height: 1.h,
                  color: Color(0xff757575),
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      'Warranty Terms',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WarrantyTermsPage()));
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0.w),
                  height: 1.h,
                  color: Color(0xff757575),
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyPolicyPage()));
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0.w),
                  height: 1.h,
                  color: Color(0xff757575),
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      'Cookies Policy',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CookiesPolicyPage()));
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Color(0xff70b1b8)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: ExpansionTile(
              leading: Image.asset(
                'assets/icons/about.png',
              ),
              title: Text(
                '關於h.p.b',
                style: TextStyle(
                  color: Color(0xff757575),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              children: [
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      '聯絡我們',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutPage()));
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Color(0xff70b1b8)),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 8.0),
          //   child: ListTile(
          //     leading: Image.asset(
          //       'assets/icons/notice.png',
          //     ),
          //     title: Text(
          //       '行銷通知接收',
          //       style: TextStyle(
          //         color: Color(0xff757575),
          //         fontSize: 20,
          //         fontWeight: FontWeight.w400,
          //       ),
          //     ),
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     trailing: SwitchButton(
          //       initialValue: phoneSwitch,
          //       onChanged: (value) {
          //         setState(() {
          //           phoneSwitch = value;
          //         });
          //         print(value);
          //       },
          //     ),
          //   ),
          // ),
          // Divider(height: 1, color: Color(0xff70B1B8)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: ExpansionTile(
              leading: Image.asset(
                'assets/icons/language.png',
              ),
              title: Text(
                '語言切換',
                style: TextStyle(
                  color: Color(0xff757575),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              children: [
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      '中文',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0.w),
                  height: 1.h,
                  color: Color(0xff757575),
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      'English',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0.w),
                  height: 1.h,
                  color: Color(0xff757575),
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      '日文',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp ,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0.w),
                  height: 1.h,
                  color: Color(0xff757575),
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Text(
                      '德文',
                      style: TextStyle(
                        color: Color(0xff757575),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
              height: 267.h), // 添加固定高度的空白區域
          Divider(height: 1, color: Color(0xffD9D9D9)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: ListTile(
              title: Center(
                child: Text(
                  '登出帳戶',
                  style: TextStyle(
                    color: Color(0xffE99194),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              onTap: () async {
                // 處理登出邏輯
                String result = await logout();

                
                if (result == "success") {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('jwtToken');
                  deviceInfo.killAllStatus();
                } else {
                  // Navigator.pop(context);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => LoginPage()));
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // await prefs.remove('jwtToken');
                  showDialog(
                    context: context,
                    builder: (context) => HttpAlertDialog(errorMessage: result),
                  );
                }
              },
            ),
          ),
          Divider(height: 1, color: Color(0xffD9D9D9)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: ListTile(
              title: Center(
                child: Text(
                  'APP 1.0.0\nAndroid 11',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              onTap: () {
                // 處理登出邏輯
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
