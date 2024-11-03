import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'restfulApi.dart';
import 'accountDependentInfoPage.dart';
import 'accountSelfInfoPage.dart';
import 'alertDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class EditCheckDialog extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String contactId;
  final bool isDoubleCheck;
  const EditCheckDialog(
      {super.key,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.contactId,
      required this.isDoubleCheck});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    final emergencyContact =
        Provider.of<EmergencyContact>(context, listen: false);
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
                  Container(
                    child: Text(
                      isDoubleCheck
                          ? '目前通知都關閉\n確定執行?'
                          : '確定修改緊急聯絡人資訊?',
                      style:
                          TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w500),
                    ),
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
                          final res = await updateEmergencyContact(
                              contactId: contactId,
                              name: name,
                              countryCode: emergencyContact.countryCode,
                              phoneNumber: phoneNumber,
                              email: email);
                          // 执行重置或重启操作
                          if (res == "success") {
                            Navigator.of(context).pop();
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
                        onPressed: () {
                          // 执行重置或重启操作
                          Navigator.of(context).pop();
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
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 当依赖变化时，如果是首次初始化，从 Provider 获取数据
    if (_isInit) {
      final emergencyContact = Provider.of<EmergencyContact>(context);
      dropdownValue = emergencyContact.countryCode;
      _isInit = false; // 确保数据只被加载一次
    }
  }

  @override
  Widget build(BuildContext context) {
    final emergencyContact =
        Provider.of<EmergencyContact>(context, listen: true);
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
        });
        widget.onChanged(_isOn);
      },
      child: Container(
        width: 40.w,
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _isOn ? Color(0xff70B1B8) : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 200),
          alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 15.w,
            height: 20.h,
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

class AccountEmergencyEdit extends StatefulWidget {
  final int index;
  final String name;
  const AccountEmergencyEdit(
      {super.key, required this.index, required this.name});

  @override
  _AccountEmergencyEditState createState() => _AccountEmergencyEditState();
}

class _AccountEmergencyEditState extends State<AccountEmergencyEdit> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool isClicked = false;
  bool phoneSwitch = false;
  bool emailSwitch = false;
  bool isEditing = false;
  bool lineSwitch = true;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 当依赖变化时，如果是首次初始化，从 Provider 获取数据
    if (_isInit) {
      final emergencyContact = Provider.of<EmergencyContact>(context);
      nameController.text =
          emergencyContact.emergencyContact[widget.index]['name'];
      phoneController.text =
          emergencyContact.emergencyContact[widget.index]['phoneNumber'];
      emailController.text =
          emergencyContact.emergencyContact[widget.index]['email'];
      _isInit = false; // 确保数据只被加载一次
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    nameController.text = widget.name;
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    final emergencyContact =
        Provider.of<EmergencyContact>(context, listen: false);
    final peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
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
              height: 623.h,
              decoration: BoxDecoration(
                color: Color(0xff70B1B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "緊急聯絡人: ${emergencyContact.emergencyContact.length}/5",
                                      style: TextStyle(
                                          color: Color(0xff757575),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFFD9D9D9),
                                      width: 2,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 10.w, bottom: 10.h, top: 3.h, right: 3.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            emergencyContact.emergencyContact[
                                                widget.index]['name'],
                                            style: TextStyle(
                                              color: Color(0xff757575),
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w400,
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
                                            "聯絡方式:\n${emergencyContact.emergencyContact[widget.index]['contacts']}",
                                            style: TextStyle(
                                              color: Color(0xff757575),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Spacer(),
                                          // Container(
                                          //   margin: EdgeInsets.only(right: 5),
                                          //   child: ElevatedButton(
                                          //     onPressed: () {
                                          //       // Add your button action here
                                          //       showDialog(
                                          //         barrierDismissible:
                                          //             true, // 允许点击外部关闭
                                          //         context: context,
                                          //         builder:
                                          //             (BuildContext context) {
                                          //           return DeleteAlertDialog(
                                          //               onlyOne: emergencyContact
                                          //                       .emergencyContact
                                          //                       .length ==
                                          //                   1,
                                          //               index: widget.index);
                                          //         },
                                          //       );
                                          //     },
                                          //     style: ElevatedButton.styleFrom(
                                          //       backgroundColor:
                                          //           Color(0xffE99194),
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(8),
                                          //       ),
                                          //       padding: EdgeInsets.symmetric(
                                          //           horizontal: 12,
                                          //           vertical: 4),
                                          //       minimumSize: Size(0, 0),
                                          //       tapTargetSize:
                                          //           MaterialTapTargetSize
                                          //               .shrinkWrap,
                                          //     ),
                                          //     child: Text(
                                          //       '刪除',
                                          //       style: TextStyle(
                                          //         color: Colors.white,
                                          //         fontSize: 12,
                                          //         fontWeight: FontWeight.w400,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      height: 356.h,
                                      margin: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      // padding: EdgeInsets.all(10),
                                      child: SingleChildScrollView(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w),
                                                  child: Column(children: [
                                                    SizedBox(height: 5.h),
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
                                                        Spacer(),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isEditing =
                                                                  !isEditing;
                                                            });
                                                          },
                                                          child: Image.asset(
                                                            'assets/icons/edit.png',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.w),
                                                      decoration: BoxDecoration(
                                                          color: isEditing
                                                              ? Colors.white
                                                              : Colors
                                                                  .grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffD9D9D9),
                                                              width: 1.0)),
                                                      child: TextField(
                                                        controller:
                                                            nameController,
                                                        enabled: isEditing,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 16.w,
                                                                  right: 16.w,
                                                                  top: 0,
                                                                  bottom:
                                                                      8.h), // Added bottom padding
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight:
                                                            40, // Further reduced maximum height
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
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
                                                        // Text(
                                                        //   '開關',
                                                        //   style: TextStyle(
                                                        //     color: Color(
                                                        //         0xff757575),
                                                        //     fontSize: 16,
                                                        //   ),
                                                        // ),
                                                        SizedBox(width: 10.w),
                                                        SwitchButton(
                                                          initialValue: false,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              phoneSwitch =
                                                                  value;
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
                                                          width:
                                                              70.w, // 根据实际需要调整宽度
                                                          height: 40.h,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: phoneSwitch
                                                                  ? Colors.white
                                                                  : Colors.grey[
                                                                      100],
                                                              border:
                                                                  Border.all(
                                                                color: Color(
                                                                    0xffD9D9D9),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8),
                                                              ),
                                                            ),
                                                            child:
                                                                CountryCodeDropdown(),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            color: phoneSwitch
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey[200],
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight:
                                                                  40.h, // Further reduced maximum height
                                                            ),
                                                            child: TextField(
                                                              controller:
                                                                  phoneController,
                                                              keyboardType: TextInputType.number,
                                                              enabled:
                                                                  phoneSwitch,
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            16.w,
                                                                        right:
                                                                            16.w,
                                                                        top: 0,
                                                                        bottom:
                                                                            8.h),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8.0), // 右上角圆角
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            8.0), // 右下角圆角
                                                                  ),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0XFFD9D9D9),
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            12.0), // 右上角圆角
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            12.0), // 右下角圆角
                                                                  ),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0XFF70B1B8),
                                                                    width: 2.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize: 14.sp),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 20.w),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
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
                                                        // Text(
                                                        //   '開關',
                                                        //   style: TextStyle(
                                                        //     color: Color(
                                                        //         0xff757575),
                                                        //     fontSize: 16,
                                                        //   ),
                                                        // ),
                                                        SizedBox(width: 10.w),
                                                        SwitchButton(
                                                          initialValue: false,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              emailSwitch =
                                                                  value;
                                                            });
                                                            print(value);
                                                          },
                                                        ),
                                                        SizedBox(width: 20.w),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.w  ),
                                                      decoration: BoxDecoration(
                                                          color: emailSwitch
                                                              ? Colors.white
                                                              : Colors
                                                                  .grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffD9D9D9),
                                                              width: 1.0)),
                                                      child: TextField(
                                                        controller:
                                                            emailController,
                                                        enabled: emailSwitch,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 16.w,
                                                                  right: 16.w,
                                                                  top: 0,
                                                                  bottom: 8.h),
                                                        ),
                                                        style: TextStyle(
                                                            fontSize: 14.sp ),
                                                      ),
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight:
                                                            40.h, // Further reduced maximum height
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Row(
                                                      children:  [
                                                        SizedBox(width: 20.w),
                                                        Text(
                                                          '第三方通知',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 20.w),
                                                        Image.asset(
                                                            'assets/icons/line.png'),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                          '已綁定',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff757575),
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        // Text(
                                                        //   '開關',
                                                        //   style: TextStyle(
                                                        //     color: Color(
                                                        //         0xff757575),
                                                        //     fontSize: 16,
                                                        //   ),
                                                        // ),
                                                        SizedBox(width: 10.w),
                                                        SwitchButton(
                                                          initialValue: true,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              emailSwitch =
                                                                  value;
                                                            });
                                                            print(value);
                                                          },
                                                        ),
                                                        SizedBox(width: 20.w),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20.w),
                                                          child: ElevatedButton(
                                                            onPressed: () {},
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFF70B1B8),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          0),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(Icons.add,
                                                                    color: Colors
                                                                        .white),
                                                                SizedBox(
                                                                    width: 8.w),
                                                                Text(
                                                                  '其他通知方式',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20.w),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              // Add your button action here
                                                              print("edit");
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return EditCheckDialog(
                                                                      isDoubleCheck: (!phoneSwitch && !emailSwitch),
                                                                      name: nameController
                                                                          .text,
                                                                      phoneNumber:
                                                                          phoneController
                                                                              .text,
                                                                      email: emailController
                                                                          .text,
                                                                      contactId:
                                                                          emergencyContact.emergencyContact[widget.index]
                                                                              [
                                                                              'contactId']);
                                                                },
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFF70B1B8),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          10.h),
                                                            ),
                                                            child: Text(
                                                              '確認修改',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ])),
                                            ]),
                                      ),
                                    )),
                                  ],
                                )
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
