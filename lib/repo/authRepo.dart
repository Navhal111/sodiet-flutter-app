import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../constant/appConstant.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> postDataSet(
      {required Map<String, dynamic> sendData, required String apiName}) async {
    var DEVICEINFO = await ApiClient.DeviceInfo();
    Map<String, String> headerExtra = {
      'Content-Type': 'application/json',
      "X-VERSION": Platform.isAndroid
          ? AppConstants.ANDROID_VERSION
          : AppConstants.IOS_VERSION,
      "X-DEVICE-INFO": jsonEncode(DEVICEINFO),
      "X-APPLICATION-ID": DEVICEINFO["X-APPLICATION-ID"]
    };
    return await apiClient.postData(apiName, sendData, headers: headerExtra);
  }

  Future<Response> getDataSet({required String apiName}) async {
    var DEVICEINFO = await ApiClient.DeviceInfo();
    Map<String, String> headerExtra = {
      'Content-Type': 'application/json',
      "X-VERSION": Platform.isAndroid
          ? AppConstants.ANDROID_VERSION
          : AppConstants.IOS_VERSION,
      "X-DEVICE-INFO": jsonEncode(DEVICEINFO),
      "X-APPLICATION-ID": DEVICEINFO["X-APPLICATION-ID"]
    };
    return await apiClient.getData(apiName, headers: headerExtra);
  }

  Future<Response> deleteDataSet({required String apiName}) async {
    var DEVICEINFO = await ApiClient.DeviceInfo();
    Map<String, String> headerExtra = {
      'Content-Type': 'application/json',
      "X-VERSION": Platform.isAndroid
          ? AppConstants.ANDROID_VERSION
          : AppConstants.IOS_VERSION,
      "X-DEVICE-INFO": jsonEncode(DEVICEINFO),
      "X-APPLICATION-ID": DEVICEINFO["X-APPLICATION-ID"]
    };
    return await apiClient.deleteData(apiName, headers: headerExtra);
  }
}
