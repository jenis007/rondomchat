import 'package:get_storage/get_storage.dart';

class PreferenceManager {
  static var storage = GetStorage();

  static String username = "username";
  static String age = "age";

  static Future setUserName(String value) async {
    await storage.write(username, value);
  }

  static getUserName() {
    return storage.read(username);
  }

  static Future setAge(String value) async {
    await storage.write(age, value);
  }

  static getAge() {
    return storage.read(age);
  }
}
