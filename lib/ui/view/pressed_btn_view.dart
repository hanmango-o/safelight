import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PressedBtnView extends StatefulWidget {
  final BluetoothDevice device;

  const PressedBtnView({Key? key, required this.device}) : super(key: key);

  @override
  State<PressedBtnView> createState() => _PressedBtnViewState();
}

class _PressedBtnViewState extends State<PressedBtnView> {
  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.device.disconnect();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   widget.device.discoverServices();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('신호 대기 중'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: widget.device.discoverServices().then(
                (services) async {
                  if (services.length > 0) {
                    await services.first.characteristics.first.write(
                      utf8.encode('1'),
                      withoutResponse: true,
                    );
                  }
                },
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    widget.device.disconnect();
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 300),
                        child: Text(
                          '홍대입구 1번 출구 방향\n신호등의 압버튼이 눌렸습니다.',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
