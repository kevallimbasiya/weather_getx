import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_getx/app/data/keys.dart';
import 'package:weather_getx/app/data/models/weather_data_model.dart';
import 'package:weather_getx/app/data/urls.dart';

import '../../../routes/app_pages.dart';

enum State { initial, loading, success, error }

class HomeController extends GetxController {
  TextEditingController city = TextEditingController();

  final _data = Rx<Weather?>(null);
  Weather? get data => _data.value;
  set data(Weather? value) => _data.value = value;

  final _enum1 = Rx<State?>(State.initial);
  State? get enum1 => _enum1.value;
  set enum1(State? value) => _enum1.value = value;

  String? value;

  void getWeather() async {
    try {
      Get.dialog(const Center(
        child: CircularProgressIndicator(),
      ));
      var dio = Dio();
      dio.interceptors.add(
        LogInterceptor(
          error: true,
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
      );
      enum1 = State.initial;

      final response = await dio.get(URLs.urls, queryParameters: {
        "q": city.text,
        "units": "metric",
        "appid": Keys.keys,
      });
      // final weather = await dio.get(
      //   "https://api.openweathermap.org/data/2.5/weather?q=${city.text}&units=metric&appid=bab281d79e5f1e9755a68d754cc313e7",
      // );
      enum1 = State.loading;
      data = Weather.fromJson(response.data);
      city.clear();
      Get.back();
      Get.toNamed(Routes.WEATHER);
    } catch (e) {
      Get.back();
      var err = e as DioError;
      Get.rawSnackbar(title: "error", message: err.response?.data["message"]);
      city.clear();

      debugPrint(
        e.toString(),
      );
    }
  }
}
