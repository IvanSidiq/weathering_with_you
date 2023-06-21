import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weathering_with_you/modules/weather/cubit/weather_cubit.dart';
import 'package:weathering_with_you/utils/api.dart';
import 'package:weathering_with_you/utils/customs/custom_text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(),
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends HookWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WeatherCubit>();

    useEffect(() {
      cubit.getCurrentWeather(-7.5692489, 110.828448);
      return;
    }, [cubit]);

    return Scaffold(
      body: VStack(
        [
          BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is GetWeatherLoading) {
                return const CircularProgressIndicator();
              }
              if (state is GetWeatherSuccess) {
                return VStack(
                  [
                    'today\'s weather'
                        .text
                        .textStyle(CustomTextStyle.headlineMedium)
                        .align(TextAlign.center)
                        .make(),
                    HStack([
                      CachedNetworkImage(
                        imageUrl:
                            '$kApiWeatherIcon${state.weatherData.weather!.first.icon!}.png',
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
                      8.widthBox,
                      state.weatherData.weather!.first.description!.text
                          .textStyle(CustomTextStyle.headlineMedium)
                          .align(TextAlign.center)
                          .make(),
                    ]),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                );
              }
              return 'This is home screen'.text.makeCentered();
            },
          )
        ],
        alignment: MainAxisAlignment.center,
        crossAlignment: CrossAxisAlignment.center,
      ).h(context.screenHeight).w(context.screenWidth),
    );
  }
}
