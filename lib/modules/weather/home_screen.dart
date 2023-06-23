// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weathering_with_you/modules/weather/cubit/city_cubit.dart';
import 'package:weathering_with_you/modules/weather/cubit/weather_cubit.dart';
import 'package:weathering_with_you/utils/api.dart';
import 'package:weathering_with_you/utils/colors.dart';
import 'package:weathering_with_you/utils/customs/custom_text_style.dart';
import 'package:weathering_with_you/utils/image_links.dart';

import 'models/city.dart';
import 'widgets/cities_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherCubit(),
        ),
        BlocProvider(
          create: (context) => CityCubit(),
        ),
      ],
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends HookWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WeatherCubit>();
    String cityName = '';
    String date = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());
    String time = DateFormat('hh:mm').format(DateTime.now());

    useEffect(() {
      cubit.getCurrentWeather(-7.5692489, 110.828448);
      return;
    }, [cubit]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.surface,
        body: ZStack(
          [
            CachedNetworkImage(
              width: context.screenWidth,
              height: context.screenHeight,
              imageUrl: ImageLinks.rainy1,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Container(),
              imageBuilder: (context, imgProvider) {
                return VxBox()
                    .color(CustomColor.error)
                    .height(context.screenHeight)
                    .width(context.screenWidth)
                    .bgImage(
                        DecorationImage(image: imgProvider, fit: BoxFit.cover))
                    .make();
              },
            ),
            VStack(
              [
                BlocBuilder<WeatherCubit, WeatherState>(
                  builder: (context, state) {
                    if (state is GetWeatherLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is GetWeatherSuccess) {
                      final cityDate = (DateTime.fromMillisecondsSinceEpoch(
                          state.weatherData.dt! * 1000));
                      cityName = state.weatherData.name!;
                      date = DateFormat('EEEE, dd MMM yyyy').format(cityDate);
                      time = DateFormat('hh:mm').format(cityDate);
                      return VStack(
                        [
                          TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: CustomColor.onSurface
                                          .withOpacity(0.12)),
                                ),
                                hintStyle: TextStyle(
                                    color: CustomColor.onSurfaceVariant),
                                labelText: 'Search city',
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16)),
                            onSubmitted: (value) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CitiesWidget(searchText: value);
                                  }).then((value) {
                                if (value != null) {
                                  if (value is City) {
                                    cubit.getCurrentWeather(
                                        value.lat!, value.lon!);
                                  }
                                }
                              });
                            },
                          ).p16(),
                          VStack(
                            [
                              HStack(
                                [
                                  '${state.weatherData.main!.temp!.round()}'
                                      .text
                                      .textStyle(CustomTextStyle.displayLarge)
                                      .align(TextAlign.center)
                                      .color(CustomColor.surface)
                                      .make(),
                                  '°C'
                                      .text
                                      .textStyle(CustomTextStyle.titleMedium)
                                      .align(TextAlign.center)
                                      .color(CustomColor.surface)
                                      .make(),
                                ],
                                crossAlignment: CrossAxisAlignment.end,
                              ).px8().glassMorphic(
                                  border: Border.all(
                                      width: 0, style: BorderStyle.none)),
                              8.heightBox,
                              HStack([
                                CachedNetworkImage(
                                  imageUrl:
                                      '$kApiWeatherIcon${state.weatherData.weather!.first.icon!}@2x.png',
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      '$error'.text.make(),
                                  imageBuilder: (context, imgProvider) {
                                    return Image(
                                      image: imgProvider,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                                state.weatherData.weather!.first.description!
                                    .text
                                    .textStyle(CustomTextStyle.titleMedium)
                                    .color(CustomColor.surface)
                                    .align(TextAlign.start)
                                    .make()
                                    .box
                                    .width(80)
                                    .make(),
                              ]).glassMorphic(
                                  border: Border.all(
                                      width: 0, style: BorderStyle.none)),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                            alignment: MainAxisAlignment.center,
                          ).w(context.screenWidth).expand(),
                          VStack([
                            HStack([
                              Icon(
                                Icons.location_city,
                                size: 24,
                                color: CustomColor.surface,
                                shadows: [
                                  Shadow(
                                      color: CustomColor.onSurface,
                                      blurRadius: 50)
                                ],
                              ),
                              4.widthBox,
                              cityName.text
                                  .textStyle(CustomTextStyle.titleMedium)
                                  .color(CustomColor.surface)
                                  .shadow(0, 0, 50, CustomColor.onSurface)
                                  .make(),
                            ]),
                            date.text
                                .textStyle(CustomTextStyle.titleMedium)
                                .color(CustomColor.surface)
                                .shadow(0, 0, 50, CustomColor.onSurface)
                                .make(),
                            time.text
                                .textStyle(CustomTextStyle.titleMedium)
                                .color(CustomColor.surface)
                                .shadow(0, 0, 50, CustomColor.onSurface)
                                .make(),
                          ]).px16(),
                        ],
                      )
                          .h(context.screenHeight *
                              (100 - context.safePercentHeight) /
                              100)
                          .w(context.screenWidth);
                    }
                    return 'Please activate location or search a city'
                        .text
                        .makeCentered();
                  },
                )
              ],
              alignment: MainAxisAlignment.center,
              crossAlignment: CrossAxisAlignment.center,
            )
                .h(context.screenHeight *
                    (100 - context.safePercentHeight) /
                    100)
                .w(context.screenWidth)
                .scrollVertical(),
          ],
        ),
      ),
    );
  }
}
