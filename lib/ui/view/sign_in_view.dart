import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/resource/image_resource.dart';
import 'package:safelight/asset/resource/sign_resource.dart';
import 'package:safelight/ui/widget/single_child_rounded_card.dart';
import 'package:safelight/view_model/controller/user_controller.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        centerTitle: true,
        title: Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SingleChildRoundedCard(
              child: Image(
                width: 250.w,
                image: AssetImage(ImageResource.IMG_EnterApp),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _userController.sign.signIn(SignType.anonymously);
              },
              child: Text('로그인 없이 이용하기'),
            ),
          ],
        ),
      ),
    );
  }
}
