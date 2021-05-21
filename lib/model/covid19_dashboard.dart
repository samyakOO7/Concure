library covid19_dashboard;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:covid19_tracker/model/serializers.dart';

import 'countries.dart';

part 'covid19_dashboard.g.dart';

abstract class Covid19Dashboard
    implements Built<Covid19Dashboard, Covid19DashboardBuilder> {
  Covid19Dashboard._();

  factory Covid19Dashboard([updates(Covid19DashboardBuilder b)]) =
      _$Covid19Dashboard;

  @BuiltValueField(wireName: 'date')
  String get date;
  @BuiltValueField(wireName: 'countries')
  BuiltList<Countries> get countries;
  @BuiltValueField(wireName: 'confirmed')
  int get confirmed;
  @BuiltValueField(wireName: 'deaths')
  int get deaths;
  @BuiltValueField(wireName: 'recovered')
  int get recovered;
  @BuiltValueField(wireName: 'active')
  int get active;
  @BuiltValueField(wireName: 'deltaConfirmed')
  int get deltaConfirmed;
  @BuiltValueField(wireName: 'deltaDeaths')
  int get deltaDeaths;
  @BuiltValueField(wireName: 'deltaRecovered')
  int get deltaRecovered;
  @BuiltValueField(wireName: 'deltaActive')
  int get deltaActive;
  String toJson() {
    return json
        .encode(serializers.serializeWith(Covid19Dashboard.serializer, this));
  }

  static Covid19Dashboard fromJson(String jsonString) {
    return serializers.deserializeWith(
        Covid19Dashboard.serializer, json.decode(jsonString));
  }

  static Serializer<Covid19Dashboard> get serializer =>
      _$covid19DashboardSerializer;
}
