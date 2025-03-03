class FareModel {

  final int srcStnId;
  final int destStnId;
  final int ticketType;
  final int journeyType;
  final int groupSize;

  FareModel({
    required this.srcStnId,
    required this.destStnId,
    required this.ticketType,
    required this.journeyType,
    required this.groupSize,
  });

  FareModel.fromJson(Map<String, dynamic> json)
      :srcStnId=json["srcStnId"],
        destStnId=json["destStnId"],
        ticketType=json["ticketType"],
        journeyType=json["journeyType"],
        groupSize=json["groupSize"];


  Map<String, dynamic> toJson() =>
      {
        "srcStnId": srcStnId,
        "destStnId": destStnId,
        "ticketType": ticketType,
        "journeyType": journeyType,
        "groupSize": groupSize
      };
}