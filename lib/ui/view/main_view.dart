import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:safelight/ui/view/blue_off_view.dart';
import 'package:safelight/ui/view/home_view.dart';
import 'package:safelight/ui/view/setting_view.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final BlueController _blueController = Get.find<BlueController>();
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    SettingView(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _blueController.blueHandler.reset();
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBluePlus.instance.state,
      initialData: BluetoothState.on,
      builder: (context, snapshot) {
        if (snapshot.data != BluetoothState.off) {
          return Scaffold(
            body: _widgetOptions[_selectedIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.background,
                    width: 1.0,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                unselectedItemColor: Theme.of(context).colorScheme.surface,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz_rounded),
                    label: '설정',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Theme.of(context).colorScheme.onSecondary,
                onTap: (index) => _onItemTapped(index),
              ),
            ),
          );
        } else {
          return BlueOffView(state: snapshot.data!);
        }
      },
    );
  }
}
