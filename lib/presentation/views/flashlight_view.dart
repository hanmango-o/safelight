import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/utils/themes.dart';
import 'package:safelight/domain/usecases/service_usecase.dart';

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
                    Get.snackbar('안전 경광등을 사용할 수 없습니다.', '다시 시도해주세요.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: ColorTheme.highlight3,
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
                    Get.snackbar('안전 경광등을 사용할 수 없습니다.', '다시 시도해주세요.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: ColorTheme.highlight1,
                ),
                child: const Text('안전 경광등 끄기'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
