import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weathering_with_you/modules/weather/models/weather.dart';
import 'package:weathering_with_you/utils/api.dart';

import '../../../config/base_repository.dart';
import '../../../models/base_response.dart';

class WeatherRepository extends BaseRepository {
  Future<BaseResponse> getCurrentWeather(double lat, double lon) async {
    final response = await fetch(kApiWeather, queryParameters: {
      'lat': lat,
      'lon': lon,
      'appid': dotenv.env['OPEN_WEATHER_API']
    });

    if (response.statusCode == 200) {
      final WeatherData data = WeatherData.fromJson(response.data);
      return BaseResponse(
        statusCode: response.statusCode,
        data: data,
      );
    }
    return response;
  }
}
