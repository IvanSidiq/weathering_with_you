part of 'city_cubit.dart';

@immutable
abstract class CityState {}

class CityInitial extends CityState {}

class GetCitySuccess extends CityState {
  final List<City> cityData;
  GetCitySuccess(this.cityData);
}

class GetCityFailed extends CityState {}

class GetCityLoading extends CityState {}
