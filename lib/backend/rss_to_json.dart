import 'dart:convert';

import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

 Future<List> rssToJson(String category, {String baseUrl = 'https://www.hindustantimes.com/rss/'}) async {
  var client = http.Client();
  final myTransformer = Xml2Json();
  return await client.get(baseUrl + category + '/rssfeed.xml').then((response) {
    return response.body;
  }).then((bodyString) {
    myTransformer.parse(bodyString);
    var json = myTransformer.toGData();//converted to string
    return jsonDecode(json)['rss']['channel']['item'];//decode string into json
  });
}
