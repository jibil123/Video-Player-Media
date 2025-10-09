import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_media/application/controller/my_feed_controller.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool fromAddFeed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.fromAddFeed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.chevron_left, color: Colors.grey),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.zero,
                    iconSize: 23,
                  ),
                ),
                SizedBox(width: 30),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            fromAddFeed
                ? GestureDetector(
                    onTap: () {
                      context.read<MyFeedController>().feedPost(
                        context: context,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.15),
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          bottom: 5,
                          top: 5,
                        ),
                        child: Consumer<MyFeedController>(
                          builder: (context, ref, child) {
                            if (ref.feedPostLoading) {
                              return SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              );
                            } else {
                              return Text('Share Post');
                            }
                          },
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
