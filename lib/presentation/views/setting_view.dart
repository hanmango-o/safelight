// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/utils/themes.dart';
import 'package:safelight/domain/usecases/permission_usecase.dart';
import 'package:safelight/injection.dart';
import 'package:safelight/presentation/bloc/auth_bloc.dart';
import 'package:safelight/presentation/cubit/bluetooth_permission_cubit.dart';
import 'package:safelight/presentation/cubit/location_permission_cubit.dart';
import 'package:safelight/presentation/widgets/flat_card.dart';
import 'package:safelight/presentation/widgets/single_child_rounded_card.dart';
import 'package:safelight/presentation/widgets/board.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late String? mode;
  late Box box;

  SetPermission setPermission = DI.get<SetPermission>();

  @override
  void initState() {
    super.initState();
    context.read<BluetoothPermissionCubit>().getPermissionStatus();
    context.read<LocationPermissionCubit>().getPermissionStatus();
    box = Hive.box(SystemTheme.themeBox);
    mode = box.get(SystemTheme.mode) ?? ThemeMode.system.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + SizeTheme.h_lg,
            bottom: SizeTheme.h_lg,
            left: SizeTheme.w_md,
            right: SizeTheme.w_md,
          ),
          child: Semantics(
            label: '로그인 화면 이동 버튼, 현재 로그인 상태',
            child: ListTile(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  builder: (ctx) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  },
                  context: context,
                );
                await context.read<AuthBloc>().signOut(NoParams());
                Navigator.of(context).pop();
              },
              leading: SingleChildRoundedCard(
                child: Icon(
                  Icons.person,
                  size: 40.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '익명 사용자',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              trailing: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ),
        toolbarHeight: 120.h,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Board(
              title: '앱 내 권한',
              body: Column(
                children: [
                  Semantics(
                    label: '블루투스 권한 제어 버튼',
                    child: ListTile(
                      onTap: () async {
                        await context
                            .read<BluetoothPermissionCubit>()
                            .setPermissionStatus();
                        await context
                            .read<BluetoothPermissionCubit>()
                            .getPermissionStatus();
                      },
                      leading: const Icon(
                        Icons.bluetooth,
                        color: ColorTheme.highlight3,
                      ),
                      title: const Text(
                        '블루투스 허용',
                        semanticsLabel: '',
                      ),
                      trailing: Semantics(
                        child: BlocBuilder<BluetoothPermissionCubit, bool>(
                          builder: (_, state) {
                            return CupertinoSwitch(
                              value: state,
                              thumbColor:
                                  Theme.of(context).colorScheme.secondary,
                              trackColor: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.28),
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                              onChanged: (bool? value) async {
                                await context
                                    .read<BluetoothPermissionCubit>()
                                    .setPermissionStatus();
                                await context
                                    .read<BluetoothPermissionCubit>()
                                    .getPermissionStatus();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    label: '사용자 위치 정보 권한 제어 버튼',
                    child: BlocBuilder<LocationPermissionCubit, bool>(
                        builder: (_, state) {
                      return ListTile(
                        leading: const Icon(
                          Icons.gps_fixed_rounded,
                          color: ColorTheme.highlight4,
                        ),
                        title: const Text(
                          '사용자 위치 정보 허용',
                          semanticsLabel: '',
                        ),
                        trailing: CupertinoSwitch(
                          value: state,
                          thumbColor: Theme.of(context).colorScheme.secondary,
                          trackColor: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.28),
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (bool? value) async {
                            await context
                                .read<LocationPermissionCubit>()
                                .setPermissionStatus();
                            await context
                                .read<LocationPermissionCubit>()
                                .getPermissionStatus();
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Board(
              title: '기타',
              body: Column(
                children: [
                  ListTile(
                    onTap: () => showModalBottomSheet(
                      barrierColor: Theme.of(context)
                          .colorScheme
                          .onSecondary
                          .withAlpha(100),
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 800.h,
                          child: Board(
                            title: '시스템 모드 설정',
                            headerPadding: EdgeInsets.only(
                              bottom: SizeTheme.h_sm,
                            ),
                            padding: EdgeInsets.all(SizeTheme.w_md),
                            titleStyle: Theme.of(context).textTheme.titleLarge,
                            trailing: TextButton(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 50.w),
                                child: const FittedBox(child: Text('닫기')),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            body: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: SizeTheme.h_md,
                                  ),
                                  child: FlatCard(
                                    title: '시스템모드',
                                    titleOnly: true,
                                    bottomTitle: false,
                                    onTap: () async {
                                      Navigator.pop(context);

                                      await box.put(SystemTheme.mode,
                                          ThemeMode.system.name);
                                      setState(() {
                                        mode = box.get(SystemTheme.mode);
                                      });
                                    },
                                    trailing: mode == 'system'
                                        ? Text(
                                            '적용중',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .apply(
                                                  color: ColorTheme.highlight1,
                                                ),
                                          )
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: SizeTheme.h_md,
                                  ),
                                  child: FlatCard(
                                    title: '다크모드',
                                    titleOnly: true,
                                    bottomTitle: false,
                                    onTap: () async {
                                      Navigator.pop(context);

                                      await box.put(SystemTheme.mode,
                                          ThemeMode.dark.name);
                                      setState(() {
                                        mode = box.get(SystemTheme.mode);
                                      });
                                    },
                                    trailing: mode == 'dark'
                                        ? Text(
                                            '적용중',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .apply(
                                                  color: ColorTheme.highlight1,
                                                ),
                                          )
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: SizeTheme.h_md,
                                  ),
                                  child: FlatCard(
                                    title: '라이트모드',
                                    titleOnly: true,
                                    bottomTitle: false,
                                    onTap: () async {
                                      Navigator.pop(context);

                                      await box.put(SystemTheme.mode,
                                          ThemeMode.light.name);
                                      setState(() {
                                        mode = box.get(SystemTheme.mode);
                                      });
                                    },
                                    trailing: mode == 'light'
                                        ? Text(
                                            '적용중',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .apply(
                                                  color: ColorTheme.highlight1,
                                                ),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    title: const Text(
                      '시스템 모드 설정',
                      semanticsLabel: '시스템 모드 설정 버튼',
                    ),
                    subtitle: Text(
                      mode == 'system'
                          ? '시스템설정 적용중'
                          : mode == 'light'
                              ? '라이트모드 적용중'
                              : '다크모드 적용중',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LicensePage(
                            applicationName: 'SafeLight',
                          ),
                        ),
                      );
                    },
                    title: const Text('외부 라이센스'),
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