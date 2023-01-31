import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_getx/app/data/keys.dart';
import 'package:weather_getx/app/data/models/location_weather.dart';
import 'package:weather_getx/app/data/urls.dart';

import '../../../routes/app_pages.dart';

enum State { initial, loading, success, error }

class HomeController extends GetxController {
  TextEditingController city = TextEditingController();

  final _data = Rx<Location?>(null);
  Location? get data => _data.value;
  set data(Location? value) => _data.value = value;

  final _enum1 = Rx<State?>(State.initial);
  State? get enum1 => _enum1.value;
  set enum1(State? value) => _enum1.value = value;

  String? value;

  final dio = Dio();

//   void getWeather() async {
//     try {
//       Get.dialog(const Center(
//         child: CircularProgressIndicator(),
//       ));
  // var dio = Dio();
//       dio.interceptors.add(
//         LogInterceptor(
//           error: true,
//           request: true,
//           requestBody: true,
//           requestHeader: true,
//           responseBody: true,
//           responseHeader: true,
//         ),
//       );
//       enum1 = State.initial;

//       final response = await dio.get(URLs.urls, queryParameters: {
//         "q": city.text,
//         "units": "metric",
//         "appid": Keys.keys,
//       });
//       // final weather = await dio.get(
//       //   "https://api.openweathermap.org/data/2.5/weather?q=${city.text}&units=metric&appid=bab281d79e5f1e9755a68d754cc313e7",
//       // );
//       enum1 = State.loading;
//       data = Weather.fromJson(response.data);
//       city.clear();
//       Get.back();
//       Get.toNamed(Routes.WEATHER);
//     } catch (e) {
//       Get.back();
//       var err = e as DioError;
//       Get.rawSnackbar(title: "error", message: err.response?.data["message"]);
//       city.clear();

//       debugPrint(
//         e.toString(),
//       );
//     }
//   }

  @override
  void onInit() {
    setUpDio();
    super.onInit();
  }

  void setUpDio() {
    try {
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getWeatherDataByLatLong() async {
    try {
      enum1 = State.loading;
      final position = await _determinePosition();
      final response = await Dio().get(
        URLs.urls,
        queryParameters: {
          "lat": position.latitude,
          "lon": position.longitude,
          "units": "metric",
          "appid": Keys.keys,
        },
      );
      data = Location.fromJson(response.data);
      city.clear();
      enum1 = State.success;
      Get.toNamed(Routes.WEATHER);
    } on DioError catch (err) {
      city.clear();
      Get.rawSnackbar(title: "Error", message: err.response?.data["message"]);
      enum1 = State.error;
    } on MissingPluginException catch (e) {
      Get.rawSnackbar(title: "Error", message: e.message);
      enum1 = State.error;
    } catch (e) {
      city.clear();
      Get.rawSnackbar(title: "Error", message: e.toString());
      enum1 = State.error;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
