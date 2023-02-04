import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:safelight/injection.dart';
import 'package:safelight/presentation/views/blue_off_view.dart';
import 'package:safelight/presentation/views/home_view.dart';
import 'package:safelight/presentation/views/setting_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<Widget> _widgetOptions = const <Widget>[
    HomeView(),
    SettingView(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    DI.get<FlutterTts>().stop();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: DI.get<FlutterBluePlus>().state,
      initialData: BluetoothState.on,
      builder: (context, snapshot) {
        if (snapshot.data != BluetoothState.off) {
          return Scaffold(
            body: _widgetOptions[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Theme.of(context).colorScheme.surface,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_rounded,
                    semanticLabel: '홈 화면 네비게이션 버튼',
                  ),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    semanticLabel: '설정 화면 네비게이션 버튼',
                  ),
                  label: '설정',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.onSecondary,
              onTap: (index) => _onItemTapped(index),
            ),
          );
        } else {
          return BlueOffView(state: snapshot.data!);
        }
      },
    );
  }
}
