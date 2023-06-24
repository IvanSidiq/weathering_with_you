part of '../home_screen.dart';

class _WeatherDetailWidget extends StatelessWidget {
  const _WeatherDetailWidget({Key? key, required this.weatherData})
      : super(key: key);
  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack([
          _WeatherTiles(
            icon: Icons.sunny,
            type: 'feels like',
            val: '${weatherData.main!.feelsLike}°C ',
          ),
          8.widthBox,
          _WeatherTiles(
            icon: Icons.compress,
            type: 'pressure',
            val: '${weatherData.main!.pressure} hPa',
          ),
        ]),
        8.heightBox,
        HStack([
          _WeatherTiles(
            icon: Icons.water_drop,
            type: 'humidity',
            val: '${weatherData.main!.humidity}%',
          ),
          8.widthBox,
          _WeatherTiles(
            icon: Icons.cloud,
            type: 'cloudiness',
            val: '${weatherData.clouds!.all}%',
          ),
        ]),
        8.heightBox,
        HStack([
          _WeatherTiles(
            icon: Icons.wind_power,
            type: 'wind speed',
            val: '${weatherData.wind!.speed}m/s',
          ),
          8.widthBox,
          _WeatherTiles(
            icon: Icons.wind_power,
            type: 'wind gust',
            val: '${weatherData.wind!.speed}m/s',
          ),
        ]),
        8.heightBox,
        _WeatherTiles(
          icon: Icons.directions,
          type: 'wind degree',
          val: '${weatherData.wind!.deg}°',
        ),
      ],
      crossAlignment: CrossAxisAlignment.center,
    );
  }
}

class _WeatherTiles extends StatelessWidget {
  const _WeatherTiles(
      {Key? key, required this.icon, required this.type, required this.val})
      : super(key: key);
  final IconData icon;
  final String type;
  final String val;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WeatherCubit>();
    return HStack([
      Icon(icon,
          size: 16,
          color: cubit.isNight ? CustomColor.surface : CustomColor.onSurface),
      8.widthBox,
      VStack([
        type.text
            .textStyle(CustomTextStyle.bodySmall)
            .color(cubit.isNight
                ? CustomColor.surfaceVariant
                : CustomColor.onSurfaceVariant)
            .align(TextAlign.start)
            .make(),
        val.text
            .textStyle(CustomTextStyle.titleMedium)
            .color(cubit.isNight ? CustomColor.surface : CustomColor.onSurface)
            .align(TextAlign.start)
            .make(),
      ]),
    ])
        .box
        .p4
        .width(100)
        .color((cubit.isNight ? CustomColor.onSurface : CustomColor.surface)
            .withOpacity(0.8))
        .withRounded(value: 8)
        .make();
  }
}
