import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weathering_with_you/modules/weather/cubit/city_cubit.dart';
import 'package:weathering_with_you/utils/customs/custom_text_style.dart';

import '../../../utils/colors.dart';

class CitiesWidget extends StatelessWidget {
  const CitiesWidget({Key? key, required this.searchText}) : super(key: key);
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BlocProvider(
        create: (context) => CityCubit(),
        child: _CitiesWidget(
          searchText: searchText,
        ),
      )
          .box
          .color(CustomColor.surface)
          .width(context.screenWidth - 64)
          .height(200)
          .p16
          .withRounded(value: 16)
          .make(),
    );
  }
}

class _CitiesWidget extends HookWidget {
  const _CitiesWidget({Key? key, required this.searchText}) : super(key: key);
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CityCubit>();

    useEffect(() {
      cubit.getCities(searchText);
      return;
    }, [cubit]);

    return BlocBuilder<CityCubit, CityState>(
      builder: (context, state) {
        if (state is GetCitySuccess) {
          if (state.cityData.isEmpty) {
            return 'No city named $searchText found'
                .text
                .textStyle(CustomTextStyle.labelMedium)
                .make();
          }
          return VStack([
            'Found ${state.cityData.length} city(s) by name $searchText'
                .text
                .textStyle(CustomTextStyle.labelMedium)
                .make(),
            16.heightBox,
            ListView.builder(
                itemCount: state.cityData.length,
                itemBuilder: (context, index) {
                  return VStack([
                    8.heightBox,
                    HStack([
                      VStack([
                        state.cityData[index].name.text
                            .textStyle(CustomTextStyle.labelMedium)
                            .make(),
                        '${state.cityData[index].state} - ${state.cityData[index].country}'
                            .text
                            .textStyle(CustomTextStyle.bodySmall)
                            .color(CustomColor.onSurfaceVariant)
                            .make(),
                      ]).expand(),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: CustomColor.onSurfaceVariant,
                      ),
                    ]),
                    const Divider(thickness: 1),
                  ]).color(CustomColor.surface).onTap(() {
                    GoRouter.of(context).pop(state.cityData[index]);
                  }).px8();
                }).expand()
          ]);
        }
        if (state is GetCityLoading) {
          return const CircularProgressIndicator().centered();
        }
        return Container();
      },
    );
  }
}
