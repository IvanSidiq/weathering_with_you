// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weathering_with_you/modules/weather/cubit/city_cubit.dart';
import 'package:weathering_with_you/modules/weather/cubit/detail_cubit.dart';
import 'package:weathering_with_you/modules/weather/cubit/weather_cubit.dart';
import 'package:weathering_with_you/utils/api.dart';
import 'package:weathering_with_you/utils/colors.dart';
import 'package:weathering_with_you/utils/customs/custom_text_style.dart';
import 'package:weathering_with_you/utils/image_links.dart';

import 'models/city.dart';
import 'models/weather.dart';
import 'widgets/cities_widget.dart';

part 'widgets/weather_detail_widget.dart';

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
        BlocProvider(
          create: (context) => DetailCubit(),
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
    final sCubit = context.read<DetailCubit>();

    useEffect(() {
      cubit.determinePosition();
      return;
    }, [cubit]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.onSurface,
        body: ZStack(
          [
            BlocConsumer<WeatherCubit, WeatherState>(
              listener: (context, state) {
                if (state is GetWeatherSuccess) {
                  final cityDate = (DateTime.fromMillisecondsSinceEpoch(
                      state.weatherData.dt * 1000));
                  cubit.cityName = state.weatherData.name;
                  cubit.weatherCode = state.weatherData.weather!.first.id;
                  cubit.date = DateFormat('EEEE, dd MMM yyyy').format(cityDate);
                  cubit.time = DateFormat('HH:mm').format(cityDate);
                  if (state.weatherData.sys!.sunset > state.weatherData.dt) {
                    cubit.isNight = false;
                  } else {
                    cubit.isNight = true;
                  }
                }
              },
              builder: (context, state) {
                return CachedNetworkImage(
                  width: context.screenWidth,
                  height: context.screenHeight,
                  imageUrl: linkById(
                      weatherCode: cubit.weatherCode, night: cubit.isNight),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                  imageBuilder: (context, imgProvider) {
                    return VxBox()
                        .color(CustomColor.error)
                        .height(context.screenHeight)
                        .width(context.screenWidth)
                        .bgImage(DecorationImage(
                            image: imgProvider, fit: BoxFit.cover))
                        .make();
                  },
                );
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
                      final weatherData = state.weatherData;
                      return VStack(
                        [
                          HStack([
                            TextField(
                              style: TextStyle(
                                color: (cubit.isNight
                                        ? CustomColor.surface
                                        : CustomColor.onSurface)
                                    .withOpacity(0.64),
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(
                                    color: (cubit.isNight
                                            ? CustomColor.surface
                                            : CustomColor.onSurface)
                                        .withOpacity(0.64),
                                  ),
                                  labelText: 'Search city',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16)),
                              onSubmitted: (value) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CitiesWidget(searchText: value);
                                    }).then((value) {
                                  if (value != null) {
                                    if (value is City) {
                                      cubit.getCurrentWeather(
                                          value.lat, value.lon);
                                    }
                                  }
                                });
                              },
                            ).p8().expand(),
                            Icon(
                              cubit.isLocationOn
                                  ? Icons.location_on
                                  : Icons.location_off,
                              size: 24,
                              color: (cubit.isNight
                                      ? CustomColor.surface
                                      : CustomColor.onSurface)
                                  .withOpacity(0.64),
                            ).p8().onTap(() {
                              cubit.determinePosition();
                            }),
                            8.widthBox
                          ])
                              .glassMorphic(
                                  border: Border.all(
                                      width: 0, style: BorderStyle.none))
                              .p16(),
                          BlocBuilder<DetailCubit, DetailState>(
                            builder: (context, state) {
                              return VStack(
                                [
                                  HStack(
                                    [
                                      '${weatherData.main!.temp.round()}'
                                          .text
                                          .textStyle(
                                              CustomTextStyle.displayLarge)
                                          .align(TextAlign.center)
                                          .color(cubit.isNight
                                              ? CustomColor.surface
                                              : CustomColor.onSurface)
                                          .make(),
                                      '°C'
                                          .text
                                          .textStyle(
                                              CustomTextStyle.titleMedium)
                                          .align(TextAlign.center)
                                          .color(cubit.isNight
                                              ? CustomColor.surface
                                              : CustomColor.onSurface)
                                          .make(),
                                    ],
                                    crossAlignment: CrossAxisAlignment.end,
                                  )
                                      .px8()
                                      .box
                                      .p4
                                      .color((cubit.isNight
                                              ? CustomColor.onSurface
                                              : CustomColor.surface)
                                          .withOpacity(
                                              sCubit.isShown ? 0.8 : 0.4))
                                      .withRounded(value: 8)
                                      .make(),
                                  8.heightBox,
                                  HStack([
                                    CachedNetworkImage(
                                      imageUrl:
                                          '$kApiWeatherIcon${weatherData.weather!.first.icon}@2x.png',
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          50.widthBox,
                                      errorWidget: (context, url, error) =>
                                          50.widthBox,
                                      imageBuilder: (context, imgProvider) {
                                        return Image(
                                          image: imgProvider,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    ),
                                    weatherData.weather!.first.description.text
                                        .textStyle(CustomTextStyle.titleMedium)
                                        .color(cubit.isNight
                                            ? CustomColor.surface
                                            : CustomColor.onSurface)
                                        .align(TextAlign.start)
                                        .make()
                                        .box
                                        .width(80)
                                        .make(),
                                  ])
                                      .box
                                      .p4
                                      .color((cubit.isNight
                                              ? CustomColor.onSurface
                                              : CustomColor.surface)
                                          .withOpacity(
                                              sCubit.isShown ? 0.8 : 0.4))
                                      .withRounded(value: 8)
                                      .make(),
                                  8.heightBox,
                                  sCubit.isShown
                                      ? _WeatherDetailWidget(
                                          weatherData: weatherData)
                                      : Container(),
                                ],
                                crossAlignment: CrossAxisAlignment.center,
                                alignment: MainAxisAlignment.center,
                              ).w(context.screenWidth).onTap(() {
                                sCubit.showDetail();
                              }).expand();
                            },
                          ),
                          VStack([
                            HStack([
                              Icon(
                                Icons.location_city,
                                size: 24,
                                color: cubit.isNight
                                    ? CustomColor.surface
                                    : CustomColor.onSurface,
                                shadows: [
                                  Shadow(
                                      color: cubit.isNight
                                          ? CustomColor.onSurface
                                          : CustomColor.surface,
                                      blurRadius: 50)
                                ],
                              ),
                              4.widthBox,
                              cubit.cityName.text
                                  .textStyle(CustomTextStyle.titleMedium)
                                  .color(cubit.isNight
                                      ? CustomColor.surface
                                      : CustomColor.onSurface)
                                  .shadow(
                                    0,
                                    0,
                                    50,
                                    cubit.isNight
                                        ? CustomColor.onSurface
                                        : CustomColor.surface,
                                  )
                                  .make(),
                            ]),
                            cubit.date.text
                                .textStyle(CustomTextStyle.titleMedium)
                                .color(cubit.isNight
                                    ? CustomColor.surface
                                    : CustomColor.onSurface)
                                .shadow(
                                  0,
                                  0,
                                  50,
                                  cubit.isNight
                                      ? CustomColor.onSurface
                                      : CustomColor.surface,
                                )
                                .make(),
                            cubit.time.text
                                .textStyle(CustomTextStyle.titleMedium)
                                .color(cubit.isNight
                                    ? CustomColor.surface
                                    : CustomColor.onSurface)
                                .shadow(
                                  0,
                                  0,
                                  50,
                                  cubit.isNight
                                      ? CustomColor.onSurface
                                      : CustomColor.surface,
                                )
                                .make(),
                          ]).px16(),
                        ],
                      )
                          .h(context.screenHeight *
                              (100 - context.safePercentHeight) /
                              100)
                          .w(context.screenWidth);
                    }
                    return 'Welcome to Weathering With You App'
                        .text
                        .textStyle(CustomTextStyle.bodyMedium)
                        .makeCentered()
                        .w(400)
                        .centered();
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
