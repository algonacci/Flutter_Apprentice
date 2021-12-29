import 'package:flutter/material.dart';
import 'package:fooderlich/components/components.dart';
import 'package:fooderlich/components/today_recipe_list_view.dart';

import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatefulWidget {
  ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late ScrollController _controller;
  final mockService = MockFooderlichService();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add TodayRecipeListView FutureBuilder
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        // TODO: Add nested List Views
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            children: [
              TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
              const SizedBox(height: 16),
              FriendPostListView(friendPosts: snapshot.data?.friendPosts ?? []),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print('i am at the bottom!');
    }
    if (_controller.offset <= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print('i am at the top!');
    }
  }
}
