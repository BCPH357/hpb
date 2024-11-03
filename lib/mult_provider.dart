import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class PeopleInfo with ChangeNotifier {
  String _selfName = "";
  String _selfPhone = "";
  String _selfEmail = "";
  String _selfCountryCode = "";

  String _dependentName = "";
  String _dependentPhone = "";
  String _dependentCountryCode = "";
  String _dependentGender = "";
  int _dependentAge = 0;
  String _dependentBloodType = "";
  String _dependentNotes = "";
  Map _medicalHistory = {};

  String get selfName => _selfName;
  String get selfPhone => _selfPhone;
  String get selfEmail => _selfEmail;
  String get selfCountryCode => _selfCountryCode;

  String get dependentName => _dependentName;
  String get dependentPhone => _dependentPhone;
  String get dependentCountryCode => _dependentCountryCode;
  String get dependentGender => _dependentGender;
  int get dependentAge => _dependentAge;
  String get dependentBloodType => _dependentBloodType;
  String get dependentNotes => _dependentNotes;
  Map get medicalHistory => _medicalHistory;

  setSelfPhone(String phone) {
    _selfPhone = phone;
    notifyListeners();
  }

  setDependentNotes(String notes) {
    _dependentNotes = notes;
    notifyListeners();
  }

  setDependentCountryCode(String countryCode) {
    _dependentCountryCode = countryCode;
    notifyListeners();
  }

  setDependentGender(String gender) {
    _dependentGender = gender;
    notifyListeners();
  }

  setDependentBloodType(String bloodType) {
    _dependentBloodType = bloodType;
    notifyListeners();
  }

  setMedicalHistory(Map medicalHistory) {
    _medicalHistory = medicalHistory;
    notifyListeners();
  }

  setDependentInfo(Map careRecipient) {
    _dependentName = careRecipient["name"] ?? "";
    _dependentPhone = careRecipient["phoneNumber"] ?? "";
    _dependentCountryCode = careRecipient["countryCode"] ?? "";
    _dependentGender = careRecipient["gender"] ?? "";
    _dependentAge = careRecipient["age"] ?? 0;
    _dependentBloodType = careRecipient["bloodType"] ?? "";
    notifyListeners();
  }

  setSelfInfo(Map selfInfo) {
    _selfName = selfInfo["name"] ?? "";
    _selfPhone = selfInfo["phoneNumber"] ?? "";
    _selfEmail = selfInfo["email"] ?? "";
    _selfCountryCode = selfInfo["countryCode"] ?? "";
    notifyListeners();
  }

  setSelfCountryCode(String countryCode) {
    _selfCountryCode = countryCode;
    notifyListeners();
  }
}

class DeviceInfo with ChangeNotifier {
  List _device = [];
  List _familyData = [];
  String _familyVerifyCode = "";
  String _familyVerifyEmail = "";
  List _familyDevice = [];
  Map _ezCaringData = {};

  String _ezCaringTemp = "";
  String _wifiTemp = "";
  String _wifiPasswordTemp = "";

  String _deviceName = "";
  String _macAddress = "";
  // String _macAddress = "b48a0ae2b66b";
  // String _macAddress = "b48a0ae2cb2c";
  Image _boundaryImage = Image.asset("assets/icons/no_people.png");
  List get device => _device;
  List get familyData => _familyData;
  String get familyVerifyCode => _familyVerifyCode;
  String get familyVerifyEmail => _familyVerifyEmail;
  List get familyDevice => _familyDevice;
  String get ezCaringTemp => _ezCaringTemp;
  String get wifiTemp => _wifiTemp;
  String get deviceName => _deviceName;
  String get macAddress => _macAddress;
  Image get boundaryImage => _boundaryImage;
  Map get ezCaringData => _ezCaringData;
  // setDeviceInfo(List device) {
  //   for (int i = 0; i < device.length; i++) {
  //     _device.add(device[i]);
  //     if (_device[i]["data"] != null) {

  //     }
  //   }
  // }

  // setMacAddress(String mac) {
  //   _macAddress = mac;
  //   notifyListeners();
  // }
  killAllStatus() {
    _device = [];
    _familyData = [];
    _familyVerifyCode = "";
    _familyVerifyEmail = "";
    _familyDevice = [];
    _ezCaringData = {};
    _ezCaringTemp = "";
    _wifiTemp = "";
    _wifiPasswordTemp = "";

    _deviceName = "";
    _macAddress = "";
  }

  killStatus() {
    _ezCaringData = {};
    _ezCaringTemp = "";
    _wifiTemp = "";
    _wifiPasswordTemp = "";

    _deviceName = "";
    _macAddress = "";
    // notifyListeners();
  }

  getBoundaryImage(String deviceId) {
    return _boundaryImage;
  }

  setDeviceWarningHash(String key) {
    Map deviceWarningHash = {
      "FALL_DOWN": "跌倒警告",
      "SENTRY": "哨兵警告",
      "LUX_LOW": "亮度不足",
      "MUTE": "靜音模式",
      "CO2_LV1": "二氧化碳警告 Level 1",
      "CO2_LV2": "二氧化碳警告 Level 2",
      "LONG_TIME_SITTING_LV1": "久坐警告 lv1",
      "LONG_TIME_SITTING_LV2": "久坐警告 lv2",
      "LONG_TIME_LYING_LV1": "久躺警告 lv1",
      "LONG_TIME_LYING_LV2": "久躺警告 lv2",
    };
    return deviceWarningHash.containsKey(key) ? deviceWarningHash[key] : key;
  }

  setEzCaringData(Map ezCaringData) {
    _ezCaringData = {
      "mac": ezCaringData["mac"],
      "ssid": ezCaringData["ssid"],
      "password": ezCaringData["password"],
      "set": ezCaringData["set"],
    };
    print(_ezCaringData);
    print("ezCaringData");
    notifyListeners();
  }

  setFamilyVerifyEmail(String email) {
    _familyVerifyEmail = email;
    notifyListeners();
  }

  setFamilyVerifyCode(String code) {
    _familyVerifyCode = code;
    notifyListeners();
  }

  setBoundaryImage(Image boundaryImage) {
    _boundaryImage = boundaryImage;
    notifyListeners();
  }

  setDeviceName(String name) {
    _deviceName = name;
    notifyListeners();
  }

  setMacAddress(String mac) {
    _macAddress = mac;
    notifyListeners();
  }

  setWifiTemp(String temp) {
    _wifiTemp = temp;
    notifyListeners();
  }

  setWifiPasswordTemp(String temp) {
    _wifiPasswordTemp = temp;
    notifyListeners();
  }

  setEzCaringTemp(String temp) {
    _ezCaringTemp = temp;
    notifyListeners();
  }

  killEzCaringTemp() {
    _ezCaringTemp = "";
    notifyListeners();
  }

  setVoiceLightBed(Map voiceLightBed, int index) {
    _device[index]["lightStatus"] = voiceLightBed["lightStatus"];
    _device[index]["speakerStatus"] = voiceLightBed["speakerStatus"];
    _device[index]["boundaryParameters"] = voiceLightBed["boundaryParameters"];
    notifyListeners();
  }

  // Map<String, double> getLightLevel(int index, int mode) {
  //   if (mode == 0) {
  //     Map<String, double> returnVal = {
  //       "mode": 0,
  //       "level": _device[index]["lightStatus"]["level"],
  //     };
  //     return returnVal;
  //   } else if (mode == 1) {
  //     Map<String, double> returnVal = {
  //       "mode": 1,
  //     };
  //     return returnVal;
  //   } else {
  //     Map<String, double> returnVal = {
  //       "mode": 2,
  //       "level": _device[index]["lightStatus"]["advencedLevel"],
  //     };
  //     return returnVal;
  //   }
  // }

  setLightLevel(int index, String key, double value) {
    _device[index]["lightStatus"]["advencedLevel"][key] = value;
    notifyListeners();
  }

  List<String> getAllDeviceName() {
    List<String> deviceName = [];
    for (int i = 0; i < _device.length; i++) {
      deviceName.add(_device[i]["name"]);
    }
    return deviceName;
  }

  String getDeviceIdByName(String name) {
    for (int i = 0; i < _device.length; i++) {
      if (_device[i]["name"] == name) {
        return _device[i]["deviceId"];
      }
    }
    return "";
  }

  setFamilyDevice(List familyDeviceInfo) {
    _familyDevice = [];
    for (int i = 0; i < familyDeviceInfo.length; i++) {
      Map<String, dynamic> tempDevice = {
        "deviceId": familyDeviceInfo[i]["deviceId"],
        "name": familyDeviceInfo[i]["deviceName"],
        "status": familyDeviceInfo[i]["status"],
        "behavioralType": familyDeviceInfo[i]["data"] == null
            ? ["NO_PEOPLE"]
            : familyDeviceInfo[i]["data"]["behaviorStatus"],
        "temperature": familyDeviceInfo[i]["data"] == null
            ? 0
            : familyDeviceInfo[i]["data"]["roomTmp"],
        "warnings": familyDeviceInfo[i]["data"] == null
            ? []
            : familyDeviceInfo[i]["data"]["warnings"],
      };
      _familyDevice.add(tempDevice);
    }

    notifyListeners();
  }

  setDeviceInfo(List deviceInfo) {
    _device = [];
    for (int i = 0; i < deviceInfo.length; i++) {
      Map<String, dynamic> tempDevice = {
        "deviceId": deviceInfo[i]["deviceId"],
        "name": deviceInfo[i]["deviceName"],
        "status": deviceInfo[i]["status"],
        "behavioralType": deviceInfo[i]["data"] == null
            ? ["NO_PEOPLE"]
            : deviceInfo[i]["data"]["behaviorStatus"],
        "temperature": deviceInfo[i]["data"] == null
            ? 0
            : deviceInfo[i]["data"]["roomTmp"],
        "warnings": deviceInfo[i]["data"] == null
            ? []
            : deviceInfo[i]["data"]["warnings"],
      };
      _device.add(tempDevice);
    }
    // _device = [
    //   {
    //     "name": "嬤嬤房間",
    //     "status": "walking",
    //     "temperature": 25,
    //     "warning": "亮度不足"
    //   },
    //   {"name": "庭院", "status": "walking", "temperature": 25, "warning": "亮度不足"},
    //   {
    //     "name": "衛浴六後面省略",
    //     "status": "walking",
    //     "temperature": 25,
    //     "warning": "亮度不足"
    //   },
    //   {"name": "樓梯", "status": "walking", "temperature": 25, "warning": "亮度不足"}
    // ];
    notifyListeners();
  }

  updateDeviceName(String deviceId, String newDeviceName) {
    for (int i = 0; i < _device.length; i++) {
      if (_device[i]["deviceId"] == deviceId) {
        _device[i]["name"] = newDeviceName;
      }
    }
    notifyListeners();
  }

  setFamilyData(List familyData) {
    _familyData = [];
    // List<Map<String, dynamic>> tempFamilyData = [];
    for (int i = 0; i < familyData.length; i++) {
      _familyData.add({
        "familyName": familyData[i]["familyName"],
        "followId": familyData[i]["followId"],
        "userId": familyData[i]["userId"],
        "followEachOther": familyData[i]["followEachOther"],
        "device": [],
      });
    }
    notifyListeners();
  }

  addFamilyData(Map familyData) {
    _familyData.add({
      "familyName": familyData["familyName"],
      "followId": familyData["followId"],
      "userId": familyData["userId"],
      "followEachOther": familyData["followEachOther"],
      "device": [],
    });
    notifyListeners();
  }

  updateFamilyMember(String followId, String familyName) {
    for (int i = 0; i < _familyData.length; i++) {
      if (_familyData[i]["followId"] == followId) {
        _familyData[i]["familyName"] = familyName;
        break;
      }
    }
    notifyListeners();
  }

  deleteFamilyMember(String followId) {
    for (int i = 0; i < _familyData.length; i++) {
      if (_familyData[i]["followId"] == followId) {
        _familyData.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  // setFamilyData() {
  //   _familyData = [
  //     {
  //       "familyName": "財哥的家",
  //       "device": [
  //         {
  //           "name": "麼麼房間",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "客廳",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "庭院",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "衛浴六後面省略",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "樓梯",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         }
  //       ],
  //     },
  //     {
  //       "familyName": "嬤嬤的家",
  //       "device": [
  //         {
  //           "name": "客廳",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "嬤嬤房間",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "庭院",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "衛浴六後面省略",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "樓梯",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         }
  //       ],
  //     },
  //     {
  //       "familyName": "老徐的家",
  //       "device": [
  //         {
  //           "name": "客廳",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "嬤嬤房間",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "庭院",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "衛浴六後面省略",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         },
  //         {
  //           "name": "樓梯",
  //           "status": "walking",
  //           "temperature": 25,
  //           "warning": "亮度不足"
  //         }
  //       ],
  //     },
  //   ];
  // }

  setImageHash(String hash) {
    Map imageHash = {
      "SOME_PEOPLE": "assets/icons/walking.png",
      "NO_PEOPLE": "NO_PEOPLE",
      "SLEEP": "assets/icons/sleep.png",
      "SIT": "assets/icons/sit.png",
      "FALL_DOWN": "assets/icons/fallDown.png",
      "BED_BOUNDARY": "assets/icons/BED_BOUNDARY.png",
      "SENTRY_MODE": "assets/icons/SENTRY_MODE.png",
    };
    return imageHash[hash];
    // notifyListeners();
  }

  // killStatus() {
  //   _device = [];
  //   // notifyListeners();
  // }
}

class Emergency with ChangeNotifier {
  List _emergency = [];
  List _event = [];

  List get emergency => _emergency;
  List get event => _event;

  // setEmergency() {
  //   _emergency = [
  //     ["哨兵警告", "庭院", "2024/08/07"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //   ];
  //   _event = [
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["事件通知", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //     ["哨兵警告", "庭院", "2024/08/06"],
  //   ];
  //   // notifyListeners();
  // }

  setDeviceWarningHash(String key) {
    Map deviceWarningHash = {
      "FALL_DOWN": "跌倒警告",
      "SENTRY": "哨兵警告",
      "LUX_LOW": "亮度不足",
      "MUTE": "靜音模式",
      "CO2_LV1": "二氧化碳過濃",
      "CO2_LV2": "二氧化碳過濃",
      "LONG_TIME_SITTING_LV1": "久坐警告",
      "LONG_TIME_SITTING_LV2": "久坐警告",
      "LONG_TIME_LYING_LV1": "久躺警告",
      "LONG_TIME_LYING_LV2": "久躺警告",
    };
    return deviceWarningHash.containsKey(key) ? deviceWarningHash[key] : key;
  }

  setEmergencyWarningLogs(List date) {
    _emergency = [];
    for (int i = 0; i < date.length; i++) {
      _emergency.add([
        setDeviceWarningHash(date[i]["warningType"]),
        date[i]["deviceName"],
        formatDateString(date[i]["date"])
      ]);
    }
  }

  setEventWarningLogs(List date) {
    _event = [];
    for (int i = 0; i < date.length; i++) {
      _event.add([
        setDeviceWarningHash(date[i]["warningType"]),
        date[i]["deviceName"],
        formatDateString(date[i]["date"])
      ]);
    }
  }

  String formatDateString(String inputDate) {
    // 解析原始日期字符串
    DateTime parsedDate = DateTime.parse(inputDate);
    // 創建 DateFormat 對象來格式化日期
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    // 返回格式化後的日期字符串
    return formatter.format(parsedDate);
  }

  killStatus() {
    _emergency = [];
    _event = [];
    // notifyListeners();
  }
}

class EmergencyContact with ChangeNotifier {
  List _emergencyContact = [];
  String _countryCode = '+1';

  List get emergencyContact => _emergencyContact;
  String get countryCode => _countryCode;

  setCountryCode(String countryCode) {
    _countryCode = countryCode;
    notifyListeners();
  }

  deleteEmergencyContactByIndex(int index) {
    if (index >= 0 && index < _emergencyContact.length) {
      _emergencyContact.removeAt(index);
      notifyListeners();
    }
  }

  setEmergencyContact(List emergencyContact) {
    _emergencyContact = [];
    for (int i = 0; i < emergencyContact.length; i++) {
      _emergencyContact.add({
        "contactId": emergencyContact[i]["contactId"] ?? "",
        "countryCode": emergencyContact[i]["countryCode"] ?? "",
        "name": emergencyContact[i]["name"] ?? "",
        "phoneNumber": emergencyContact[i]["phoneNumber"] ?? "",
        "email": emergencyContact[i]["email"] ?? "",
        "contacts": emergencyContact[i]["contacts"] ?? "電話、Email、line"
      });
    }
    notifyListeners();
  }

  addEmergencyContact(Map emergencyContact) {
    _emergencyContact.add({
      "contactId": emergencyContact["contactId"] ?? "",
      "countryCode": emergencyContact["countryCode"] ?? "",
      "name": emergencyContact["name"] ?? "",
      "phoneNumber": emergencyContact["phoneNumber"] ?? "",
      "email": emergencyContact["email"] ?? "",
      "contacts": emergencyContact["contacts"] ?? "電話、Email、line"
    });
    notifyListeners();
  }

  // setEmergencyContact() {
  //   _emergencyContact = [
  //     {
  //       "name": "王小美",
  //       "phone": "0987654321",
  //       "mail": "abc@gmail.com",
  //       "contacts": "電話、Email、line"
  //     },
  //     {
  //       "name": "陳小美",
  //       "phone": "0987654321",
  //       "mail": "abc@gmail.com",
  //       "contacts": "電話、Email、line"
  //     },
  //     {
  //       "name": "林小美",
  //       "phone": "0987654321",
  //       "mail": "abc@gmail.com",
  //       "contacts": "電話、Email、line"
  //     },
  //     {
  //       "name": "黃小美",
  //       "phone": "0987654321",
  //       "mail": "abc@gmail.com",
  //       "contacts": "電話、Email、line"
  //     },
  //     {
  //       "name": "劉小美",
  //       "phone": "0987654321",
  //       "mail": "abc@gmail.com",
  //       "contacts": "電話、Email、line"
  //     },
  //   ];
  //   // notifyListeners();
  // }

  killStatus() {
    _emergencyContact = [];
    // notifyListeners();
  }
}

class FaqInfo with ChangeNotifier {
  List _faq = [];

  List get faq => _faq;

  setFaq() {
    _faq = [
      [
        {
          "question": "Q1.問題1: 如何將EZcaring P1與APP進行配對？",
          "answer":
              "– 註冊一個新帳戶及設定密碼，進行登入。\n– 請查看Ezcaring P1上的指示燈為藍燈，表示裝置已準備好與APP進行配對設定。\n– 登入後進入首頁，點擊「新增裝置」，可直接掃描QR Code或自行選擇裝置進行配對。"
        }
      ],
      [
        {
          "question": "Q2.問題2: 如何將 EZcaring P1 連接Wi-Fi（首次設定）？",
          "answer":
              "– 裝置與App配對成功後，請點選「新增Wi-Fi」，設定Wi-Fi連線。請確認Ezcaring P1裝置上的指示燈為白燈，並收到語音訊息「  TBD 」，表示Wi-Fi已連線完成。"
        }
      ],
      [
        {
          "question": "Q3.問題3: 若裝置連線發生斷線或異常時，要如何排除問題？請依下列步驟，排查問題。",
          "answer":
              "(1) 檢查裝置電源插頭。\n(2) 查看裝置左側指示燈，若紫燈閃爍超過2分鐘，檢查家中網路是否正常運作。\n(3) 請按裝置左側的重設鍵，重啟裝置，進入APP重新進行裝置配對流程。\n(4) 請將電源拔除，重新插上，進入APP重新進行裝置配對與Wi-Fi設定流程。"
        }
      ],
      [
        {
          "question": "Q4.問題4: 床緣邊界設定取圖說明。如何判斷取圖正確？",
          "answer":
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("正確取圖與床緣四點座標設定"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Image.asset("assets/images/true_set_first.png", width: 100.w),
                        Image.asset("assets/images/true_set_second.png", width: 100.w),
                      ],),
                    ),
                    Text("錯誤床緣四點座標設定"),
                    Image.asset("assets/images/false_set.png", width: 100.w),
                    Text("可用取圖，請正確設定床緣四點座標，確保安全偵測範圍。"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Image.asset("assets/images/true_get_first.png", width: 100.w),//
                        Image.asset("assets/images/true_get_second.png", width: 100.w),//
                      ],),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Image.asset("assets/images/true_get_third.png", width: 100.w),//
                        Image.asset("assets/images/true_get_fourth.png", width: 100.w),//
                      ],),
                    ),
                    Text("錯誤取圖，請點擊'重新設定'，再次取圖。"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Image.asset("assets/images/false_get_first.png", width: 100.w),//
                        Image.asset("assets/images/false_get_second.png", width: 100.w),//
                      ],),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Image.asset("assets/images/false_get_third.png", width: 100.w),//
                        Image.asset("assets/images/false_get_fourth.png", width: 100.w),//
                      ],),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Image.asset("assets/images/false_get_fifth.png", width: 100.w),//
                      ],),
                    ),
                  ],
                ),
                // child: Text(
                //   "正確取圖與床緣四點座標設定\n錯誤床緣四點座標設定\n可用取圖，請正確設定床緣四點座標，確保安全偵測範圍。\n錯誤取圖，請點擊'重新設定'，再次取圖。"
                // ),
              )
        }
      ],
      [
        {
          "question": "Q5.問題5: EZcaring P1是否需要電池或連接電源？",
          "answer": "Ezcaring P1需要插入電源才能運行。"
        }
      ],
      [
        {
          "question": "Q6.問題6: 何時會收到EZcaring P1語音詢問播放？",
          "answer":
              "當EZcaring P1偵測到跌倒時，會播放語音訊息：「您跌倒了嗎？如果沒有，請揮手或起身。」若被照護者依照語音指示做出反應，EZcaring 將解除跌倒通報，表示已處於安全狀態。隨後，裝置將停止播放語音一分鐘。如果在這一分鐘內再次偵測到跌倒，裝置會在一分鐘後再次播放語音訊息，以確認被照護者的最新狀態。提醒：請確認APP聲音設定是否開啟。"
        }
      ],
      [
        {
          "question": "Q7.問題7:EZcaring P1裝置可以離線使用嗎？",
          "answer":
              "EZcaring必須連接Wi-Fi使用。離線狀態或Wi-Fi連接失敗狀況下，EZcaring將無法向您的智慧手機或其他裝置發送或其他偵測功能，也無法和APP互動。"
        }
      ],
      [
        {
          "question": "Q8.問題8: 更改或重設Wi-Fi失敗",
          "answer":
              "如遇更改或重設Wi-Fi失敗時，請確認下列情形\n–是否使用EZcaring原廠插頭\n–欲連線的網路是否穩定順暢\n– EZcaring裝置完成WiFi重置，指示燈號呈現白燈，如未完成重置，請長按EZcaring裝置左側的重置鈕直到藍燈閃爍\n–確認手機開啟Wi-Fi並確實連線到您指定的WiFi\n–確認輸入的Wifi密碼是否正確"
        }
      ],
      [
        {
          "question": "Q9.問題9: 一直無法完成配對怎麼辦？",
          "answer":
              "–請確認電源狀態\n–請確認當下網路連線是否順暢\n–請確認手機開啟Wi-Fi，並且確認手機與EZcaring 的Wi-Fi設定皆確實連線到您指定的網路AP\n–請將EZcaring電源拔除，再重新上電"
        }
      ],
      [
        {
          "question": "Q10.問題10: 取消訂閱服務?",
          "answer": "請您依照訂閱的平台取消訂閱。   *提醒您，直接刪除app並不會取消訂閱。"
        }
      ],
      [
        {
          "question": "Q11.問題11: EZcaring P1 APP應用程式提供哪些語系版本？",
          "answer":
              "Ezcaring APP提供英語，中文，日語，德語版本。APP會依據您手機的語言設置，設定為使用預設值。若非APP提供語言，將預設為英語版本。"
        }
      ],
      [
        {
          "question": "Q12.問題12: EZcaring App需要收費嗎？",
          "answer":
              "下載EZcaring App是免費的。EZcaring訂閱服務提供了免費的基本方案和付費方案，您可於下載後從App內進行付費訂閱。"
        }
      ],
      [
        {
          "question": "Q13.問題13: 可以關閉通知嗎？",
          "answer": "您可至手機的系統設定進行通知管理，但我們不建議您關閉通知。"
        }
      ],
    ];
    // notifyListeners();
  }

  killStatus() {
    _faq = [];
    // notifyListeners();
  }
}

class VisualCharts with ChangeNotifier {
  Map _visualCharts = {
    "first": [0],
    "second": [0]
  };
  Map _visualChartsSleep = {
    "first": [0],
    "second": [0]
  };
  String _tempDevice = "";
  List<Color> _firstColor = [Colors.white];
  List<Color> _secondColor = [Colors.white];
  List<Color> _firstColorSleep = [Colors.white];
  List<Color> _secondColorSleep = [Colors.white];
  num _noPersonCount = 0;
  num _sittingCount = 0;
  num _noDataCount = 0;
  num _sleepCount = 0;
  num _somePeopleCount = 0;
  num _fallDownCount = 0;

  String _noPersonTime = "0時0分";
  String _sittingTime = "0時0分";
  String _noDataTime = "0時0分";
  String _sleepTime = "0時0分";
  String _somePeopleTime = "0時0分";
  String _fallDownTime = "0時0分";

  String _allSleepTime = "0時0分";
  String _allOnBedTime = "0時0分";
  String _allOffBedTime = "0時0分";

  Map get visualCharts => _visualCharts;
  Map get visualChartsSleep => _visualChartsSleep;
  List<Color> get firstColor => _firstColor;
  List<Color> get secondColor => _secondColor;
  List<Color> get firstColorSleep => _firstColorSleep;
  List<Color> get secondColorSleep => _secondColorSleep;
  String get tempDevice => _tempDevice;

  num get noPersonCount => _noPersonCount;
  num get sittingCount => _sittingCount;
  num get noDataCount => _noDataCount;
  num get sleepCount => _sleepCount;
  num get somePeopleCount => _somePeopleCount;
  num get fallDownCount => _fallDownCount;

  String get noPersonTime => _noPersonTime;
  String get sittingTime => _sittingTime;
  String get noDataTime => _noDataTime;
  String get sleepTime => _sleepTime;
  String get somePeopleTime => _somePeopleTime;
  String get fallDownTime => _fallDownTime;

  String get allSleepTime => _allSleepTime;
  String get allOnBedTime => _allOnBedTime;
  String get allOffBedTime => _allOffBedTime;

  String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600; // 计算小时数
    int minutes = (totalSeconds % 3600) ~/ 60; // 计算剩余分钟数

    // 构建格式化字符串，省略秒
    return "${hours}時${minutes}分";
  }

  killAllStatus() {
    // _visualCharts = {
    //   "first": [0],
    //   "second": [0]
    // };
    // _visualChartsSleep = {
    //   "first": [0],
    //   "second": [0]
    // };
    // _firstColor = [Colors.white];
    // _secondColor = [Colors.white];
    // _firstColorSleep = [Colors.white];
    // _secondColorSleep = [Colors.white];

    _noPersonCount = 0;
    _sittingCount = 0;
    _noDataCount = 0;
    _sleepCount = 0;
    _somePeopleCount = 0;
    _fallDownCount = 0;

    _noPersonTime = "0時0分";
    _sittingTime = "0時0分";
    _noDataTime = "0時0分";
    _sleepTime = "0時0分";
    _somePeopleTime = "0時0分";
    _fallDownTime = "0時0分";

    _allSleepTime = "0時0分";
    _allOnBedTime = "0時0分";
    _allOffBedTime = "0時0分";
    notifyListeners();
  }

  killBehavior() {
    _noPersonCount = 0;
    _sittingCount = 0;
    _noDataCount = 0;
    _sleepCount = 0;
    _somePeopleCount = 0;
    _fallDownCount = 0;

    _noPersonTime = "0時0分";
    _sittingTime = "0時0分";
    _noDataTime = "0時0分";
    _sleepTime = "0時0分";
    _somePeopleTime = "0時0分";
    _fallDownTime = "0時0分";
    notifyListeners();
  }

  setAllTime(Map data) {
    _allSleepTime = formatDuration(data["sleep"].toInt());
    _allOnBedTime = formatDuration(data["onBed"].toInt());
    _allOffBedTime = formatDuration(data["offBed"].toInt());
    // print("-------------------------------!");
    // print(_allSleepTime);
    // print(_allOnBedTime);
    // print(_allOffBedTime);
    // print("-------------------------------!");
    notifyListeners();
  }

  setCountAndTime(List data) {
    killBehavior();
    for (int i = 0; i < data.length; i++) {
      if (data[i]["label"] == "NO_PEOPLE") {
        _noPersonCount = data[i]["percentage"];
        _noPersonTime = formatDuration(data[i]["duration"].toInt());
        // print(_noPersonTime);
      } else if (data[i]["label"] == "SIT") {
        _sittingCount = data[i]["percentage"];
        _sittingTime = formatDuration(data[i]["duration"].toInt());
        // print(_sittingTime);
      } else if (data[i]["label"] == "NO_DATA") {
        _noDataCount = data[i]["percentage"];
        _noDataTime = formatDuration(data[i]["duration"].toInt());
        // print(_noDataTime);
      } else if (data[i]["label"] == "SLEEP") {
        _sleepCount = data[i]["percentage"];
        _sleepTime = formatDuration(data[i]["duration"].toInt());
        // print(_sittingTime);
      } else if (data[i]["label"] == "SOME_PEOPLE") {
        _somePeopleCount = data[i]["percentage"];
        _somePeopleTime = formatDuration(data[i]["duration"].toInt());
        // print(_somePeopleTime);
      } else if (data[i]["label"] == "FALL_DOWN") {
        _fallDownCount = data[i]["percentage"];
        _fallDownTime = formatDuration(data[i]["duration"].toInt());
        // print(_fallDownTime);
      }
    }
    notifyListeners();
  }

  // setCustomBarColorAndRatio() {

  // }

  setTempDevice(String device) {
    _tempDevice = device;
  }

  // setVisualCharts() {
  //   _visualCharts = [
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "SIT",
  //     "SIT",
  //     "SIT",
  //     "SIT",
  //     "坐",
  //     "坐",
  //     "坐",
  //     "坐",
  //     "坐",
  //     "坐",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //     "NO_PEOPLE",
  //   ];
  //   // notifyListeners();
  // }
  void setVisualCharts(List<dynamic> barData) {
    Map<String, List<num>> splitList(List<dynamic> input) {
      List<num> first = [];
      List<num> second = [];
      num sumFirst = 0;
      bool isFirstFull = false;

      for (num value in input) {
        if (!isFirstFull) {
          if (sumFirst + value > 50) {
            num excess = sumFirst + value - 50;
            first.add(value - excess);
            second.add(excess);
            isFirstFull = true;
          } else {
            first.add(value);
            sumFirst += value;
          }
        } else {
          second.add(value);
        }
      }

      return {'first': first, 'second': second};
    }

    List allPercentage = [];

    for (int i = 0; i < barData.length; i++) {
      allPercentage.add(barData[i]["percentage"]);
    }

    _visualCharts = splitList(allPercentage);

    _firstColor = [];
    _secondColor = [];
    for (int i = 0; i < _visualCharts["first"].length; i++) {
      String label = barData[i]["label"];
      if (label == "NO_PEOPLE") {
        _firstColor.add(Color(0xff96A5BD));
      } else if (label == "SIT") {
        _firstColor.add(Color(0xffFFD996));
      } else if (label == "SLEEP") {
        _firstColor.add(Color(0xff80CAFF));
      } else if (label == "SOME_PEOPLE") {
        _firstColor.add(Color(0xff85E0A3));
      } else if (label == "FALL_DOWN") {
        _firstColor.add(Color(0xffFFAFA3));
      } else {
        _firstColor.add(Color(0xffD9D9D9));
      }
    }
    for (int i = _visualCharts["second"].length - 1; i >= 0; i--) {
      String label =
          barData[(i + _visualCharts["first"].length.toInt() - 1).toInt()]
              ["label"];
      if (label == "NO_PEOPLE") {
        _secondColor.insert(0, Color(0xff96A5BD));
      } else if (label == "SIT") {
        _secondColor.insert(0, Color(0xffFFD996));
      } else if (label == "SLEEP") {
        _secondColor.insert(0, Color(0xff80CAFF));
      } else if (label == "SOME_PEOPLE") {
        _secondColor.insert(0, Color(0xff85E0A3));
      } else if (label == "FALL_DOWN") {
        _secondColor.insert(0, Color(0xffFFAFA3));
      } else {
        _secondColor.insert(0, Color(0xffD9D9D9));
      }
    }
    // print(_firstColor);
    // print(_secondColor);
    // print("-------------------------------!");
    // print(_visualCharts);

    notifyListeners(); // 如果在Flutter中使用，需要通知聽眾更新
  }

  void setVisualChartsSleep(List<dynamic> barData) {
    Map<String, List<num>> splitList(List<dynamic> input) {
      List<num> first = [];
      List<num> second = [];
      num sumFirst = 0;
      bool isFirstFull = false;

      for (num value in input) {
        if (!isFirstFull) {
          if (sumFirst + value > 50) {
            num excess = sumFirst + value - 50;
            first.add(value - excess);
            second.add(excess);
            isFirstFull = true;
          } else {
            first.add(value);
            sumFirst += value;
          }
        } else {
          second.add(value);
        }
      }

      return {'first': first, 'second': second};
    }

    List allPercentage = [];

    for (int i = 0; i < barData.length; i++) {
      allPercentage.add(barData[i]["percentage"]);
    }
    print("allPercentage");
    print(allPercentage);

    _visualChartsSleep = splitList(allPercentage);

    _firstColorSleep = [];
    _secondColorSleep = [];
    for (int i = 0; i < _visualChartsSleep["first"].length; i++) {
      String label = barData[i]["label"];
      if (label == "ON_BED") {
        _firstColorSleep.add(Color(0xff007Aff));
      } else if (label == "OFF_BED") {
        _firstColorSleep.add(Color(0xffFFAFA3));
      } else if (label == "SLEEP") {
        _firstColorSleep.add(Color(0xff80CAFF));
      } else {
        _firstColorSleep.add(Color(0xffD9D9D9));
      }
    }
    for (int i = _visualChartsSleep["second"].length - 1; i >= 0; i--) {
      String label =
          barData[(i + _visualChartsSleep["first"].length.toInt() - 1).toInt()]
              ["label"];
      if (label == "ON_BED") {
        _secondColorSleep.insert(0, Color(0xff007Aff));
      } else if (label == "OFF_BED") {
        _secondColorSleep.insert(0, Color(0xffFFAFA3));
      } else if (label == "SLEEP") {
        _secondColorSleep.insert(0, Color(0xff80CAFF));
      } else {
        _secondColorSleep.insert(0, Color(0xffD9D9D9));
      }
    }
    print(_firstColorSleep);
    print(_secondColorSleep);
    print("-------------------------------!!!!!!!!");
    print(_visualChartsSleep);

    notifyListeners(); // 如果在Flutter中使用，需要通知聽眾更新
  }

  // killStatus() {
  //   _visualCharts = {};
  //   // notifyListeners();
  // }
}
