// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/utils/images.dart';
import 'package:safelight/core/utils/themes.dart';
import 'package:safelight/presentation/bloc/auth_bloc.dart';
import 'package:safelight/presentation/widgets/single_child_rounded_card.dart';

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
        title: const Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Semantics(
              label: '로그인 화면 배경 이미지',
              child: SingleChildRoundedCard(
                padding: EdgeInsets.all(SizeTheme.h_lg * 2),
                child: Image(
                  width: 200.w,
                  image: AssetImage(Images.EnterApp),
                ),
              ),
            ),
            ElevatedButton(
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
              child: const Text('로그인 없이 이용하기'),
            ),
          ],
        ),
      ),
    );
  }
}
