import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';
import 'deviceFunctionPage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'familysHomePage.dart';
import 'restfulApi.dart';
import 'dart:async';
import 'alertDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DeleteAlertDialog extends StatelessWidget {
  final int index;
  const DeleteAlertDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 356.h,
        width: 390.45.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        // color: Colors.green,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 40.h),
            Expanded(
              child: Container(
                // color: Colors.red,
                width: 267.15.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Image.asset(
                      'assets/icons/bigWarning.png',
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "確認刪除 ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${deviceInfo.familyData[index]["familyName"]}",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Color(0xff70B1B8),
                          ),
                        ),
                        Text(
                          " ？",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Add your button action here
                            Navigator.pop(context);
                          },
                          child: Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xff70B1B8),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Color(0xff70B1B8),
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.all(5.h),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Add your button action here
                            final res = await deleteFamilyMember(
                                deviceInfo.familyData[index]["followId"],
                                deviceInfo);
                            if (res == "success") {
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => HttpAlertDialog(errorMessage: res),
                              );
                            }
                          },
                          child: Text(
                            '確認',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff70B1B8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(5.h),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class ReNameAlertDialog extends StatelessWidget {
  final int index;
  ReNameAlertDialog({super.key, required this.index});
  final TextEditingController familyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 356.h,
        width: 390.45.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        // color: Colors.green,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "家庭名稱設定",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40.h),
            Expanded(
              child: Container(
                // color: Colors.red,
                width: 267.15.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '修改家庭名稱',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: familyNameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15.w ),
                          border: InputBorder.none,
                          hintText: deviceInfo.familyData[index]["familyName"],
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xff70B1B8),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Color(0xff70B1B8),
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.all(5.h),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Add your button action here
                            final res = await updateFamilyMember(
                                deviceInfo.familyData[index]["followId"],
                                familyNameController.text,
                                deviceInfo);
                            if (res == "success") {
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => HttpAlertDialog(errorMessage: res),
                              );
                            }
                          },
                          child: Text(
                            '確認',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff70B1B8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(5.h),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class AddFamilyDialog extends StatefulWidget {
  const AddFamilyDialog({super.key});

  @override
  _AddFamilyDialogState createState() => _AddFamilyDialogState();
}

class _AddFamilyDialogState extends State<AddFamilyDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _isInput = false;

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
          height: 500.5.h,
          width: 369.9.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          // color: Colors.green,

          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30.w,
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    "新增家庭",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
                SizedBox(width: 30.w),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "輸入對方家庭帳號信箱",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff757575),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: _emailController,
                      onChanged: (value) {
                        setState(() {
                          deviceInfo.setFamilyVerifyEmail(value);
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xff757575)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xff757575)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xff757575), width: 2),
                        ),
                        // hintText: "請輸入對方家庭帳號信箱",
                        // hintStyle: TextStyle(
                        //   color: Color(0xff757575),
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.w300,
                        // ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(children: [
                      Expanded(child: CountdownButton()),
                    ]),
                    SizedBox(height: 15.h),
                    Container(
                      height: 1.h,
                      color: Color(0xff70B1B8),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "驗證碼",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff757575),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: _verificationCodeController,
                      onChanged: (value) {
                        setState(() {
                          _isInput = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xff757575)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xff757575)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xff757575), width: 2),
                        ),
                        // hintText: "請輸入對方家庭帳號信箱",
                        // hintStyle: TextStyle(
                        //   color: Color(0xff757575),
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.w300,
                        // ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_isInput) {
                              final result = await addFamilyMember(
                                  _emailController.text,
                                  _verificationCodeController.text,
                                  deviceInfo);
                              if (result == "success") {
                                Navigator.pop(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => HttpAlertDialog(errorMessage: result),
                                );
                              }
                            }
                          },
                          child: Text('確認'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                _isInput
                                    ? Color(0xff70B1B8)
                                    : Color(0xffD9D9D9)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 50.w, vertical: 5.h),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: 15.h),
                  ]),
            ),
          ])),
    );
  }
}

class CountdownButton extends StatefulWidget {
  @override
  _CountdownButtonState createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  bool _isCountingDown = false;
  //倒數60秒
  int _countdown = 60;
  Timer? _timer;

  void _startCountdown() async {
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    //要一起改
    if (_countdown == 60) {
      final result =  await sendFamilyVerificationEmail(
          deviceInfo.familyVerifyEmail, deviceInfo);
      if (result == "success") {
      } else {
        showDialog(
          context: context,
          builder: (context) => HttpAlertDialog(errorMessage: result),
        );
      }
    }
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
          //要一起改
          _countdown = 60;
        });
      }
    });
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
      child: Text(_isCountingDown ? '${_countdown}s後可以再次發送驗證碼' : '發送邀請'),
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
          EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.h),
        ),
      ),
    );
  }
}

class Family extends StatefulWidget {
  const Family({super.key});

  @override
  _FamilyState createState() => _FamilyState();
}

class _FamilyState extends State<Family> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: true);
    // deviceInfo.setFamilyData();

    return Align(
      alignment: Alignment.topCenter, // 让 Container 对齐到顶部
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8.22.w, vertical: 17.8.h),
        child: Column(
          children: [
            Text(
              "家庭",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
                width: 390.45.w ,
                height: 592.h,
                decoration: BoxDecoration(
                  color: Color(0xff70B1B8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          "家庭列表",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AddFamilyDialog(),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xff757575),
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/addFamily.png',
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          "新增家庭",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Color(0xff757575),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "家庭數: ${deviceInfo.familyData.length}/100",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color(0xff757575),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true, // 总是显示滚动条
                            thickness: 6.0, // 滚动条厚度
                            radius: Radius.circular(10),
                            child: ListView.builder(
                              itemCount: deviceInfo
                                  .familyData.length, // 假設有10個家庭成員，您可以根據實際情況調整
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 10.w),
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xffD9D9D9),
                                      width: 2.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          (deviceInfo.familyData[index]["followEachOther"] == true || deviceInfo.familyData[index]["followEachOther"] == null || !deviceInfo.familyData[index].containsKey("followEachOther"))
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w,
                                                      vertical: 2.h),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff757575),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    '互相關注',
                                                    style: TextStyle(
                                                      color: Color(0xff757575),
                                                      fontSize: 13.sp,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(height: 15.h ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        children: [
                                          Text(
                                            deviceInfo.familyData[index]
                                                ["familyName"],
                                            style: TextStyle(
                                              color: Color(0xff757575),
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              final res = await getFamilyMemberDevices(
                                                  deviceInfo.familyData[index]
                                                      ["followId"],
                                                  deviceInfo);
                                              if (res == "success") {
                                                Navigator.push(
                                                  context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FamilySHomePage(
                                                          index: index),
                                                ),
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => HttpAlertDialog(errorMessage: res),
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                color: Color(0xff70B1B8),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '拜訪',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          InkWell(
                                            onTap: () {
                                              print("edit");
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ReNameAlertDialog(
                                                        index: index),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Color(0xff70B1B8),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                '編輯',
                                                style: TextStyle(
                                                  color: Color(0xff70B1B8),
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    DeleteAlertDialog(
                                                        index: index),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                color: Color(0xffE99194),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '刪除',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
