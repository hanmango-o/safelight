import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/utils/enums.dart';
import 'package:safelight/core/utils/images.dart';
import 'package:safelight/core/utils/themes.dart';
import 'package:safelight/domain/entities/crosswalk.dart';
import 'package:safelight/domain/usecases/service_usecase.dart';
import 'package:safelight/injection.dart';
import 'package:safelight/presentation/bloc/crosswalk_bloc.dart';
import 'package:safelight/presentation/bloc/crosswalk_event.dart';
import 'package:safelight/presentation/bloc/crosswalk_state.dart';
import 'package:safelight/presentation/views/flashlight_view.dart';
import 'package:safelight/presentation/widgets/flat_card.dart';
import 'package:safelight/presentation/widgets/single_child_rounded_card.dart';
import 'package:safelight/presentation/widgets/board.dart';
import 'package:safelight/presentation/widgets/compass.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<GlobalKey> keys = [GlobalKey(), GlobalKey()];
  final ControlFlash flashOff = DI.get<ControlFlash>(
    instanceName: USECASE_CONTROL_FLASH_OFF,
  );

  @override
  void initState() {
    super.initState();
    context.read<CrosswalkBloc>().add(SearchFiniteCrosswalkEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(SizeTheme.r_sm)),
          child: Image(
            semanticLabel: '홈 화면',
            width: 90.w,
            height: 60.h,
            image: AssetImage(Images.AppTitle),
          ),
        ),
        actions: [
          Semantics(
            label: '안전 경광등 페이지 이동',
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashlightView(
                    flashOn: DI.get<ControlFlash>(
                        instanceName: USECASE_CONTROL_FLASH_ON),
                    flashOff: DI.get<ControlFlash>(
                        instanceName: USECASE_CONTROL_FLASH_OFF),
                  ),
                ),
              ),
              icon: const Icon(Icons.flashlight_on_outlined),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: Board(
              title: '내 주변 횡단보도',
              body: Expanded(
                child: BlocBuilder<CrosswalkBloc, CrosswalkState>(
                  builder: (_, state) {
                    if (state is On) {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.h),
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
                    } else if (state is Off) {
                      if (state.results.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(
                            SizeTheme.h_lg,
                          ),
                          margin: EdgeInsets.only(
                            left: SizeTheme.w_md,
                            right: SizeTheme.w_md,
                            bottom: SizeTheme.w_md,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(
                              SizeTheme.r_sm,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                width: 130.w,
                                image: AssetImage(Images.Error),
                                semanticLabel: '압버튼 없음',
                              ),
                              SizedBox(height: 26.h),
                              Text(
                                '주변에 블루투스 압버튼이 없어요',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeTheme.w_md,
                          ),
                          itemCount: state.results.length,
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
                                isDismissible: false,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 700.h,
                                    child: Board(
                                      title: '안전 리모콘',
                                      headerPadding: EdgeInsets.all(
                                        SizeTheme.w_md,
                                      ),
                                      titleStyle: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      trailing: TextButton(
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: 50.w),
                                          child: const FittedBox(
                                              child: Text('닫기')),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      body: Expanded(
                                        child: SizedBox(
                                          height: 600.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            children: <Widget>[
                                              _renderSelectedMode(
                                                context,
                                                state.results[index],
                                                index,
                                              ),
                                              _renderAfterModeSelected(
                                                context,
                                                state.results[index],
                                                index,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).whenComplete(() async {
                                flashOff(NoParams());

                                this
                                    .context
                                    .read<CrosswalkBloc>()
                                    .add(SearchFiniteCrosswalkEvent());
                              }).timeout(
                                const Duration(seconds: 100),
                                onTimeout: () {
                                  Navigator.pop(this.context);
                                },
                              ),
                              leading: SingleChildRoundedCard(
                                child: Image(
                                  width: 42.w,
                                  height: 42.w,
                                  image: AssetImage(
                                    state.results[index].type ==
                                            ECrosswalk.SINGLE_ROAD
                                        ? Images.TrafficSingle
                                        : state.results[index].type ==
                                                ECrosswalk.INTERSECTION
                                            ? Images.TrafficCross
                                            : Images.TrafficYellow,
                                  ),
                                ),
                              ),
                              title: RichText(
                                text: TextSpan(
                                  text: state.results[index].type ==
                                          ECrosswalk.SINGLE_ROAD
                                      ? '단일 신호등 지역'
                                      : state.results[index].type ==
                                              ECrosswalk.INTERSECTION
                                          ? '교차로 지역'
                                          : '점멸 신호등 지역',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(
                                        color: state.results[index].type ==
                                                ECrosswalk.SINGLE_ROAD
                                            ? ColorTheme.highlight3
                                            : state.results[index].type ==
                                                    ECrosswalk.INTERSECTION
                                                ? ColorTheme.highlight2
                                                : ColorTheme.highlight1,
                                      ),
                                  children: [
                                    const TextSpan(text: ' '),
                                    TextSpan(
                                      text: state.results[index].dir ?? '',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Text(
                                state.results[index].name,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: SizeTheme.h_sm);
                          },
                        );
                      }
                    } else if (state is Error) {
                      return Container(
                        padding: EdgeInsets.all(
                          SizeTheme.h_lg,
                        ),
                        margin: EdgeInsets.only(
                          left: SizeTheme.w_md,
                          right: SizeTheme.w_md,
                          bottom: SizeTheme.w_md,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(
                            SizeTheme.r_sm,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_outlined,
                              size: 150.h,
                              color: ColorTheme.highlight4,
                              semanticLabel: '경고 아이콘',
                            ),
                            SizedBox(height: 26.h),
                            Text(
                              state.message,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              minimumSize: Size(double.maxFinite, 80.h),
            ),
            onPressed: () async {
              context.read<CrosswalkBloc>().add(SearchFiniteCrosswalkEvent());
            },
            icon: BlocBuilder<CrosswalkBloc, CrosswalkState>(
              builder: (_, state) {
                if (state is On) {
                  return const Icon(Icons.stop_circle_outlined);
                } else if (state is Off) {
                  return const Icon(Icons.search);
                } else {
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
        ],
      ),
    );
  }

  Container _renderAfterModeSelected(
      BuildContext context, Crosswalk crosswalk, int index) {
    return Container(
      key: keys[1],
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: SizeTheme.w_md,
      ),
      child: BlocBuilder<CrosswalkBloc, CrosswalkState>(
        builder: (_, state) {
          if (state is Connect) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Error) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SingleChildRoundedCard(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
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
                        child: const Center(child: Text('음향 신호기에 연결할 수 없습니다.')),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('종료'),
                  ),
                )
              ],
            );
          } else if (state is Done) {
            if (state.enableCompass && state.latLng != null) {
              return Compass(
                pos: crosswalk.pos!,
                latLng: state.latLng!,
                end: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('종료'),
                  ),
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SingleChildRoundedCard(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
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
                            const Center(child: Text('음향신호기의 안내에 따라 보행하세요.')),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('종료'),
                  ),
                )
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Container _renderSelectedMode(
      BuildContext context, Crosswalk crosswalk, int index) {
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
              leading: const Icon(
                Icons.location_pin,
                color: ColorTheme.highlight3,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onTap: () {
                this
                    .context
                    .read<CrosswalkBloc>()
                    .add(SendVoiceInductorEvent(crosswalk: crosswalk));
                Scrollable.ensureVisible(
                  keys[1].currentContext!,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
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
              leading: const Icon(
                Icons.directions_walk_rounded,
                color: ColorTheme.highlight2,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onTap: () async {
                this
                    .context
                    .read<CrosswalkBloc>()
                    .add(SendAcousticSignalEvent(crosswalk: crosswalk));
                Scrollable.ensureVisible(
                  keys[1].currentContext!,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
