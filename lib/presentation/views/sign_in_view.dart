// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/utils/assets.dart';
import 'package:safelight/core/utils/themes.dart';
import 'package:safelight/presentation/bloc/auth_bloc.dart';
import 'package:safelight/presentation/views/dutorial_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('로그인 화면'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Semantics(
                    label: '로그인 화면 배경',
                    child: Lottie.asset(
                      Gif.LOTTIE_ENTER_BACKGROUND_LIGHT,
                      fit: BoxFit.fill,
                      repeat: false,
                    ),
                  )
                : Semantics(
                    label: '로그인 화면 배경',
                    child: Lottie.asset(
                      Gif.LOTTIE_ENTER_BACKGROUND_DARK,
                      fit: BoxFit.fill,
                      repeat: false,
                    ),
                  ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: SizeTheme.w_md),
                  child: ElevatedButton(
                    onPressed: () async {
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
                      await context.read<AuthBloc>().signIn(NoParams());
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(50),
                        ),
                      ),
                      minimumSize: Size(double.maxFinite, 80.h),
                    ),
                    child: const Text('로그인 없이 이용하기'),
                  ),
                ),
                SizedBox(height: SizeTheme.h_lg),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DutorialView(),
                    ),
                  ),
                  child: Text(
                    '처음 사용하시나요?',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
