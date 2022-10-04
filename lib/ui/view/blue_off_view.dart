// ignore_for_file: avoid_returning_null_for_void

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safelight/asset/resource/image_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';

class BlueOffView extends StatelessWidget {
  final BluetoothState state;

  const BlueOffView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorTheme.highlight3,
            ColorTheme.primary,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '블루투스 상태 : ${state != BluetoothState.on ? '꺼짐' : ''}',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('$state'),
              Column(
                children: [
                  Image(
                    width: 220.w,
                    image: AssetImage(ImageResource.IMG_BusStop),
                  ),
                  SizedBox(height: SizeTheme.h_lg),
                  Container(
                    width: double.infinity,
                    color: const Color.fromARGB(29, 0, 0, 0),
                    padding: EdgeInsets.symmetric(vertical: SizeTheme.h_lg),
                    child: Center(
                      child: Text(
                        'SafeLight는 블루투스를 켜야 사용할 수 있습니다.',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(color: ColorTheme.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => null,
                label: const Text('블루투스를 켜주세요'),
                icon: const Icon(Icons.bluetooth_disabled_rounded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
              )
              // Spacer(),
              // SizedBox(height: ,)

              // SingleChildRoundedCard(
              //   child: Icon(
              //     Icons.bluetooth_disabled,
              //     size: 200.0,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              // ),
              // Container(
              //   color: Colors.white,
              //   child: Image(
              //     // width: .w,
              //     // height: 42.w,
              //     image: AssetImage(ImageResource.IMG_StopSign),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
