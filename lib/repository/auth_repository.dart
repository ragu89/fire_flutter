import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:fire_flutter/model/local_auth_credential.dart';

class AuthRepository {
  Future<void> saveLocalAuthCredentials(
      LocalAuthCredential authCredential) async {
    print("saveLocalAuthCredentials");
    var json = authCredential.toJson();
    final file = await _authCredentialFile;
    file.writeAsString(json.toString());
  }

  Future<LocalAuthCredential> getLocalAuthCredential() async {
    print("getLocalAuthCredential");
    try {
      final file = await _authCredentialFile;
      String json = await file.readAsString();
      var dynamicObject = jsonDecode(json);
      var localAuthCredential = LocalAuthCredential.fromJson(dynamicObject);
      print("local auth credential retrieved: $localAuthCredential");
      return localAuthCredential;
    } catch (e) {
      print("error when trying to retrieve the local auth credential: $e");
      return null;
    }
  }

  Future<File> get _authCredentialFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/authCredential.json');
  }
}
