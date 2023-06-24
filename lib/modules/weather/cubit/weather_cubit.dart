import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:weathering_with_you/utils/customs/custom_toast.dart';

import '../models/weather.dart';
import '../repository/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());
  String cityName = '';
  String date = '';
  String time = '';
  bool isNight = false;
  bool isLocationOn = false;
  int weatherCode = 800;
  final String localStorageKey = 'weathering_ww_key';

  final _repo = WeatherRepository();

  Future<void> getCurrentWeather(double lat, double lon) async {
    emit(GetWeatherLoading());
    final response = await _repo.getCurrentWeather(lat, lon);

    if (response.statusCode == 200) {
      GetIt.I<FlutterSecureStorage>()
          .write(key: localStorageKey, value: json.encode(response.data));
      emit(GetWeatherSuccess(response.data));
    } else {
      getWeatherFromLocalStorage();
    }
  }

  Future<void> getWeatherFromLocalStorage() async {
    final fromLocal =
        await GetIt.I<FlutterSecureStorage>().read(key: localStorageKey);
    if (fromLocal != null) {
      Map<String, dynamic> map = json.decode(fromLocal);
      final lastWeatherData = WeatherData.fromJson(map);
      emit(GetWeatherSuccess(lastWeatherData));
    } else {
      emit(GetWeatherFailed());
    }
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    emit(GetWeatherLoading());

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //simply go to london if location service disabled
      getCurrentWeather(51.5073219, -0.1276474);
      isLocationOn = false;
      CustomToast.showToastError('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLocationOn = false;
        CustomToast.showToastError('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isLocationOn = false;
      CustomToast.showToastError(
          'Location permissions are permanently denied, we can not look for your location.');
    }

    final Position pos = await Geolocator.getCurrentPosition();
    isLocationOn = true;
    getCurrentWeather(pos.latitude, pos.longitude);
  }
}
