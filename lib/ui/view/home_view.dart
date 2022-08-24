import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:safelight/ui/view/pressed_btn_view.dart';
import 'package:safelight/ui/widget/flat_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    FlutterBlue.instance.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SafeLight Demo'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton.large(
              child: Icon(Icons.stop, semanticLabel: '스캔 종료'),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton.large(
              child: Icon(Icons.search, semanticLabel: '스탠 시작'),
              onPressed: () => FlutterBlue.instance.startScan(),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Container(
            //   child: FlatCard(
            //     title: ,
            //   ),
            // ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              // stream: Stream.periodic(Duration(seconds: 4)).asyncMap((event) => null),
              initialData: [],
              builder: (c, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('주변에 SafeLight가 없습니다.'));
                }
                return Column(
                  children: snapshot.data!.map((r) {
                    if (r.device.name == 'HMSoft') {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            child: Text(
                              '역곡역 1번출구 방향 압버튼',
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: (r.advertisementData.connectable)
                                ? () async {
                                    await r.device.connect(autoConnect: true);
                                    Get.to(
                                        () => PressedBtnView(device: r.device));
                                  }
                                : null,
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}