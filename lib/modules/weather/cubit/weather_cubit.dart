import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/weather.dart';
import '../repository/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  final _repo = WeatherRepository();

  Future<void> getCurrentWeather(double lat, double lon) async {
    emit(GetWeatherLoading());
    final response = await _repo.getCurrentWeather(lat, lon);

    if (response.statusCode == 200) {
      emit(GetWeatherSuccess(response.data));
    } else {
      emit(GetWeatherFailed());
    }
  }
}
