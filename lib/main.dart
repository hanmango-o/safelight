import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:safelight/ui/view/blue_off_view.dart';
import 'package:safelight/ui/view/home_view.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const SafeLight());
}

class SafeLight extends StatelessWidget {
  const SafeLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xff2A2C41),
          primaryContainer: Color(0xffF4F4F8),
        ),
      ),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return HomeView();
          }

          return BlueOffView(state: state!);
        },
      ),
    );
  }
}
