import 'json_property_name.dart';

class UsageTxnModel {

  final String qrData;
  final int status;
  final int entryDateTime;
  final int exitDateTime;

  UsageTxnModel({
    required this.qrData,
    required this.status,
    required this.entryDateTime,
    required this.exitDateTime,
  });

  UsageTxnModel.fromJson(Map<String, dynamic> json)
      :qrData=json[kQRData],
        status=json[kStatus],
        entryDateTime=json[kEntryDateTime],
        exitDateTime=json[kExitDateTime];


  Map<String, dynamic> toJson() =>
      {
        kQRData: qrData,
        kStatus: status,
        kEntryDateTime: entryDateTime,
        kExitDateTime: exitDateTime,
      };
}