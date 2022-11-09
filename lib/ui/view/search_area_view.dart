import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/static/animation_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/view_model/controller/nav_controller.dart';

import '../../model/vo/location_vo.dart';

class SearchAreaView extends StatefulWidget {
  const SearchAreaView({super.key});

  @override
  State<SearchAreaView> createState() => _SearchAreaViewState();
}

class _SearchAreaViewState extends State<SearchAreaView> {
  final _controller = TextEditingController();
  final NavController _navController = Get.find<NavController>();
  List<LocationVO> lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Hero(
          tag: AnimationTheme.TextFormTag,
          child: Material(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '위치 검색',
                prefixIcon: Icon(Icons.search),
                // prefixIconColor: Theme.of(context).backgroundColor,
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(SizeTheme.h_sm),
          child: Container(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      bottomSheet: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 80.h),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(),
            minimumSize: Size(double.maxFinite, 105.h),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: SizeTheme.h_lg),
          ),
          onPressed: () async {
            if (_controller.text.isNotEmpty) {
              lists = await _navController.getPOISearch(_controller.text);
              setState(() {});
            }
          },
          icon: const Icon(Icons.navigation_rounded),
          label: Text(
            '보행자 길찾기',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .apply(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          if (index == lists.length - 1) {
            return SizedBox(height: 150.h);
          }
          return ListTile(
            title: Text(lists[index].name),
            subtitle: Text(lists[index].address),
            onTap: () {},
          );
        },
      ),
    );
  }
}
