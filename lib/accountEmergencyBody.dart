import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'accountEmergencyEditPage.dart';
import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'accountSelfInfoPage.dart';
import 'accountDependentInfoPage.dart';
import 'accountEmergencyAddingPage.dart';
import 'restfulApi.dart';
import 'alertDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DeleteAlertDialog extends StatelessWidget {
  final bool onlyOne;
  final int index;
  DeleteAlertDialog({required this.onlyOne, required this.index});
  @override
  Widget build(BuildContext context) {
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    final emergencyContact =
        Provider.of<EmergencyContact>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    // emergency.setEmergency();
    // emergencyContact.setEmergencyContact();
    // deviceInfo.setDeviceInfo();
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
            height: 356.h,
            width: 369.9.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            // color: Colors.green,

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/bigWarning.png',
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        '警告',
                        style: TextStyle(
                            fontSize: 23.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  onlyOne
                      ? Container(
                          child: Text(
                            '至少需有一位緊急聯絡人\n確認刪除?',
                            style: TextStyle(
                                fontSize: 23.sp, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '確定刪除 ',
                              style: TextStyle(
                                  fontSize: 23.sp, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              emergencyContact.emergencyContact[index]['name'],
                              style: TextStyle(
                                  fontSize: 23.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff70B1B8)),
                            ),
                            Text(
                              '?',
                              style: TextStyle(
                                  fontSize: 23.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xff70B1B8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: Color(0xff70B1B8)), // Added border
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // 执行重置或重启操作

                          final res = await deleteEmergencyContact(
                              emergencyContact.emergencyContact[index]
                                  ['contactId']);
                          if (res == "success") {
                            emergencyContact
                                .deleteEmergencyContactByIndex(index);
                            Navigator.of(context).pop();
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  HttpAlertDialog(errorMessage: res),
                            );
                          }
                        },
                        child: Text('確定'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff70B1B8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}

class CountryCodeDropdown extends StatefulWidget {
  @override
  _CountryCodeDropdownState createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  String dropdownValue = '+1'; // 預設值

  @override
  Widget build(BuildContext context) {
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

class AccountEmergency extends StatefulWidget {
  const AccountEmergency({super.key});

  @override
  _AccountEmergencyState createState() => _AccountEmergencyState();
}

class _AccountEmergencyState extends State<AccountEmergency> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool isClicked = false;

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
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    final emergencyContact =
        Provider.of<EmergencyContact>(context, listen: true);
    final peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
    // emergency.setEmergency();
    // emergencyContact.setEmergencyContact();
    // deviceInfo.setDeviceInfo();

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8.22.w, vertical: 10.7.h),
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
              height: 590.h,
              decoration: BoxDecoration(
                color: Color(0xff70B1B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  width: 369.9.w,
                  height: 570.h,
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
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AccountSelfInfoPage()));
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
                                    "個人資訊",
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
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "緊急聯絡人",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    emergencyContact.emergencyContact.length < 5 ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isClicked = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF75B6CF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 0.h),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (emergencyContact
                                                  .emergencyContact.length <
                                              6) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AccountEmergencyAddingPage()),
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.add,
                                                color: Colors.white),
                                            SizedBox(width: 8.w),
                                            Text(
                                              '新增聯絡人',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ) : SizedBox(width: 10.w,),
                                    Text(
                                      "緊急聯絡人: ${emergencyContact.emergencyContact.length}/5",
                                      style: TextStyle(
                                          color: Color(0xff757575),
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  height: 400.5.h, // Adjust this height as needed
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: emergencyContact
                                        .emergencyContact.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFFD9D9D9),
                                              width: 2,
                                            ),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10.w,
                                              bottom: 10.h,
                                              top: 3.h,
                                              right: 3.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    emergencyContact
                                                            .emergencyContact[
                                                        index]['name'],
                                                    style: TextStyle(
                                                      color: Color(0xff757575),
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "聯絡方式:\n${emergencyContact.emergencyContact[index]['contacts']}",
                                                    style: TextStyle(
                                                      color: Color(0xff757575),
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 15.w),
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        // Add your button action here\
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AccountEmergencyEditPage(
                                                                      index:
                                                                          index,
                                                                      name: emergencyContact
                                                                              .emergencyContact[index]
                                                                          [
                                                                          'name'])),
                                                        );
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        side: BorderSide(
                                                            color: Color(
                                                                0xff70B1B8)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12.w,
                                                                vertical: 4.h),
                                                        minimumSize: Size(0, 0),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                      child: Text(
                                                        '修改',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff70B1B8),
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 5.w),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Add your button action here
                                                        showDialog(
                                                          barrierDismissible:
                                                              true, // 允许点击外部关闭
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return DeleteAlertDialog(
                                                                onlyOne: emergencyContact
                                                                        .emergencyContact
                                                                        .length ==
                                                                    1,
                                                                index: index);
                                                          },
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color(0xffE99194),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12.w,
                                                                vertical: 4.h),
                                                        minimumSize: Size(0, 0),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                      child: Text(
                                                        '刪除',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
