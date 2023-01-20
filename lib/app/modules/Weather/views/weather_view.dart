import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/weather_controller.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherView'),
        centerTitle: true,
      ),
      body: Obx(
        () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CITY : ${controller.homeController.data?.name}",
              ),
              Text("TEMPRATURE : ${controller.homeController.data?.main?.temp}")
            ],
          ),
        ),
      ),
    );
  }
}
