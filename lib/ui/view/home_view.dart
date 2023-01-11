// ignore_for_file: avoid_returning_null_for_void

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:safelight/asset/resource/api_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/model/repository/http_repository.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/frame/compass_frame.dart';
import 'package:safelight/ui/view/flashlight_view.dart';
import 'package:safelight/ui/view/navigator_view.dart';
import 'package:safelight/ui/widget/flat_card.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';
import 'package:safelight/view_model/controller/service_controller.dart';
import 'package:safelight/view_model/implement/bluetooth/default_search_impl.dart';
import 'package:safelight/view_model/implement/service/flashlight_impl.dart';
import 'package:shimmer/shimmer.dart';

import '../../asset/resource/blue_resource.dart';
import '../../asset/resource/image_resource.dart';
import '../../model/vo/crosswalk_vo.dart';
import '../../view_model/implement/bluetooth/acoustic_signal_impl.dart';
import '../../view_model/implement/bluetooth/voice_inductor_impl.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BlueController _blueController = Get.find<BlueController>();
  final ServiceController _serviceController = Get.find<ServiceController>();
  late final FlashLightImpl _flashlight;
  List<GlobalKey> keys = [GlobalKey(), GlobalKey()];

  @override
  void initState() {
    super.initState();
    _blueController.blueHandler.searchCMD = DefaultSearch();
    _blueController.blueHandler
      ..reset()
      ..search();
    _serviceController.strategy = FlashLightImpl();
    _flashlight = _serviceController.strategy as FlashLightImpl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(SizeTheme.r_sm)),
          child: Image(
            width: 90.w,
            height: 60.h,
            image: AssetImage(ImageResource.IMG_AppTitle),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => FlashlightView()),
            icon: const Icon(Icons.flashlight_on_outlined),
          ),
        ],
      ),
      bottomSheet: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 80.h),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(),
            minimumSize: Size(double.maxFinite, 80.h),
          ),
          onPressed: () async {
            _blueController.blueHandler.searchCMD = DefaultSearch();
            _blueController.blueHandler
              ..reset()
              ..search();
          },
          icon: Obx(
            () {
              switch (BlueController.status.value) {
                case StatusType.IS_SCANNING:
                  return const Icon(Icons.stop_circle_outlined);
                case StatusType.COMPLETE:
                  return const Icon(Icons.search);
                case StatusType.STAND_BY:
                default:
                  return const Icon(Icons.pause_circle_outline);
              }
            },
          ),
          label: Text(
            '횡단보도 압버튼 찾기',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .apply(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BoardFrame(
              title: '내 주변 횡단보도',
              body: Column(
                children: [
                  StreamBuilder<List<CrosswalkVO>>(
                    stream: _blueController.blueHandler.results,
                    builder: (c, snapshot) {
                      switch (BlueController.status.value) {
                        case StatusType.IS_SCANNING:
                        case StatusType.STAND_BY:
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withAlpha(80),
                            highlightColor: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withAlpha(120),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (_, __) => Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeTheme.h_lg,
                                  vertical: SizeTheme.w_sm,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: SizeTheme.w_sm,
                                      ),
                                    ),
                                    Container(
                                      width: 62.w,
                                      height: 62.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(SizeTheme.r_sm),
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 230.w,
                                          height: 16.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(SizeTheme.r_sm),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                        ),
                                        Container(
                                          width: 143.w,
                                          height: 16.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(SizeTheme.r_sm),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              itemCount: 3,
                            ),
                          );
                        case StatusType.COMPLETE:
                          // test

                          if (snapshot.data!.isEmpty) {
                            return Container(
                              padding: EdgeInsets.all(
                                SizeTheme.h_lg,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: SizeTheme.w_md,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(
                                  SizeTheme.r_sm,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Image(
                                    width: 130.w,
                                    image: AssetImage(ImageResource.IMG_Error),
                                  ),
                                  SizedBox(height: 26.h),
                                  Text(
                                    '주변에 블루투스 압버튼이 없어요',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeTheme.w_md,
                            ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeTheme.w_sm,
                                  horizontal: SizeTheme.h_lg,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    SizeTheme.r_sm,
                                  ),
                                ),
                                onTap: () => showModalBottomSheet(
                                  isScrollControlled: true,
                                  barrierColor: Theme.of(context)
                                      .colorScheme
                                      .onSecondary
                                      .withAlpha(100),
                                  context: context,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 700.h,
                                      child: BoardFrame(
                                        title: '안전 리모콘',
                                        headerPadding: EdgeInsets.all(
                                          SizeTheme.w_md,
                                        ),
                                        titleStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        trailing: TextButton(
                                          child: Text('닫기'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        body: SizedBox(
                                          height: 600.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            children: <Widget>[
                                              _renderSelectedMode(
                                                context,
                                                snapshot.data?[index],
                                                index,
                                              ),
                                              _renderAfterModeSelected(
                                                context,
                                                snapshot.data?[index],
                                                index,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).timeout(
                                  Duration(minutes: 4),
                                  onTimeout: () {
                                    Navigator.pop(context);
                                  },
                                ).whenComplete(() {
                                  _flashlight.reset();
                                  _blueController.blueHandler
                                    ..reset()
                                    ..search();
                                }),
                                leading: SingleChildRoundedCard(
                                  child: Image(
                                    width: 42.w,
                                    height: 42.w,
                                    image: AssetImage(
                                      snapshot.data?[index].type ==
                                              AreaType.SINGLE_ROAD
                                          ? ImageResource.IMG_TrafficSingle
                                          : snapshot.data?[index].type ==
                                                  AreaType.INTERSECTION
                                              ? ImageResource.IMG_TrafficCross
                                              : ImageResource.IMG_TrafficYellow,
                                    ),
                                  ),
                                ),
                                title: RichText(
                                  text: TextSpan(
                                    text: snapshot.data?[index].type ==
                                            AreaType.SINGLE_ROAD
                                        ? '단일 신호등 지역'
                                        : snapshot.data?[index].type ==
                                                AreaType.INTERSECTION
                                            ? '교차로 지역'
                                            : '점멸 신호등 지역',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(
                                          color: snapshot.data?[index].type ==
                                                  AreaType.SINGLE_ROAD
                                              ? ColorTheme.highlight3
                                              : snapshot.data?[index].type ==
                                                      AreaType.INTERSECTION
                                                  ? ColorTheme.highlight2
                                                  : ColorTheme.highlight1,
                                        ),
                                    children: [
                                      const TextSpan(text: ' '),
                                      TextSpan(
                                        text: snapshot.data?[index].dir ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Text(
                                  snapshot.data?[index].name ?? '',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: SizeTheme.h_sm);
                            },
                          );
                        default:
                          return SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 126.h),
          ],
        ),
      ),
    );
  }

  Container _renderAfterModeSelected(
      BuildContext context, CrosswalkVO? crosswalk, int index) {
    return Container(
        key: keys[1],
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: SizeTheme.w_md,
        ),
        child: Obx(() {
          log(BlueController.status.value.toString());
          switch (BlueController.status.value) {
            case StatusType.IS_CONNECTING:
              return Center(child: CircularProgressIndicator());
            case StatusType.CONNECTED_COMPLETE:
              return crosswalk!.pos == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SingleChildRoundedCard(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: SizeTheme.h_lg),
                                child: Icon(
                                  Icons.check_circle_outline_outlined,
                                  size: 80.w,
                                  color: ColorTheme.highlight2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: SizeTheme.h_lg),
                                child:
                                    Center(child: Text('음향신호기의 안내에 따라 보행하세요.')),
                              ),
                            ],
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _flashlight.reset();
                              Navigator.pop(context);
                            },
                            child: Text('종료'),
                          ),
                        )
                      ],
                    )
                  : CompassFrame(
                      pos: crosswalk.pos,
                      end: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _flashlight.reset();
                            Navigator.pop(context);
                          },
                          child: Text('종료'),
                        ),
                      ),
                    );

            case StatusType.ERROR:
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SingleChildRoundedCard(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: SizeTheme.h_lg),
                          child: Icon(
                            Icons.error_outline,
                            size: 80.w,
                            color: ColorTheme.highlight4,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: SizeTheme.h_lg),
                          child: Center(child: Text('음향 신호기에 연결할 수 없습니다.')),
                        ),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('종료'),
                    ),
                  )
                ],
              );
            default:
              return SizedBox();
          }
        }));
  }

  Container _renderSelectedMode(
      BuildContext context, CrosswalkVO? crosswalk, int index) {
    return Container(
      key: keys[0],
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: SizeTheme.w_md,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: SizeTheme.h_md,
            ),
            child: FlatCard(
              title: '음성 유도',
              titleOnly: true,
              leading: Icon(
                Icons.location_pin,
                color: ColorTheme.highlight3,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onTap: () async {
                _blueController.blueHandler.sendCMD = VoiceInductor(
                  crosswalks: [
                    crosswalk!,
                  ],
                );
                Scrollable.ensureVisible(
                  keys[1].currentContext!,
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
                await _blueController.blueHandler
                    .send()
                    .whenComplete(() => _flashlight.turnOnWithWeather());
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: SizeTheme.h_md,
            ),
            child: FlatCard(
              title: '압버튼 누르기',
              titleOnly: true,
              leading: Icon(
                Icons.directions_walk_rounded,
                color: ColorTheme.highlight2,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onTap: () async {
                _blueController.blueHandler.sendCMD = AcousticSignal(
                  crosswalks: [
                    crosswalk!,
                  ],
                );
                Scrollable.ensureVisible(
                  keys[1].currentContext!,
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
                await _blueController.blueHandler
                    .send()
                    .whenComplete(() => _flashlight.turnOnWithWeather());
              },
            ),
          ),
        ],
      ),
    );
  }
}
