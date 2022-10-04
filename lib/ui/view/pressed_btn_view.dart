// ignore_for_file: prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PressedBtnView extends StatefulWidget {
  final BluetoothDevice device;

  const PressedBtnView({Key? key, required this.device}) : super(key: key);

  @override
  State<PressedBtnView> createState() => _PressedBtnViewState();
}

class _PressedBtnViewState extends State<PressedBtnView> {
  final FlutterTts tts = FlutterTts();
  bool isChange = false;

  @override
  void dispose() {
    super.dispose();
    widget.device.disconnect();
  }

  @override
  void initState() {
    super.initState();
    tts.setLanguage('ko');
    tts.setSpeechRate(0.5);
    tts.speak('잠시만 기다려주세요.');
    Future.delayed(const Duration(seconds: 5)).then((value) {
      setState(() {
        isChange = true;
      });
      tts.speak('초록불이 켜졌습니다.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('신호 대기 중'),
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
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    // widget.device.disconnect();
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 300),
                        child: Column(
                          children: [
                            const Text(
                              '황색불 지역',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              isChange ? '신호가 변경되었습니다.' : '잠시만 기다려주세요.',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
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
