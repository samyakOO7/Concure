// To parse this JSON data, do
//
//     final stateList = stateListFromJson(jsonString);

import 'dart:convert';

StateList stateListFromJson(String str) => StateList.fromJson(json.decode(str));

String stateListToJson(StateList data) => json.encode(data.toJson());

class StateList {
  StateList({
    this.states,
    this.ttl,
  });

  List<State> states;
  int ttl;

  factory StateList.fromJson(Map<String, dynamic> json) => StateList(
    states: List<State>.from(json["states"].map((x) => State.fromJson(x))),
    ttl: json["ttl"],
  );

  Map<String, dynamic> toJson() => {
    "states": List<dynamic>.from(states.map((x) => x.toJson())),
    "ttl": ttl,
  };
}

class State {
  State({
    this.stateId,
    this.stateName,
    this.stateNameL,
  });

  int stateId;
  String stateName;
  String stateNameL;

  factory State.fromJson(Map<String, dynamic> json) => State(
    stateId: json["state_id"],
    stateName: json["state_name"],
    stateNameL: json["state_name_l"],
  );

  Map<String, dynamic> toJson() => {
    "state_id": stateId,
    "state_name": stateName,
    "state_name_l": stateNameL,
  };
}
