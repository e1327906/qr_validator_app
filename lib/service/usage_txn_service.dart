import 'dart:developer';

import 'package:qr_validator_app/models/usage_txn_model.dart';

import '../models/json_property_name.dart';
import '../models/response_model.dart';
import 'base_api_service.dart';

class UsageTxnService {

  Future<bool> validateTxn(UsageTxnModel req) async {
    try {
      BaseAPIService.baseUrl = BaseAPIService.qrsUrl;
      ResponseModel responseModel = await BaseAPIService.post(req.toJson(), kValidate);

      if (responseModel.responseCode == "200") {
        return true;
      } else {
        log('Transaction failed');
        throw Exception('Transaction failed');
      }
    } catch (e) {
      // Log the exception
      log('Exception during transaction process: $e');
    }
    return false;
  }
}