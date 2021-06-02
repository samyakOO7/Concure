// To parse this JSON data, do
//
//     final distictsList = distictsListFromJson(jsonString);

import 'dart:convert';

DistictsList distictsListFromJson(String str) => DistictsList.fromJson(json.decode(str));

String distictsListToJson(DistictsList data) => json.encode(data.toJson());

class DistictsList {
  DistictsList({
    this.districts,
    this.ttl,
  });

  List<District> districts;
  int ttl;

  factory DistictsList.fromJson(Map<String, dynamic> json) => DistictsList(
    districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
    ttl: json["ttl"],
  );

  Map<String, dynamic> toJson() => {
    "districts": List<dynamic>.from(districts.map((x) => x.toJson())),
    "ttl": ttl,
  };
}

class District {
  District({
    this.stateId,
    this.districtId,
    this.districtName,
    this.districtNameL,
  });

  int stateId;
  int districtId;
  String districtName;
  String districtNameL;

  factory District.fromJson(Map<String, dynamic> json) => District(
    stateId: json["state_id"],
    districtId: json["district_id"],
    districtName: json["district_name"],
    districtNameL: json["district_name_l"],
  );

  Map<String, dynamic> toJson() => {
    "state_id": stateId,
    "district_id": districtId,
    "district_name": districtName,
    "district_name_l": districtNameL,
  };
}
