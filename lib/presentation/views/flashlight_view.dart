// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:safelight/injection.dart';

import '../../core/usecases/usecase.dart';
import '../../core/utils/themes.dart';
import '../../core/utils/tts.dart';
import '../../domain/usecases/service_usecase.dart';

class FlashlightView extends StatefulWidget {
  final ControlFlash flashOn;
  final ControlFlash flashOff;

  const FlashlightView({
    super.key,
    required this.flashOn,
    required this.flashOff,
  });

  @override
  State<FlashlightView> createState() => _FlashlightViewState();
}

class _FlashlightViewState extends State<FlashlightView> {
  final tts = DI.get<TTS>();

  @override
  void dispose() {
    super.dispose();
    widget.flashOff(NoParams());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('안전 경광등'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await widget.flashOn(NoParams());
                  if (result.isLeft()) {
                    tts('안전 경광등을 사용할 수 없습니다.');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('안전 경광등을 사용할 수 없습니다.'),
                    ));
                  } else {
                    tts('안전 경광등이 켜졌습니다.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: ColorTheme.highlight5,
                ),
                child: const Text('안전 경광등 켜기'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await widget.flashOff(NoParams());
                  if (result.isLeft()) {
                    tts('안전 경광등을 사용할 수 없습니다.');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('안전 경광등을 사용할 수 없습니다.'),
                    ));
                  } else {
                    tts('안전 경광등이 꺼졌습니다.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: ColorTheme.highlight1,
                ),
                child: const Text(
                  '안전 경광등 끄기',
                  style: TextStyle(
                    color: ColorTheme.highlight6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
