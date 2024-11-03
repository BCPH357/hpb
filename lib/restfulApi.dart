import 'dart:convert';
import 'package:http/http.dart' as http;
import 'jwtDecode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mult_provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String ip = 'http://20.78.56.130:3000/';
String apIp = "http://192.168.4.1";

String getFormattedTodayDate() {
  // 获取当前日期
  DateTime now = DateTime.now();
  // 创建一个 DateFormat 来指定日期格式
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  // 使用 formatter 来格式化当前日期
  return formatter.format(now);
}

String formatDate(String dateTimeStr) {
  DateTime dateTime = DateTime.parse(dateTimeStr);
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}

Future<String> getDeviceApiInfo(DeviceInfo deviceInfo) async {
  final response = await http.get(Uri.parse('${apIp}/Info/Device'));

  ///Settings?mode=station

  print("response${response.body}");
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    print("responseData!!!${responseData}");
    deviceInfo.setEzCaringData(responseData);
    return "success";
  } else {
    return "Failed to load data";
  }
}

Future<String> configureDevice(
    String ssid, String password, String deviceId) async {
  final url = Uri.parse('${apIp}/Settings/Device');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'ssid': ssid,
    'password': password,
    'deviceId': deviceId,
    'serverUrl': "https://20.78.56.130:443/api/v1/device/actions",
    'wsServerUrl': "wss://20.78.56.130:443/$deviceId",
    'ntpServer': "time.google.com",
    // 'otaVersionUrl': otaVersionUrl
  });
  print("__________body__________");
  print("body: $body");

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Success: ${response.body}');
      return "success";
    } else {
      print('Failed to configure device: ${response.body}');
      return "Failed to configure device";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> switchDeviceMode(
    String deviceId, String mode, DeviceInfo deviceInfo) async {
  // Construct the URL with the desired mode
  final url = Uri.parse('${apIp}/Settings?mode=$mode');
  final headers = {
    'Content-Type': 'application/json',
  };

  try {
    // Send the GET request
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      deviceInfo.setMacAddress(deviceInfo.ezCaringData["mac"]);
      print(
          'Success: ${responseData['state']} - Mode: ${responseData['mode']}');
      return "success";
    } else {
      final responseData = json.decode(response.body);
      print(
          'Error: ${responseData['state']} - Reason: ${responseData['reason']}');
      return "Failed to switch mode: ${responseData['reason']}";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> sendRegistrationEmail(String email) async {
  final url = Uri.parse('${ip}api/v1/auth/register/request-email');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'email': email});

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      final responseData = json.decode(response.body);
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return responseData['error'];
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> verifyRegistrationCode(String email, String verifyCode) async {
  final url = Uri.parse('${ip}api/v1/auth/register/verify');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'email': email, 'verifyCode': verifyCode});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> registerUser(
    String username, String password, String email, String verifyCode) async {
  final url = Uri.parse('${ip}api/v1/auth/register');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'username': username,
    'password': password,
    'email': email,
    'verifyCode': verifyCode
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Token: ${responseData['token']}');
      print('Expires in: ${responseData['expiresIn']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return '${responseData['error']}';
    } else if (response.statusCode == 409) {
      final responseData = json.decode(response.body);
      print('Conflict: ${responseData['error']}');
      return '${responseData['error']}';
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return '${responseData['error']}';
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return 'error';
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> sendPasswordResetEmail(String email) async {
  final url = Uri.parse('${ip}api/v1/auth/reset-password/request-email');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'email': email});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('User not found: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> verifyResetPasswordCode(String email, String verifyCode) async {
  final url = Uri.parse('${ip}api/v1/auth/reset-password/verify');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'email': email, 'verifyCode': verifyCode});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('User not found: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> resetPassword(
    String email, String verifyCode, String newPassword) async {
  final url = Uri.parse('${ip}api/v1/auth/reset-password');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode(
      {'email': email, 'verifyCode': verifyCode, 'newPassword': newPassword});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('User not found: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> loginUser(String email, String password) async {
  final url = Uri.parse('${ip}api/v1/auth/login');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'email': email, 'password': password});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Token: ${responseData['token']}');
      print('Expires in: ${responseData['expiresIn']}');
      checkTokenValidity(responseData['token']);
      await saveToken(responseData['token']);
      // print('Token: ${await getToken()}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('User not found: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> logout() async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might already be logged out";
  }

  final url = Uri.parse('${ip}api/v1/auth/logout');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      // 登出成功後，清除本地存儲的 token
      await saveToken('');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      // Token 無效或過期，也應該清除本地存儲的 token
      await saveToken('');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> getUserInfo(PeopleInfo peopleInfo) async {
  final url = Uri.parse('${ip}api/v1/user');
  String? token = await getToken(); // 假設 getToken() 是一個從本地存儲獲取 JWT token 的函數

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('User Info: ${responseData['user']}');
      peopleInfo.setSelfInfo(responseData['user']);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('User not found: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Internal Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> getCareRecipient(PeopleInfo peopleInfo) async {
  // 从本地存储获取JWT token
  String? token = await getToken(); // 假设getToken()是一个从本地存储获取JWT token的函数

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  // 构建请求的URL
  final url = Uri.parse('${ip}api/v1/users/care-recipient');
  // 设置请求头
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    // 发送HTTP GET请求
    final response = await http.get(url, headers: headers);

    // 根据响应状态码处理结果
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Care Recipient: ${responseData['careRecipient']}');
      peopleInfo.setDependentInfo(responseData['careRecipient']);
      peopleInfo
          .setMedicalHistory(responseData['careRecipient']['medicalHistory']);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Not Found: ${responseData['error']}');
      return "Not Found: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Internal Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> updateUser(
    {String name = '',
    String email = '',
    String countryCode = '',
    String phoneNumber = '',
    bool firstLogin = false}) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/user');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  // 創建請求體，只包含非空的字段
  final body = <String, dynamic>{};
  if (name.isNotEmpty) body['name'] = name;
  if (email.isNotEmpty) body['email'] = email;
  if (countryCode.isNotEmpty) body['countryCode'] = countryCode;
  if (phoneNumber.isNotEmpty) body['phoneNumber'] = phoneNumber;
  body['firstLogin'] = firstLogin;
  try {
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Updated User: ${responseData['user']}');
      saveToLocal('firstLogin', 'false');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      // Token 無效或過期，可能需要重新登錄
      await saveToken('');
      return responseData['error'];
    } else if (response.statusCode == 409) {
      final responseData = json.decode(response.body);
      print('Conflict: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> addEmergencyContact({
  required String name,
  required String countryCode,
  required String phoneNumber,
  required String email,
}) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/emergency-contacts');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  final body = json.encode({
    'name': name,
    'countryCode': countryCode,
    'phoneNumber': phoneNumber,
    'email': email
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Emergency Contact: ${responseData['emergencyContact']}');
      saveToLocal('contactId', responseData['emergencyContact']['contactId']);
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      // Token 無效或過期，可能需要重新登錄
      await saveToken('');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> updateCareRecipient({
  required String name,
  required Map<String, bool> medicalHistory,
  String notes = '',
}) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/care-recipient');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  final body = json
      .encode({'name': name, 'medicalHistory': medicalHistory, 'notes': notes});

  try {
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Care Recipient: ${responseData['careRecipient']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      // Token 無效或過期，可能需要重新登錄
      await saveToken('');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Care recipient not found: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> getAllUserDevices(DeviceInfo deviceInfo) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  print("token: $token");

  final url = Uri.parse('${ip}api/v1/users/devices');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}!');
      deviceInfo.killStatus();
      print(responseData['devices']);
      deviceInfo.setDeviceInfo(responseData['devices']);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return "success";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> addUserDevice(String macAddress, String deviceName) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/devices');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  final body =
      json.encode({'macAddress': macAddress, 'deviceName': deviceName});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("________add___device________");
      print("macAddress: $macAddress");
      print("response.body: ${response.body}");
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 409) {
      final responseData = json.decode(response.body);
      print('Conflict: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> updateDeviceName(
    String deviceId, String newDeviceName, DeviceInfo deviceInfo) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/devices/$deviceId');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  final body = json.encode({'deviceName': newDeviceName});

  try {
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      deviceInfo.updateDeviceName(deviceId, newDeviceName);
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> getDeviceSettings(
    String deviceId, DeviceInfo deviceInfo, int index) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  // 固定查詢參數
  List<String> statuses = ["light", "speaker", "boundary"];
  String queryParams = statuses.map((status) => 'status=$status').join('&');
  final url = Uri.parse('${ip}api/v1/devices/$deviceId/settings?$queryParams');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: Device settings retrieved${responseData['settings']}');
      deviceInfo.setVoiceLightBed(responseData['settings'], index);
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> setDeviceLight(String deviceId, int mode, levels) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/light');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  Map<String, dynamic> body = {"mode": mode};

  if (mode == 0 || mode == 2) {
    body['level'] = levels; // Default to 80 if no levels provided for mode 0
  }

  try {
    print(body);
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Light Status: ${responseData['lightStatus']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> setDeviceLightColor(String deviceId, int color) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/light/color');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  Map<String, dynamic> body = {"color": color};

  try {
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Light Status: ${responseData['lightStatus']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> setDeviceSpeakerVolume(String deviceId, int volumeValue) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/speaker/volume');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  Map<String, dynamic> body = {"volumeValue": volumeValue};

  try {
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Speaker Status: ${responseData['speakerStatus']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> setDeviceSpeakerLanguage(String deviceId, int mode) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/speaker/language');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  Map<String, dynamic> body = {"mode": mode};

  try {
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Speaker Status: ${responseData['speakerStatus']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> resetDevice(String deviceId) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/reset');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> restartDevice(String deviceId) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/restart');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> setDeviceSentryMode(String deviceId, int sentryMode) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/sentry');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  Map<String, dynamic> body = {"sentryMode": sentryMode};

  try {
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Sentry Mode: ${responseData['sentryMode']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> updateBoundarySetting(String deviceId, int status) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/boundary/status');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  Map<String, dynamic> body = {"status": status};

  try {
    final response =
        await http.patch(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> startBoundarySetting(String deviceId) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/boundary/start');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> stopBoundarySetting(String deviceId) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/boundary/stop');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> setBedEdgeBoundary(
    String deviceId, Map<String, dynamic> boundaryParameters) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/boundary');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  Map<String, dynamic> body = {"boundaryParameters": boundaryParameters};

  try {
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> getBoundaryImage(
    String deviceId, DeviceInfo deviceInfo, width, height) async {
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    throw Exception("No token found, user might not be logged in");
  }

  final url = Uri.parse('${ip}api/v1/devices/$deviceId/boundary/image');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      // 解碼base64編碼的jpeg圖片
      final bytes = base64Decode(responseData['image']);
      final image = Image.memory(bytes);
      deviceInfo.setBoundaryImage(image);
      return "success";
    } else if (response.statusCode == 401) {
      return "Unauthorized: ${json.decode(response.body)['error']}";
    } else if (response.statusCode == 404) {
      return "Device not found: ${json.decode(response.body)['error']}";
    } else if (response.statusCode == 500) {
      return "Server Error: ${json.decode(response.body)['error']}";
    } else {
      return "Unexpected error occurred: ${response.statusCode} ${response.body}";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Error fetching boundary image: $e";
  }
}

Future<String> getEmergencyWarningLogs(String date, Emergency emergency) async {
  final url = Uri.parse('${ip}api/v1/data/warning-logs/emergency?date=$date');
  String? token = await getToken(); // 假設 getToken() 是一個從本地存儲獲取 JWT token 的函數

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      emergency.setEmergencyWarningLogs(responseData['data']);

      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Not Found: ${responseData['error']}');
      return "success";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Internal Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> getEventWarningLogs(String date, Emergency emergency) async {
  final url = Uri.parse('${ip}api/v1/data/warning-logs/event?date=$date');
  String? token = await getToken(); // 假設 getToken() 是一個從本地存儲獲取 JWT token 的函數

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print(responseData['data']);
      emergency.setEventWarningLogs(responseData['data']);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Not Found: ${responseData['error']}');
      return "success";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Internal Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> getBehavioralData(
    String deviceId, String date, VisualCharts visualCharts) async {
  date = formatDate(date);
  print(date);
  print(deviceId);
  final url = Uri.parse(
      'http://20.78.56.130:3000/api/v1/data/behavior/$deviceId?date=$date');
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print('Success: ${response.body}');
      // var number = jsonDecode(response.body)["barData"];
      // print('The type of number is: ${number.runtimeType}');
      visualCharts.setVisualCharts(jsonDecode(response.body)["barData"]);
      visualCharts.setCountAndTime(jsonDecode(response.body)["pieData"]);

      return "success";
    } else if (response.statusCode == 400) {
      print('Error: Invalid input data');
      return "Invalid input data";
    } else if (response.statusCode == 401) {
      print('Error: Invalid or expired token');
      return "Invalid or expired token";
    } else if (response.statusCode == 404) {
      print('Error: No data found');
      return "No data found";
    } else if (response.statusCode == 500) {
      print('Error: Failed to perform behavior data analysis');
      return "Failed to perform behavior data analysis";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> getSleepData(
    String deviceId, String date, VisualCharts visualCharts) async {
  date = formatDate(date);
  print(date);
  print(deviceId);
  final url = Uri.parse('${ip}api/v1/data/sleep/$deviceId?date=$date');
  String? token = await getToken(); // 假设getToken()是一个从本地存储获取JWT token的函数

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      visualCharts.setAllTime(responseData['bedTime']);
      visualCharts.setVisualChartsSleep(responseData['barData']);
      return "success";
    } else if (response.statusCode == 400) {
      print("400");
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return "Invalid input data";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Invalid or expired token";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Not Found: ${responseData['error']}');
      return "No data found";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return "Failed to perform sleep data analysis";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> updateCareRecipient2({
  required String name,
  required Map medicalHistory,
  required int age,
  required String gender,
  required String bloodType,
  required String countryCode,
  required String phoneNumber,
  String notes = '',
}) async {
  // print("_____________________");
  // print(name);
  // print(medicalHistory);
  // print(age);
  // print(gender);
  // print(bloodType);
  // print(countryCode);
  // print(phoneNumber);
  // print(notes);
  // 從本地存儲獲取 token
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/care-recipient');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  final body = json.encode({
    'name': name,
    'medicalHistory': medicalHistory,
    'notes': notes,
    'age': age,
    'gender': gender,
    'bloodType': bloodType,
    'countryCode': countryCode,
    'phoneNumber': phoneNumber
  });

  try {
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Care Recipient: ${responseData['careRecipient']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      // Token 無效或過期，可能需要重新登錄
      await saveToken('');
      return responseData['error'];
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Care recipient not found: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> getEmergencyContacts(EmergencyContact emergencyContact) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/emergency-contacts');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Emergency Contacts: ${responseData['emergencyContacts']}');
      emergencyContact.setEmergencyContact(responseData['emergencyContacts']);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Internal Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> addEmergencyContact2({
  required String name,
  required String countryCode,
  required String phoneNumber,
  required String email,
  required EmergencyContact emergencyContact,
}) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/emergency-contacts');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  final body = json.encode({
    'name': name,
    'countryCode': countryCode,
    'phoneNumber': phoneNumber,
    'email': email
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Emergency Contact: ${responseData['emergencyContact']}');
      emergencyContact.addEmergencyContact(responseData['emergencyContact']);
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      print('Details: ${responseData['details']}');
      return responseData['error'];
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return responseData['error'];
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return responseData['error'];
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "error";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "error";
  }
}

Future<String> updateEmergencyContact({
  required String contactId,
  required String name,
  required String countryCode,
  required String phoneNumber,
  required String email,
}) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/emergency-contacts/$contactId');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  // Construct the body with only provided values
  Map<String, dynamic> body = {};
  if (name != '') body['name'] = name;
  if (countryCode != '') body['countryCode'] = countryCode;
  if (phoneNumber != '') body['phoneNumber'] = phoneNumber;
  if (email != '') body['email'] = email;

  try {
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Emergency Contact: ${responseData['emergencyContact']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 403) {
      final responseData = json.decode(response.body);
      print('Forbidden: ${responseData['error']}');
      return "Forbidden: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Emergency contact not found: ${responseData['error']}');
      return "Emergency contact not found: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return "Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> deleteEmergencyContact(String contactId) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/emergency-contacts/$contactId');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 403) {
      final responseData = json.decode(response.body);
      print('Forbidden: ${responseData['error']}');
      return "Forbidden: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Emergency contact not found: ${responseData['error']}');
      return "Emergency contact not found: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return "Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> getUserFollows(DeviceInfo deviceInfo) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/follows');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('User Follows: ${responseData['userFollows']}');
      deviceInfo.setFamilyData(responseData['userFollows']);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Internal Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> sendFamilyVerificationEmail(
    String email, DeviceInfo deviceInfo) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/follows/request-email');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  final body = json.encode({'email': email});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return "Invalid email: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return "Family not found: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> addFamilyMember(
    String email, String verifyCode, DeviceInfo deviceInfo) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/follows');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  final body = json.encode({'email': email, 'verifyCode': verifyCode});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('User Follow: ${responseData['userFollow']}');
      deviceInfo.addFamilyData(responseData['userFollow']);
      return "success";
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('Error: ${responseData['error']}');
      return "Invalid verification code: ${responseData['error']}";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> updateFamilyMember(
    String followId, String familyName, DeviceInfo deviceInfo) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/follows/$followId');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  // Create the request body with optional parameters
  final Map<String, dynamic> body = {};
  if (familyName != null) {
    body['familyName'] = familyName;
  }

  try {
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      deviceInfo.updateFamilyMember(followId, familyName);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 403) {
      final responseData = json.decode(response.body);
      print('Forbidden: ${responseData['error']}');
      return "Forbidden: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('User follow not found: ${responseData['error']}');
      return "User follow not found: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> deleteFamilyMember(
    String followId, DeviceInfo deviceInfo) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/follows/$followId');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      deviceInfo.deleteFamilyMember(followId);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 403) {
      final responseData = json.decode(response.body);
      print('Forbidden: ${responseData['error']}');
      return "Forbidden: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      print('User follow not found: ${responseData['error']}');
      return "User follow not found: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}

Future<String> getFamilyMemberDevices(
    String followId, DeviceInfo deviceInfo) async {
  // Retrieve the token from local storage
  String? token = await getToken();

  if (token == null) {
    return "No token found, user might not be logged in";
  }

  final url = Uri.parse('${ip}api/v1/users/follows/$followId/devices');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Success: ${responseData['message']}');
      print('Devices: ${responseData['devices']}');
      deviceInfo.setFamilyDevice(responseData['devices']);
      return "success";
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      print('Unauthorized: ${responseData['error']}');
      return "Unauthorized: ${responseData['error']}";
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      print('Server Error: ${responseData['error']}');
      return "Internal Server Error: ${responseData['error']}";
    } else if (response.statusCode == 404) {
      // return "This household has no devices.";
      return "success";
    } else {
      print(
          'Unexpected error occurred: ${response.statusCode} ${response.body}');
      return "Unexpected error occurred";
    }
  } catch (e) {
    print('Exception caught: $e');
    return "Exception caught: $e";
  }
}
