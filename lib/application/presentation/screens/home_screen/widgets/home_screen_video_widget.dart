import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_media/application/controller/home_screen_feed_controller.dart';

class HomeFeedList extends StatefulWidget {
  const HomeFeedList({super.key});

  @override
  State<HomeFeedList> createState() => _HomeFeedListState();
}

class _HomeFeedListState extends State<HomeFeedList> {
  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, bool> _isInitialized = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initVideoForIndex(int index, String url) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controllers[index] = controller;

    try {
      await controller.initialize();
      controller.setLooping(true);
      controller.play();
      _isInitialized[index] = true;
      if (mounted) setState(() {});
      debugPrint("[log] video initialized for index $index");
    } catch (e) {
      debugPrint("[error] video init failed for index $index: $e");
      _isInitialized[index] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeScreenFeedController>(context);
    final feeds = homeController.homeScreenFeeds.results ?? [];

    if (homeController.homeScreenFeedsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (feeds.isEmpty) {
      return const Center(child: Text("No feeds available"));
    }

    return ListView.builder(
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        final feed = feeds[index];
        final videoUrl = feed.video ?? '';
        final imageUrl = feed.image ??
            'https://via.placeholder.com/300x200.png?text=No+Thumbnail';
        final description = feed.description ?? '';

        // Initialize the video when the widget builds
        if (!_controllers.containsKey(index) && videoUrl.isNotEmpty) {
          _initVideoForIndex(index, videoUrl);
        }

        final controller = _controllers[index];
        final isReady = _isInitialized[index] ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Thumbnail image (visible immediately)
                    Image.network(
                      imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),

                    // Fade-in video overlay
                    if (controller != null && isReady)
                      AnimatedOpacity(
                        opacity: controller.value.isInitialized ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
