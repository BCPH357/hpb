import 'package:flutter/material.dart';
import 'package:hpb/restfulApi.dart';
import 'package:provider/provider.dart';

import 'checkTermsDialog.dart';
import 'mult_provider.dart';
import 'deviceFunctionPage.dart';
import 'accountEmergencyPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'accountSelfInfoPage.dart';
import 'alertDialog.dart';
import 'longText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//注意: 選單初始化內容會根據api的回傳
class HorizontalScrollingCheckboxes extends StatefulWidget {
  @override
  _HorizontalScrollingCheckboxesState createState() =>
      _HorizontalScrollingCheckboxesState();
}

class _HorizontalScrollingCheckboxesState
    extends State<HorizontalScrollingCheckboxes> {
  late Map medicalHistory;
  late TextEditingController notesController;

  final Map<String, String> medicalHistoryTranslations = {
    "noMedicalHistory": "無疾病史",
    "tuberculosis": "肺結核",
    "heartDisease": "心臟病",
    "hepatitis": "肝炎",
    "asthma": "氣喘",
    "kidneyDisease": "腎臟病",
    "epilepsy": "癲癇",
    "lupus": "紅斑性狼瘡",
    "hemophilia": "血友病",
    "g6pdDeficiency": "蠶豆症",
    "arthritis": "關節炎",
    "diabetes": "糖尿病",
    "mentalIllness": "心理或精神疾病",
    "cancer": "癌症",
    "thalassemia": "海洋性貧血",
    "majorSurgery": "重大手術",
    "drugAllergy": "藥物過敏",
  };

  late List<String> optionTexts;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();
    medicalHistory =
        Provider.of<PeopleInfo>(context, listen: false).medicalHistory;
    optionTexts = medicalHistory.keys
        .map((key) => medicalHistoryTranslations[key] ?? key)
        .toList()
        .cast<String>();
    print(medicalHistory);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    PeopleInfo peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6.0,
      radius: Radius.circular(10),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        List.generate((optionTexts.length + 1) ~/ 2, (index) {
                      return _buildCheckboxItem(index);
                    }),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(optionTexts.length ~/ 2, (index) {
                      return _buildCheckboxItem(
                          index + ((optionTexts.length + 1) ~/ 2));
                    }),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: TextField(
                controller: notesController,
                onChanged: (value) {
                  peopleInfo.setDependentNotes(value);
                },
                decoration: InputDecoration(
                  hintText: '其他疾病史...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(int index) {
    PeopleInfo peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
    String key = medicalHistory.keys.elementAt(index);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: medicalHistory[key],
            onChanged: (bool? value) {
              setState(() {
                medicalHistory[key] = value!;
              });
              peopleInfo.setMedicalHistory(medicalHistory);
            },
          ),
          Flexible(
            child: Text(
              optionTexts[index],
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Map getMedicalHistoryData() {
    return medicalHistory;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      final peopleInfo = Provider.of<PeopleInfo>(context);
      dropdownValue = peopleInfo.dependentCountryCode.isEmpty
          ? "+886"
          : peopleInfo.dependentCountryCode;
      _isInit = false; // 确保数据只被加载一次
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    PeopleInfo peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
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
        peopleInfo.setDependentCountryCode(dropdownValue);
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

class BloodTypeDropdown extends StatefulWidget {
  @override
  _BloodTypeDropdownState createState() => _BloodTypeDropdownState();
}

class _BloodTypeDropdownState extends State<BloodTypeDropdown> {
  String dropdownValue = 'A'; // 預設值

  @override
  Widget build(BuildContext context) {
    PeopleInfo peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(color: Color(0xffD9D9D9), width: 1.0),
      // ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24.sp,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 0,
          color: Colors.transparent,
        ),
        isDense: true, // 這會減少下拉式選單的垂直空間
        isExpanded: true,
        // itemHeight: 40, // 調整這個值來降低選單項目的高度
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
          peopleInfo.setDependentBloodType(dropdownValue);
        },
        items: <String>['A', 'B', 'AB', 'O']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class GenderDropdown extends StatefulWidget {
  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String dropdownValue = '男'; // 預設值

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890));
    PeopleInfo peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(color: Color(0xffD9D9D9), width: 1.0),
      // ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24.sp,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 0,
          color: Colors.transparent,
        ),
        isDense: true,
        isExpanded: true,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
          peopleInfo.setDependentGender(dropdownValue);
        },
        items: <String>['男', '女'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class AccountDependentInfo extends StatefulWidget {
  const AccountDependentInfo({super.key});

  @override
  _AccountDependentInfoState createState() => _AccountDependentInfoState();
}

class _AccountDependentInfoState extends State<AccountDependentInfo> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController ageController;
  bool isClicked = false;
  bool _isInit = true;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    ageController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final peopleInfo = Provider.of<PeopleInfo>(context);
      nameController.text = peopleInfo.dependentName;
      phoneController.text = peopleInfo.dependentPhone;
      ageController.text = (peopleInfo.dependentAge.toString()) == "0"
          ? ""
          : peopleInfo.dependentAge.toString();
      _isInit = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
    final emergency = Provider.of<Emergency>(context, listen: false);
    final peopleInfo = Provider.of<PeopleInfo>(context, listen: false);
    final emergencyContact = Provider.of<EmergencyContact>(context, listen: false);
    ScreenUtil.init(context, designSize: Size(411, 890));

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.22.w, vertical: 8.9.h),
        child: SingleChildScrollView(
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
              SizedBox(height: 10.h),
              Container(
                width: 369.9.w,
                height: 650.h,
                decoration: BoxDecoration(
                  color: Color(0xff70B1B8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SingleChildScrollView(
                    child: Container(
                      width: 369.9.w,
                      height: 680.h,
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
                                        "被照顧者資訊",
                                        style: TextStyle(color: Colors.black),
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
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "被照護者個人資訊",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      isClicked
                                          ? SizedBox(
                                              width:
                                                  80.w, // Adjust this value to match the original button width
                                              height:
                                                  40.h, // Adjust this value to match the original button height
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
                                                    horizontal: 15.w, vertical: 10.h),
                                              ),
                                              child: Text(
                                                '編輯',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      "姓名: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                      child: Container(
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
                                                  color: Colors.white,
                                                  width: 1.0),
                                        ),
                                        child: TextField(
                                          controller: nameController,
                                          enabled: isClicked, // 禁止輸入
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 16.w, vertical: 4.h),
                                            isDense: true,
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Text(
                                      "性別: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                      child: Container(
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
                                                  color: Colors.white,
                                                  width: 1.0),
                                        ),
                                        child: GenderDropdown(),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Text(
                                      "年齡: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(width: 15.w),
                                    Container(
                                      width: 82.2.w,
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
                                        controller: ageController,
                                        enabled: isClicked, // 禁止輸入
                                        keyboardType: TextInputType.number, // 設定數字鍵盤
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 4.h),
                                          isDense: true,
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "血型: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(width: 15.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.h),
                                      width: 82.2.w,
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
                                      child: BloodTypeDropdown(),
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      Text(
                                        "手機",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 22.w),
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
                                        enabled: isClicked, // 禁用输入
                                        keyboardType: TextInputType.number, // 設定數字鍵盤
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: isClicked
                                              ? Colors.white
                                              : Color(0xFFD9D9D9), // 设置灰色背景
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 16.w),
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
                                  Row(
                                    children: [
                                      Text(
                                        "疾病史",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => CheckTermsDialog(term: term),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 16.w, right: 16.w),
                                          padding: EdgeInsets.only(bottom: 1.h), // 文本和底线之间的间距
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Color(0xff98CDD4), // 底线颜色
                                                width: 1, // 底线厚度
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            '隱私條款:使用範圍聲明',
                                            style: TextStyle(
                                              color: Color(0xff98CDD4),
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 225.5.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Color(0xffD9D9D9), // 邊框顏色
                                        width: 1.0, // 邊框寬度
                                      ),
                                    ),
                                    child: HorizontalScrollingCheckboxes(),
                                  ),
                                  SizedBox(height: 10.h),
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
                                                final result =
                                                    await updateCareRecipient2(
                                                        name: nameController.text,
                                                        medicalHistory: peopleInfo
                                                            .medicalHistory,
                                                        age:
                                                            ageController.text.isNotEmpty ? int.parse(ageController.text) : 0,
                                                        gender: peopleInfo
                                                            .dependentGender,
                                                        bloodType: peopleInfo
                                                            .dependentBloodType,
                                                        countryCode: peopleInfo
                                                            .dependentCountryCode,
                                                        phoneNumber:
                                                            phoneController.text,
                                                        notes: peopleInfo
                                                            .dependentNotes);
                                                if (result == "success") {
                                                  
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        HttpAlertDialog(errorMessage: result),
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
                                                    horizontal: 10.w, vertical: 10.h),
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
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
