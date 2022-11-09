import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/static/animation_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/view/search_area_view.dart';
import 'package:safelight/view_model/controller/nav_controller.dart';

class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  final NavController _navController = Get.find<NavController>();

  @override
  void initState() {
    super.initState();
    _navController.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet: AnimatedContainer(
      //   duration: Duration(seconds: 1),
      //   child: ConstrainedBox(
      //     constraints: BoxConstraints(minHeight: 80.h),
      //     child: ElevatedButton.icon(
      //       style: ElevatedButton.styleFrom(
      //         shape: RoundedRectangleBorder(),
      //         minimumSize: Size(double.maxFinite, 105.h),
      //         alignment: Alignment.topCenter,
      //         padding: EdgeInsets.only(top: SizeTheme.h_lg),
      //       ),
      //       onPressed: () async {
      //         // Get.to(() => SearchAreaView());
      //         log('ddd');
      //         _navController.strategy = GetLocationImpl();
      //         await _navController.fetch();
      //       },
      //       icon: Icon(Icons.navigation_rounded),
      //       label: Text(
      //         '보행자 길찾기',
      //         style: Theme.of(context)
      //             .textTheme
      //             .titleLarge!
      //             .apply(color: Theme.of(context).colorScheme.onPrimary),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        title: const Text('보행자 길찾기'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(160.h),
          child: Padding(
            padding: EdgeInsets.all(SizeTheme.w_lg),
            child: FutureBuilder(
              future: _navController.getLocation(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '출발',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: snapshot.data.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          '도착',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Hero(
                            tag: AnimationTheme.TextFormTag,
                            child: Material(
                              child: TextFormField(
                                readOnly: true,
                                decoration: const InputDecoration(
                                  hintText: '도착 장소를 입력하세요.',
                                ),
                                onTap: () {
                                  Get.to(() => const SearchAreaView());
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BoardFrame(
              title: '검색결과',
              body: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index % 5 == 1) {
                    return const ListTile(
                      trailing: Icon(Icons.directions_walk_rounded),
                      title: Text('횡단보도 건너기'),
                    );
                  } else if (index % 5 == 2) {
                    return const ListTile(
                      trailing: Icon(Icons.turn_left_rounded),
                      title: Text('왼쪽방향'),
                    );
                  }

                  return const ListTile(
                    trailing: Icon(Icons.turn_right_rounded),
                    title: Text('xx방면'),
                    subtitle: Text('오른쪽 방향으로 이동'),
                  );
                },
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
