import 'dart:convert';
import 'network.dart';

Future<String> getCountryName() async{
  Network n = Network("http://ip-api.com/json");
  var locationSTR = (await n.getData());
  var locationx = jsonDecode(locationSTR);
  return locationx["country"];
}