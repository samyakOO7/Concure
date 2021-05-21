library countries;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:covid19_tracker/model/serializers.dart';

part 'countries.g.dart';

abstract class Countries implements Built<Countries, CountriesBuilder> {
  Countries._();

  factory Countries([updates(CountriesBuilder b)]) = _$Countries;

  @BuiltValueField(wireName: 'country')
  String get country;
  @BuiltValueField(wireName: 'countryCode')
  String get countryCode;
  @BuiltValueField(wireName: 'latitude')
  double get latitude;
  @BuiltValueField(wireName: 'longitude')
  double get longitude;
  @BuiltValueField(wireName: 'confirmed')
  int get confirmed;
  @BuiltValueField(wireName: 'deaths')
  int get deaths;
  @BuiltValueField(wireName: 'recovered')
  int get recovered;
  @BuiltValueField(wireName: 'active')
  int get active;
  @BuiltValueField(wireName: 'updatedAt')
  String get updatedAt;
  @BuiltValueField(wireName: 'deltaConfirmed')
  int get deltaConfirmed;
  @BuiltValueField(wireName: 'deltaDeaths')
  int get deltaDeaths;
  @BuiltValueField(wireName: 'deltaRecovered')
  int get deltaRecovered;
  @BuiltValueField(wireName: 'deltaActive')
  int get deltaActive;
  String toJson() {
    return json.encode(serializers.serializeWith(Countries.serializer, this));
  }

  static Countries fromJson(String jsonString) {
    return serializers.deserializeWith(
        Countries.serializer, json.decode(jsonString));
  }

  static Serializer<Countries> get serializer => _$countriesSerializer;
}
