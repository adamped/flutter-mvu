import 'package:http/http.dart' as http;
import 'dart:convert';

typedef Future<http.Response> GetHttp(dynamic url, {Map<String, String> headers});
GetHttp get getHttp => http.get;

typedef dynamic JsonDecode(String source);
JsonDecode get jsonDecode => json.decode; 

const String url = "https://api.darksky.net/forecast/<insert-api-key>/37.8267,-122.4233";

Future<double> _getForecast(GetHttp getHttp, JsonDecode jsonDecode,
    String url) async {

  var response = await getHttp(url);

  var decode = jsonDecode(response.body);

  return decode["currently"]["temperature"];
}

Future<double> getForecast() => _getForecast(getHttp, jsonDecode, url);