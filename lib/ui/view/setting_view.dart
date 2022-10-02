import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safelight/asset/resource/auth_resource.dart';
import 'package:safelight/asset/resource/sign_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/frame/board_frame.dart';
import 'package:safelight/ui/view/external_licenses_view.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/user_controller.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final UserController _userController = Get.find<UserController>();
  bool bluetooth = true;
  bool noti = true;
  bool gps = true;
  bool camera = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + SizeTheme.h_lg,
            bottom: SizeTheme.h_lg,
            left: SizeTheme.w_md,
            right: SizeTheme.w_md,
          ),
          child: ListTile(
            onTap: () async {
              await _userController.sign.signOut(SignType.anonymously);
            },
            leading: SingleChildRoundedCard(
              child: Icon(
                Icons.person,
                size: 42.w,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              '익명',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              '회원가입을 해주세요',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
        toolbarHeight: 120.h,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BoardFrame(
              title: '앱 내 권한',
              body: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.bluetooth,
                      color: ColorTheme.highlight3,
                    ),
                    title: Text('블루투스 허용'),
                    trailing: StreamBuilder<bool>(
                      stream: _userController.auth.getBlueStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        return CupertinoSwitch(
                          value: snapshot.data!,
                          thumbColor: Theme.of(context).colorScheme.secondary,
                          trackColor: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.28),
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (bool? value) {
                            _userController.auth.permissionAuthorized(
                              PermissionType.bluetooth,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.notifications_active_outlined,
                  //     color: ColorTheme.highlight1,
                  //   ),
                  //   title: Text('푸쉬알림 허용'),
                  //   trailing: CupertinoSwitch(
                  //     value: noti,
                  //     thumbColor: Theme.of(context).colorScheme.secondary,
                  //     trackColor: Theme.of(context)
                  //         .colorScheme
                  //         .onBackground
                  //         .withOpacity(0.28),
                  //     activeColor: Theme.of(context).colorScheme.primary,
                  //     onChanged: (bool? value) {
                  //       setState(() {
                  //         noti = value!;
                  //       });
                  //     },
                  //   ),
                  // ),
                  ListTile(
                    leading: Icon(
                      Icons.gps_fixed_rounded,
                      color: ColorTheme.highlight4,
                    ),
                    title: Text('사용자 위치 정보 허용'),
                    trailing: StreamBuilder<bool>(
                        stream: _userController.auth.getLocationStream,
                        initialData: false,
                        builder: (context, snapshot) {
                          return CupertinoSwitch(
                            value: snapshot.data!,
                            thumbColor: Theme.of(context).colorScheme.secondary,
                            trackColor: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.28),
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (bool? value) async {
                              await _userController.auth.locationAuthorized();
                              setState(() {});
                            },
                          );
                        }),
                  ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.camera_alt_outlined,
                  //     color: ColorTheme.highlight2,
                  //   ),
                  //   title: Text('카메라 접근 허용'),
                  //   trailing: CupertinoSwitch(
                  //     value: camera,
                  //     thumbColor: Theme.of(context).colorScheme.secondary,
                  //     trackColor: Theme.of(context)
                  //         .colorScheme
                  //         .onBackground
                  //         .withOpacity(0.28),
                  //     activeColor: Theme.of(context).colorScheme.primary,
                  //     onChanged: (bool? value) {
                  //       setState(() {
                  //         camera = value!;
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
            BoardFrame(
              title: '보행 보조 서비스',
              body: Column(
                children: [
                  ListTile(
                    onTap: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return CupertinoActionSheet(
                          title: Text('주변 압버튼 스캔'),
                          message: ElevatedButton(
                            onPressed: () {},
                            child: Text('각 스캔 모드 설명보기'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('수동 모드'),
                              isDefaultAction: true,
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.pop(context);
                                Get.snackbar(
                                  '개발 중입니다.',
                                  '현재 버전에서는 사용할 수 없습니다.',
                                );
                              },
                              child: Text('자동 모드'),
                              isDefaultAction: true,
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: Text('취소'),
                          ),
                        );
                      },
                    ),
                    title: Text('주변 압버튼 스캔'),
                    subtitle: Text(
                      '수동',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  // ListTile(
                  //   title: Text('보행 안전 경광등'),
                  //   subtitle: Text(
                  //     '항상 켜짐',
                  //     style: Theme.of(context).textTheme.labelLarge,
                  //   ),
                  //   trailing: Icon(Icons.arrow_forward_ios_rounded),
                  // ),
                ],
              ),
            ),
            BoardFrame(
              title: '기타',
              body: Column(
                children: [
                  // ListTile(
                  //   title: Text('개인정보처리방침'),
                  // ),
                  // ListTile(
                  //   title: Text('이용 약관'),
                  // ),
                  ListTile(
                    onTap: () {
                      Get.to(() => ExternalLicensesView());
                    },
                    title: Text('외부 라이센스'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
