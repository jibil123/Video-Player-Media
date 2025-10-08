import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_media/application/controller/home_screen_feed_controller.dart';
import 'package:video_player_media/application/presentation/screens/add_video.dart/add_video.dart';
import 'package:video_player_media/domain/model/home_page_feed/home_page_feed.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.black,
      body: Consumer<HomeScreenFeedController>(
        builder: (context, feedController, _) {
          if (feedController.categoryLoading ||
              feedController.homeScreenFeedsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          final feeds = feedController.homeScreenFeeds.results ?? [];

          // Use ListView.builder instead of SingleChildScrollView
          return ListView.builder(
            itemCount: feeds.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) return _buildHeader(feedController);
              if (index == 1) return _buildCategories(feedController);
              final feed = feeds[index - 2];
              return FeedItem(feed: feed);
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(HomeScreenFeedController controller) {
    final user = controller.homeScreenFeeds.user;
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello ${user?.name ?? 'Maria'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Welcome back to Section',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          CircleAvatar(
            radius: 22,
            backgroundImage: user?.image != null && user!.image!.isNotEmpty
                ? NetworkImage(user.image!)
                : null,
            child: user?.image == null || user!.image!.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(HomeScreenFeedController controller) {
    final categories = controller.categories.categories ?? [];
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Center(
            child: Text(
              categories[index].title ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}

class FeedItem extends StatefulWidget {
  final Result feed;
  const FeedItem({super.key, required this.feed});

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();

    if (widget.feed.video != null && widget.feed.video!.isNotEmpty) {
      _controller = VideoPlayerController.network(widget.feed.video!)
        ..initialize()
            .then((_) {
              if (mounted) {
                _controller!
                  ..setLooping(true)
                  ..setVolume(0);
                setState(() => _isVideoInitialized = true);
              }
            })
            .catchError((e) => debugPrint('Video init error: $e'));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    setState(() {});
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.feed.user;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(user?.name ?? ''),
            subtitle: const Text('5 days ago'),
          ),
          if (_controller != null && _isVideoInitialized)
            GestureDetector(
              onTap: () => setState(() => _showControls = !_showControls),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  // Controls overlay
                  if (_showControls)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black38,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Seekbar
                            VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: Colors.redAccent,
                                backgroundColor: Colors.white24,
                                bufferedColor: Colors.white54,
                              ),
                            ),
                            // Duration + Fullscreen + Play/Pause
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(
                                      _controller!.value.position,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _togglePlayPause,
                                    icon: Icon(
                                      _controller!.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(
                                      _controller!.value.duration,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Fullscreen logic
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => FullscreenVideoPage(
                                            controller: _controller!,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            // Thumbnail while loading
            Container(
              color: Colors.black,
              height: 220,
              child: widget.feed.image != null
                  ? Image.network(widget.feed.image!, fit: BoxFit.cover)
                  : const Center(
                      child: Icon(Icons.video_library, color: Colors.white),
                    ),
            ),
          // Description
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.feed.description ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Fullscreen page
class FullscreenVideoPage extends StatelessWidget {
  final VideoPlayerController controller;
  const FullscreenVideoPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
