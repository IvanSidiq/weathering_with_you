part of 'weather_cubit.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class GetWeatherSuccess extends WeatherState {
  final WeatherData weatherData;
  GetWeatherSuccess(this.weatherData);
}

class GetWeatherFailed extends WeatherState {}

class GetWeatherLoading extends WeatherState {}
