import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weathering_with_you/modules/weather/models/city.dart';
import 'package:weathering_with_you/utils/api.dart';

import '../../../config/base_repository.dart';
import '../../../models/base_response.dart';

class CityRepository extends BaseRepository {
  Future<BaseResponse> getCityByName(String cityName) async {
    final response = await fetch(kApiFindCity, queryParameters: {
      'q': cityName,
      'appid': dotenv.env['OPEN_WEATHER_API'],
    });

    if (response.statusCode == 200) {
      final List<City> data =
          List.from(response.data).map((e) => City.fromJson(e)).toList();
      return BaseResponse(
        statusCode: response.statusCode,
        data: data,
      );
    }
    return response;
  }
}
