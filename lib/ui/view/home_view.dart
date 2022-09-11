import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/view/pressed_btn_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool value = false;

  @override
  void initState() {
    super.initState();
    // FlutterBlue.instance.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 1600),
        curve: Curves.fastLinearToSlowEaseIn,
        height: value ? 620.h : 96.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26.r),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -10),
              blurRadius: 10,
              spreadRadius: 2,
              color: Theme.of(context).colorScheme.background,
            )
          ],
        ),
        child: Column(
          children: [
            AppBar(
              flexibleSpace: Center(
                child: Container(
                  width: 60.w,
                  height: 5.h,
                  margin: EdgeInsets.only(top: 16.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(double.infinity),
                  ),
                ),
              ),
              leading: value
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          value = !value;
                        });
                      },
                    )
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(26.r),
                ),
              ),
              toolbarHeight: 96.h,
              title: Text(
                '내 주변 횡단보도',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              actions: [
                Center(
                  child: Text(
                    '스캔 중',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                height: SizeTheme.h_lg,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('d'),
                      Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () => null,
            icon: Icon(Icons.flashlight_on_outlined),
          ),
          IconButton(
            onPressed: () => null,
            icon: Icon(Icons.camera_alt_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Theme.of(context).colorScheme.secondary,
              height: 126.h,
              child: Align(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      value = !value;
                    });
                  },
                  icon: Icon(Icons.search),
                  label: Text('횡단보도 압버튼 찾기'),
                ),
              ),
            ),
            BoardFrame(
              title: '제공 서비스',
              // backgroundColor: Colors.amber,
              body: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeTheme.w_md,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.white,
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // BoardFrame(
            //   title: '제공 서비스',
            //   body: GridView.count(
            //     primary: false,
            //     padding: const EdgeInsets.all(20),
            //     crossAxisSpacing: 10,
            //     mainAxisSpacing: 10,
            //     crossAxisCount: 2,
            //     children: <Widget>[
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[100],
            //         child: const Text("He'd have you all unravel at the"),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[200],
            //         child: const Text('Heed not the rabble'),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[300],
            //         child: const Text('Sound of screams but the'),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[400],
            //         child: const Text('Who scream'),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[500],
            //         child: const Text('Revolution is coming...'),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.teal[600],
            //         child: const Text('Revolution, they...'),
            //       ),
            //     ],
            //   ),
            // ),

            // StreamBuilder<List<ScanResult>>(
            //   stream: FlutterBlue.instance.scanResults,
            //   // stream: Stream.periodic(Duration(seconds: 4)).asyncMap((event) => null),
            //   initialData: [],
            //   builder: (c, snapshot) {
            //     if (!snapshot.hasData) {
            //       return Center(child: Text('주변에 SafeLight가 없습니다.'));
            //     }
            //     return Column(
            //       children: snapshot.data!.map((r) {
            //         if (r.device.name == 'HMSoft') {
            //           return Padding(
            //             padding: const EdgeInsets.all(20.0),
            //             child: SizedBox(
            //               width: double.infinity,
            //               height: 60,
            //               child: ElevatedButton(
            //                 child: Text(
            //                   '역곡역 1번출구 방향 압버튼',
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //                 onPressed: (r.advertisementData.connectable)
            //                     ? () async {
            //                         await r.device.connect(autoConnect: true);
            //                         Get.to(
            //                             () => PressedBtnView(device: r.device));
            //                       }
            //                     : null,
            //               ),
            //             ),
            //           );
            //         }
            //         return SizedBox();
            //       }).toList(),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
