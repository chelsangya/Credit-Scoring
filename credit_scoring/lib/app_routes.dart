import 'package:credit_scoring/input_view.dart';
import 'package:credit_scoring/select_view.dart';
import 'package:credit_scoring/upload_view.dart';

class AppRoute {
  AppRoute._();
  static const String homeRoute = '/';
  static const String inputRoute = '/input';
  static const String inputResultRoute = '/inputResult';
  static const String uploadRoute = '/upload';
  static const String test= '/test';
  static getApplicationRoute() {
    return {
      homeRoute: (context) => const SelectView(),
      inputRoute: (context) => const InputView(),
      uploadRoute: (context) => const UploadView(),
   

      // inputResultRoute: (context) => const CreditView(),
    };
  }
}
