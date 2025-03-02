// ticket_model.dart

import 'dart:convert';
import '../models/transaction_data_model.dart';

class TicketModel {
  final int ticketType;
  final int journeyType;
  final String serialNumber;
  final int issuerId;
  final int groupSize;
  final String phoneNo;
  final String email;
  final int effectiveDateTime;
  final int operatorId;
  final int validityDomain;
  final int validityPeriod;
  final TransactionData transactionData;
  final int status;

  TicketModel({
    required this.ticketType,
    required this.journeyType,
    required this.serialNumber,
    required this.issuerId,
    required this.groupSize,
    required this.phoneNo,
    required this.email,
    required this.effectiveDateTime,
    required this.operatorId,
    required this.validityDomain,
    required this.validityPeriod,
    required this.transactionData,
    required this.status
  });

  // Convert DateTime to a more usable form
  DateTime get effectiveDate =>
      DateTime.fromMillisecondsSinceEpoch(effectiveDateTime);

  // Factory constructor to create an instance from JSON
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      ticketType: json['ticketType'],
      journeyType: json['journeyType'],
      serialNumber: json['serialNumber'],
      issuerId: json['issuerId'],
      groupSize: json['groupSize'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      effectiveDateTime: json['effectiveDateTime'],
      operatorId: json['operatorId'],
      validityDomain: json['validityDomain'],
      validityPeriod: json['validityPeriod'],
      transactionData: TransactionData.fromJson(json['transactionData']),
      status: json['status']
    );
  }

  // Method to convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'ticketType': ticketType,
      'journeyType': journeyType,
      'serialNumber': serialNumber,
      'issuerId': issuerId,
      'groupSize': groupSize,
      'phoneNo': phoneNo,
      'email': email,
      'effectiveDateTime': effectiveDateTime,
      'operatorId': operatorId,
      'validityDomain': validityDomain,
      'validityPeriod': validityPeriod,
      'transactionData': transactionData.toJson(),
      'status' : status
    };
  }

  // Parse a JSON string to create a TicketModel instance
  static TicketModel fromRawJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return TicketModel.fromJson(json);
  }

  // Convert the model to a JSON string
  String toRawJson() => jsonEncode(toJson());

  // Create a copy of this model with optional updated fields
  TicketModel copyWith({
    int? ticketType,
    int? journeyType,
    String? serialNumber,
    int? issuerId,
    int? groupSize,
    String? phoneNo,
    String? email,
    int? effectiveDateTime,
    int? operatorId,
    int? validityDomain,
    int? validityPeriod,
    TransactionData? transactionData,
    int? status
  }) {
    return TicketModel(
      ticketType: ticketType ?? this.ticketType,
      journeyType: journeyType ?? this.journeyType,
      serialNumber: serialNumber ?? this.serialNumber,
      issuerId: issuerId ?? this.issuerId,
      groupSize: groupSize ?? this.groupSize,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      effectiveDateTime: effectiveDateTime ?? this.effectiveDateTime,
      operatorId: operatorId ?? this.operatorId,
      validityDomain: validityDomain ?? this.validityDomain,
      validityPeriod: validityPeriod ?? this.validityPeriod,
      transactionData: transactionData ?? this.transactionData,
        status: status ?? this.status
    );
  }
}