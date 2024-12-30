import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/user_models/user_login_response_model.dart';
import 'package:waloma/core/providers/message_providers.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    var isCachedKeyExist =
        await APICacheManager().isAPICacheKeyExist("login_details");
    // print(isCachedKeyExist);
    return isCachedKeyExist;
  }

  final MessageProvider? messageProvider;
  SharedService(this.messageProvider);

  static Future<UserLoginResponseModel?> loginDetails() async {
    var isCachedKeyExist =
        await APICacheManager().isAPICacheKeyExist("login_details");

    if (isCachedKeyExist) {
      var cacheData = await APICacheManager().getCacheData("login_details");
      print(cacheData);
      return loginResponseJson(cacheData.syncData);
    }
  }

  static Future<void> setLoginDetails(
      UserLoginResponseModel loginResponse) async {
    APICacheDBModel cacheModel = APICacheDBModel(
        key: "login_details", syncData: jsonEncode(loginResponse.toJson()));

    await APICacheManager().addCacheData(cacheModel);
  }

  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache("login_details");
    Navigator.pushNamedAndRemoveUntil(context, '/landing', (route) => false);
  }
}
