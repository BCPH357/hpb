import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'accountDependentInfoPage.dart';
import 'accountEmergencyPage.dart';
import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'restfulApi.dart';
import 'alertDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//選擇國碼widget
class CountryCodeDropdown extends StatefulWidget {
  @override
  _CountryCodeDropdownState createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  String? dropdownValue; // Initially null
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final peopleInfo = Provider.of<PeopleInfo>(context);
      // Ensure the initial value is in the list or null if not found
      dropdownValue = peopleInfo.selfCountryCode.isNotEmpty &&
              ['+1', '+86', '+91', '+44', '+81', '+886']
                  .contains(peopleInfo.selfCountryCode)
          ? peopleInfo.selfCountryCode
          : null;
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final peopleInfo = Provider.of<PeopleInfo>(context, listen: true);
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24.w,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 0,
        color: Colors.transparent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue;
          peopleInfo.setSelfCountryCode(dropdownValue!);
        });
      },
      items: <String>['+1', '+86', '+91', '+44', '+81', '+886']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class AccountSelfInfo extends StatefulWidget {
  const AccountSelfInfo({super.key});

  @override
  _AccountSelfInfoState createState() => _AccountSelfInfoState();
}

class _AccountSelfInfoState extends State<AccountSelfInfo> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool isClicked = false;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 当依赖变化时，如果是首次初始化，从 Provider 获取数据
    if (_isInit) {
      final peopleInfo = Provider.of<PeopleInfo>(context);
      nameController.text = peopleInfo.selfName;
      phoneController.text = peopleInfo.selfPhone;
      emailController.text = peopleInfo.selfEmail;
      _isInit = false; // 确保数据只被加载一次
    }
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
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    final peopleInfo = Provider.of<PeopleInfo>(context, listen: true);
    final emergencyContact =
        Provider.of<EmergencyContact>(context, listen: true);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // emergency.setEmergency();
    // deviceInfo.setDeviceInfo();

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.22.w, vertical: 10.h),
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
              height: 605.h,
              decoration: BoxDecoration(
                color: Color(0xff70B1B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 369.9.w,
                  height: 620.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text("個人資訊"),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                final res = await getCareRecipient(peopleInfo);
                                if (res == "success") {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountDependentInfoPage()));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        HttpAlertDialog(errorMessage: res),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: Color(0xff79747E),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "被照顧者資訊",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                final res = await getEmergencyContacts(
                                    emergencyContact);
                                if (res == "success") {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountEmergencyPage()));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        HttpAlertDialog(errorMessage: res),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: Color(0xff79747E),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "緊急聯絡人",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    isClicked
                                        ? SizedBox(
                                            width: 70
                                                .w, // Adjust this value to match the original button width
                                            height: 30
                                                .h, // Adjust this value to match the original button height
                                          )
                                        : ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isClicked = true;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF75B6CF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25.w,
                                                  vertical: 10.h),
                                            ),
                                            child: Text(
                                              '編輯',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                  ],
                                ),
                                Text(
                                  "名稱",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  decoration: BoxDecoration(
                                    color: isClicked
                                        ? Colors.white
                                        : Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(8),
                                    border: isClicked
                                        ? Border.all(
                                            color: Color(0xffD9D9D9),
                                            width: 1.0)
                                        : Border.all(
                                            color: Colors.white, width: 1.0),
                                  ),
                                  child: TextField(
                                    controller: nameController,
                                    enabled: isClicked, // 禁止輸入
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 4.h),
                                      isDense: true,
                                      hintText: '輸入名稱',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "手機",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 70.w, // 根据实际需要调整宽度
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isClicked
                                                ? Color(0xffD9D9D9)
                                                : Colors.white,
                                            width: 1.0,
                                          ),
                                          color: isClicked
                                              ? Colors.white
                                              : Color(0xffC1C1C1),
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
                                      enabled: isClicked, // 禁用输入
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: isClicked
                                            ? Colors.white
                                            : Color(0xFFD9D9D9), // 设置灰色背景
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 4.0.h, horizontal: 16.w),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: isClicked
                                                ? Color(0xFFD9D9D9)
                                                : Colors.white,
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Color(0xFFD9D9D9),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Color(0xFFD9D9D9),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "信箱",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  decoration: BoxDecoration(
                                    color: isClicked
                                        ? Colors.white
                                        : Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(8),
                                    border: isClicked
                                        ? Border.all(
                                            color: Color(0xffD9D9D9),
                                            width: 1.0)
                                        : Border.all(
                                            color: Colors.white, width: 1.0),
                                  ),
                                  child: TextField(
                                    controller: emailController,
                                    enabled: isClicked, // 禁止輸入
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 4.h),
                                      isDense: true,
                                      hintText: '輸入信箱',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50.h),
                                isClicked
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                isClicked = false;
                                              });
                                              final res = await updateUser(
                                                  name: nameController.text,
                                                  email: emailController.text,
                                                  countryCode: peopleInfo
                                                      .selfCountryCode,
                                                  phoneNumber:
                                                      phoneController.text);
                                              if (res == "success") {
                                                peopleInfo.setSelfPhone(
                                                    phoneController.text);
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      HttpAlertDialog(
                                                          errorMessage: res),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF75B6CF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 10.h),
                                            ),
                                            child: Text(
                                              '儲存',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ]))
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
