import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';



// void checkTokenValidity(String token) {
//   // 1. 分割 JWT 並取得 payload
//   final base64UrlPayload = token.split('.')[1];

//   // 2. 使用 base64Url 來解碼 Base64 URL 編碼的 payload
//   final payload = json.decode(utf8.decode(base64Url.decode(base64UrlPayload)));

//   // 3. 取得 exp 欄位（UNIX 時間戳）
//   final exp = payload['exp'];

//   // 4. 將 UNIX 時間戳轉換為可讀的日期
//   final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);  // 乘以1000將秒轉換為毫秒
//   print('Token 過期時間為: $expDate');

//   // 5. 檢查 token 是否過期
//   final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;  // 當前時間的 UNIX 時間戳（秒）

//   if (exp < currentTime) {
//     print('Token 已經過期');
//   } else {
//     print('Token 還有效');
//   }
// }
import 'dart:convert';

//解碼jwttoken
void checkTokenValidity(String token) async {
  // await saveToken(token);
  // 1. 分割 JWT 並取得 payload
  String base64UrlPayload = token.split('.')[1];

  // 2. 確保 Base64 URL 編碼的長度是4的倍數
  switch (base64UrlPayload.length % 4) {
    case 1:
      base64UrlPayload += '===';  // 添加三個 '='
      break;
    case 2:
      base64UrlPayload += '==';  // 添加兩個 '='
      break;
    case 3:
      base64UrlPayload += '=';  // 添加一個 '='
      break;
  }

  // 3. 使用 base64Url 來解碼 Base64 URL 編碼的 payload
  final payload = json.decode(utf8.decode(base64Url.decode(base64UrlPayload)));

  // 4. 取得 exp 欄位（UNIX 時間戳）
  final exp = payload['exp'];

  // 5. 將 UNIX 時間戳轉換為可讀的日期
  final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);  // 乘以1000將秒轉換為毫秒
  print('Token 過期時間為: $expDate');

  // 6. 檢查 token 是否過期
  final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;  // 當前時間的 UNIX 時間戳（秒）

  if (exp < currentTime) {
    print('Token 已經過期');
  } else {
    print('Token 還有效');
  }
}

// 保存 Token 到 SharedPreferences
Future<void> saveToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwtToken', token);
  print('Token 已存储');
}

// 从 SharedPreferences 获取 Token
Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwtToken');
}

//自訂key value存到手機
Future<void> saveToLocal(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
  print('$key 已存储');
}

//根據key取得資料
Future<String> getFromLocal(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? '';
}
