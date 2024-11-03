import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'restfulApi.dart';
import 'alertDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CountryCodeDropdown extends StatefulWidget {
  @override
  _CountryCodeDropdownState createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  String dropdownValue = '+1'; // 預設值

  @override
  Widget build(BuildContext context) {
    final emergencyContact = Provider.of<EmergencyContact>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down), // 更改为三角形图标
      iconSize: 24.sp,
      elevation: 16,
      style: const TextStyle(color: Colors.black), // 更改文字颜色为黑色
      underline: Container(
        height: 0, // 將高度設為0
        color: Colors.transparent, // 設置透明顏色
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
        emergencyContact.setCountryCode(dropdownValue);

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

class AccountEmergencyAdding extends StatefulWidget {
  const AccountEmergencyAdding({super.key});

  @override
  _AccountEmergencyAddingState createState() => _AccountEmergencyAddingState();
}

class _AccountEmergencyAddingState extends State<AccountEmergencyAdding> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool phoneSwitch = true;
  bool emailSwitch = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    final emergencyContact =
        Provider.of<EmergencyContact>(context, listen: true);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // emergency.setEmergency();
    // emergencyContact.setEmergencyContact();
    // deviceInfo.setDeviceInfo();

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8.22.w, vertical: 26.7.h),
        child: Column(
          children: [
            Text(
              "帳戶",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 369.9.w,
              height: 670.h,
              decoration: BoxDecoration(
                color: Color(0xff70B1B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
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
                            icon:  Icon(
                              color: Color(0xff757575),
                              Icons.arrow_back,
                              size: 30.sp,
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: Text(
                              "新增緊急聯絡人",
                              style: TextStyle(
                                color: Color(0xff757575),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                          SizedBox(width: 30.w),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(children: [
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                SizedBox(width: 20.w),
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  '名稱',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Color(0xffD9D9D9), width: 1.0)),
                              child: TextField(
                                // enabled: false,
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.h),
                                  hintText: '輸入名稱',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                SizedBox(width: 20.w),
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  '手機(簡訊)',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Spacer(),
                                
                                SizedBox(width: 10.w),
                                SwitchButton(
                                  initialValue: true,
                                  onChanged: (value) {
                                    setState(() {
                                      phoneSwitch = value;
                                    });
                                    print(value);
                                  },
                                ),
                                SizedBox(width: 20.w),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                SizedBox(width: 20.w),
                                SizedBox(
                                  width: 70.w, // 根据实际需要调整宽度
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xffD9D9D9),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: CountryCodeDropdown(),
                                  ),
                                ),
                                Expanded(
                                    child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  enabled: phoneSwitch,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 4.h, horizontal: 16.w),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight:
                                            Radius.circular(12.0), // 右上角圆角
                                        bottomRight:
                                            Radius.circular(12.0), // 右下角圆角
                                      ),
                                      borderSide: BorderSide(
                                        color: Color(0XFFD9D9D9),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight:
                                            Radius.circular(12.0), // 右上角圆角
                                        bottomRight:
                                            Radius.circular(12.0), // 右下角圆角
                                      ),
                                      borderSide: BorderSide(
                                        color: Color(0XFF70B1B8),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                )),
                                SizedBox(width: 20.w),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                SizedBox(width: 20.w),
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  '信箱',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Spacer(),
                                
                                SizedBox(width: 10.w),
                                SwitchButton(
                                  initialValue: true,
                                  onChanged: (value) {
                                    setState(() {
                                      emailSwitch = value;
                                    });
                                    print(value);
                                  },
                                ),
                                SizedBox(width: 20.w),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Color(0xffD9D9D9), width: 1.0)),
                              child: TextField(
                                controller: emailController,
                                enabled: emailSwitch,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.h  ),
                                  hintText: 'XXX@mail.com',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(height: 106.8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF70B1B8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 0.h),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add, color: Colors.white),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '其他通知方式',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 20.w),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final res = await addEmergencyContact2(name: nameController.text, countryCode: emergencyContact.countryCode, phoneNumber: phoneController.text, email: emailController.text, emergencyContact: emergencyContact);
                                      if (res == "success") {
                                        Navigator.pop(context);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => HttpAlertDialog(errorMessage: res),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF70B1B8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 10.h),
                                    ),
                                    child: Text(
                                      '完成',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ])),
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
