import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_media/application/controller/my_feed_controller.dart';
import 'package:video_player_media/application/presentation/screens/home_screen/home_screen.dart';
import 'package:video_player_media/utils/custom_app_bar.dart';

class MyFeedScreen extends StatelessWidget {
  const MyFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 10,),
              CustomAppBar(title: 'My Feed', fromAddFeed: false),
            ],
          ),
          Consumer<MyFeedController>(
            builder: (context, feedController, _) {
              if (feedController.myFeedLoading) {
                return Expanded(
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  ),
                );
              }

              final feeds = feedController.myFeeds.results ?? [];

              // Use ListView.builder instead of SingleChildScrollView
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: feeds.length,
                  itemBuilder: (context, index) {
                    final feed = feeds[index];
                    return FeedItem(feed: feed);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
