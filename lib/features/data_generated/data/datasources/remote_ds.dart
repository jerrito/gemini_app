import "dart:typed_data";

import 'package:gemini/features/data_generated/data/models/data_model.dart';
import "dart:async";
import "dart:convert";
import "package:gemini/core/error/error_model.dart";
import "package:gemini/core/urls/urls.dart";
import 'package:http/http.dart' as http;

abstract class DataGeneratedRemoteDatasource {
  //add  searched text to database
  Future<DataModel> addDataGenerated(Map<String, dynamic> params);

  // list all data generated
  Future<List<DataModel>> listDataGenerated(Map<String, dynamic> params);

  // delete data generated
  Future<bool> deleteDataGenerated(Map<String, dynamic> params);

  //  delete multiple data generated
  Future<bool> deleteMultipleDataGenerated(Map<String, dynamic> params);

  Future<DataModel> getDataGeneratedById(Map<String, dynamic> params);
}

class DataGeneratedRemoteDatasourceImpl
    implements DataGeneratedRemoteDatasource {
  final http.Client client;

  DataGeneratedRemoteDatasourceImpl({required this.client});

  @override
  Future<DataModel> addDataGenerated(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });

    final Map<String, dynamic> body = {
      "data": params["data"],
      "title": params["title"],
      "dataImage": params["hasImage"] ? params["dataImage"] as Uint8List : null,
      "hasImage": params["hasImage"]
    };
    final response = await client.post(
      getUri(endpoint: Url.addDataUrl.endpoint),
      headers: headers,
      body: jsonEncode(
        body,
      ),
    );
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return DataModel.fromJson(decodedResponse);
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap());
    }
  }

  @override
  Future<List<DataModel>> listDataGenerated(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });
    final response = await client.get(
      getUri(endpoint: Url.listDataUrl.endpoint),
      headers: headers,
    );

    final decodedResponse = jsonDecode(response.body);
   
    if (response.statusCode == 200) {
      return List<DataModel>.from(
          decodedResponse.map((e) => DataModel.fromJson(e)));
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap());
    }
  }

  @override
  Future<bool> deleteDataGenerated(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });

    int path = params["path"];
    final response = await client.delete(
      getUri(path: path.toString(), endpoint: Url.deleteDataUrl.endpoint),
      headers: headers,
    );
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (decodedResponse["success"]);
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap());
    }
  }

  @override
  Future<DataModel> getDataGeneratedById(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });
    String path = params["path"];
    final response = await client.get(
      getUri(path: path, endpoint: Url.listDataUrl.endpoint),
      headers: headers,
    );
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return DataModel.fromJson(decodedResponse);
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap());
    }
  }

  @override
  Future<bool> deleteMultipleDataGenerated(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });
    Map<String, dynamic> body = {"list": params["list"]};
    final response = await client.delete(
        getUri(endpoint: Url.deleteMultipleDataUrl.endpoint),
        headers: headers,
        body: jsonEncode(body));
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedResponse["success"];
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap()["error"]);
    }
  }
}
