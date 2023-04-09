import 'dart:io';
import 'package:creative_task/models/repository_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomProvider extends ChangeNotifier {
  List<Repository> repositories = [];
  List<Repository> filterdRepositories = [];

  bool isloading = true;
  int num = 10;
  bool saved = false;

  String fileName = "userdata.json";

  CustomProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    http.Response response;
    try {
      var dir = await getTemporaryDirectory();
      File file = File("${dir.path}/$fileName");
      saved = pref.getBool('saved') ?? false;

      if (file.existsSync() && saved) {
        print("Loading from cache");
        var jsonData = file.readAsStringSync();
        repositories = repositoryFromJson(jsonData);

        notifyListeners();
      } else {
        print("Loading from API");
        if (num > 130) {
          saved = true;
          pref.setBool('saved', saved);
        }
        response = await http.get(
            Uri.tryParse(
                'https://api.github.com/users/square/repos?per_page=$num')!,
            headers: {
              "Authorization":
                  "Bearer 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",
            });
        if (response.statusCode == 200) {
          //var result = jsonDecode(response.body);
          file.writeAsStringSync(response.body,
              flush: true, mode: FileMode.write);
          repositories = repositoryFromJson(response.body);
          notifyListeners();
        }
      }

      isloading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isloading = false;
      notifyListeners();
    }
  }

  Future<void> searchData(String value) async {
    filterdRepositories = [];
    isloading = true;
    http.Response response;
    try {
      response = await http.get(
          Uri.tryParse('https://api.github.com/users/square/repos')!,
          headers: {
            "Authorization": "Bearer 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",
          });
      if (response.statusCode == 200) {
        repositories = repositoryFromJson(response.body);

        for (Repository rep in repositories) {
          if (rep.name.toLowerCase().contains(value)) {
            filterdRepositories.add(rep);
          }
        }
        notifyListeners();
      }

      isloading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isloading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    saved = false;
    pref.setBool('saved', saved);
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    await file.delete();
    num = 10;
    notifyListeners();
  }
}
