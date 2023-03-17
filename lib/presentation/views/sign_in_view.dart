// ignore_for_file: use_build_context_synchronously

part of ui;

/// 로그인 화면
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
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.message),
                      ));
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: SizeTheme.w_md),
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(SignInWithGoogleEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(50),
                                ),
                              ),
                              minimumSize: Size(double.maxFinite, 80.h),
                            ),
                            child: (state is AuthLoading)
                                ? CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                : const Text('구글 로그인'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(right: SizeTheme.w_md),
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(SignInAnonymouslyEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(50),
                                ),
                              ),
                              minimumSize: Size(double.maxFinite, 80.h),
                            ),
                            child: (state is AuthLoading)
                                ? CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                : const Text('로그인 없이 이용하기'),
                          ),
                        ),
                      ],
                    );
                  },
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
