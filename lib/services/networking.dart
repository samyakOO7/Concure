import 'package:covid19_tracker/model/covid19_dashboard.dart';
import 'package:covid19_tracker/model/serializers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Networking {
  Future<Covid19Dashboard> getDashboardData() async {
    Covid19Dashboard _dashboardResult;
    var url = 'https://doh.saal.ai/api/live';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      _dashboardResult =
          serializers.deserializeWith(Covid19Dashboard.serializer, data);
    } else {
      throw Exception('connection error');
    }

    return _dashboardResult;
  }
}
