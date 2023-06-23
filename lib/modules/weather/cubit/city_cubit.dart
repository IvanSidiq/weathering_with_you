import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../models/city.dart';
import '../repository/city_repository.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityInitial());

  final _repo = CityRepository();

  Timer? _debounce;

  void onSearchChanged(String searchText) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getCities(searchText);
    });
  }

  Future<void> getCities(String cityName) async {
    emit(GetCityLoading());
    final response = await _repo.getCityByName(cityName);

    if (response.statusCode == 200) {
      emit(GetCitySuccess(response.data));
    } else {
      emit(GetCityFailed());
    }
  }
}
