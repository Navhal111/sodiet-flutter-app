import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as Http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sodiet/constant/appConstant.dart';

import '../helper/errorResponse.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String? token;
  String? reToken;
  Map<String, String>? _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.TOKEN);

    if (token != null && reToken != null) {
      updateHeader(
        token,
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
      );
    } else {
      updateHeader(
        "",
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
      );
    }
  }

  void updateHeader(String? token, String? languageCode) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": 'Bearer ' + token!,
    };
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      if (token != null) {
        updateHeader(
          token,
          sharedPreferences.getString("in"),
        );
      }
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response _response = await Http.get(
        Uri.parse(uri),
        headers: headers != null ? headers : _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      debugPrint("$e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } catch (e) {}
    Response _response = Response(
      body: _body != null ? _body : response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
      if (_response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _errorResponse.errors[0].message);
      } else if (_response.body.toString().startsWith('{message')) {
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _response.body['message']);
      }
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint(
        '====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      // debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Call: $appBaseUrl');
      debugPrint('====> API Call: $uri\nHeader: $headers');
      debugPrint('====> API Body: $body');

      debugPrint(uri);

      Http.Response _response = await Http.post(
        Uri.parse(uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.put(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response _response = await Http.delete(
        Uri.parse(appBaseUrl + uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteDataBody(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response _response = await Http.delete(Uri.parse(appBaseUrl + uri),
              headers: headers ?? _mainHeaders, body: body)
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Map<String, dynamic>> DeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final networkinfo = await NetworkInfo();

    Map<String, dynamic> deviceInfo1 = {"APP_NAME": "Remit Hubs"};

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    deviceInfo1['BUNDLE_ID'] = packageInfo.packageName;
    deviceInfo1['APP_NAME'] = packageInfo.appName;
    deviceInfo1['X-APPLICATION-ID'] = packageInfo.version;
    deviceInfo1['BUILD_ID'] = packageInfo.version;
    deviceInfo1['BUILD_NUMBER'] = packageInfo.buildNumber;

    // deviceInfo1['BATTERY_LEVEL'] = await battery.batteryLevel;
    // deviceInfo1['BATTERY_CHARGING'] = false;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceInfo1['BRAND'] = androidInfo.brand;
      deviceInfo1['DEVICE_ID'] = androidInfo.id;
      deviceInfo1['DEVICE_TYPE'] = androidInfo.type;
      deviceInfo1['DEVICE_NAME'] = androidInfo.device;
      deviceInfo1['MANUFACTURER'] = androidInfo.manufacturer;
      deviceInfo1['MODEL'] = androidInfo.model;
      deviceInfo1['SUPPORTED_ABIS'] = androidInfo.supportedAbis;
    } else {
      IosDeviceInfo androidInfo = await deviceInfo.iosInfo;
      deviceInfo1['BRAND'] = "IOS";
      deviceInfo1['DEVICE_ID'] = androidInfo.identifierForVendor;
      deviceInfo1['DEVICE_TYPE'] = androidInfo.localizedModel;
      deviceInfo1['DEVICE_NAME'] = androidInfo.name;
      deviceInfo1['MANUFACTURER'] = "Apple";
      deviceInfo1['MODEL'] = androidInfo.model;
    }

    deviceInfo1['IP_ADDRESS'] = await networkinfo.getWifiIP();

    return deviceInfo1;
  }
}
