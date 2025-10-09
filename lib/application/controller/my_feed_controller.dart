import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_media/application/presentation/screens/home_screen/home_screen.dart';
import 'package:video_player_media/application/presentation/screens/my_feeds/my_feeds.dart';
import 'package:video_player_media/data/service/my_feed_service.dart';
import 'package:video_player_media/domain/model/home_page_feed/home_page_feed.dart';
import 'package:video_player_media/domain/repo/my_feed_repo.dart';

class MyFeedController extends ChangeNotifier {
  MyFeedRepo myFeedService = MyFeedService();
  bool feedPostLoading = false;
  File? selectedVideo;
  File? selectedThumbnail;
  String description = '';
  HomeResponse myFeeds = HomeResponse();
  bool myFeedLoading = false;

  final List<int> selectedCategories = [];

  final picker = ImagePicker();

  void setDescription(String val) {
    description = val;
    notifyListeners();
  }

  // --- Video Functions ---
  bool _isPickingVideo = false;

  Future<void> pickVideo() async {
    if (_isPickingVideo) return;
    _isPickingVideo = true;

    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) return;

      log('called video picker');
      final video = await picker.pickVideo(source: ImageSource.gallery);
      if (video == null) return;

      final file = File(video.path);
      final duration = await _getVideoDuration(file);

      if (duration.inSeconds > 300) {
        log(
          'Video is longer than 5 minutes: ${duration.inMinutes}:${duration.inSeconds % 60}',
        );
        return;
      }

      selectedVideo = file;
      notifyListeners();
    } catch (e) {
      log('Video picking error: $e');
    } finally {
      _isPickingVideo = false;
    }
  }

  void removeVideo() {
    selectedVideo = null;
    notifyListeners();
  }

  Future<Duration> _getVideoDuration(File file) async {
    final controller = VideoPlayerController.file(file);
    try {
      await controller.initialize();
      final duration = controller.value.duration;

      // If duration is zero (sometimes happens on some files), throw
      if (duration == Duration.zero) {
        throw Exception("Could not read video duration");
      }

      return duration;
    } finally {
      await controller.dispose();
    }
  }

  // --- Thumbnail Functions ---
  Future<void> pickThumbnail() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    selectedThumbnail = File(img.path);
    notifyListeners();
  }

  void removeThumbnail() {
    selectedThumbnail = null;
    notifyListeners();
  }

  // --- Categories ---
  void toggleCategory(int category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  Future<void> feedPost({required BuildContext context}) async {
    List<String> missingFields = [];

    if (selectedVideo == null) missingFields.add('Video');
    if (selectedThumbnail == null) missingFields.add('Thumbnail');
    if (description.trim().isEmpty) {
      missingFields.add('Description');
    }
    if (selectedCategories.isEmpty) missingFields.add('Category');

    // 🔹 If any fields missing, show single snackbar
    if (missingFields.isNotEmpty) {
      final missing = missingFields.join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill the following fields: $missing'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      feedPostLoading = true;
      notifyListeners();
      final result = await myFeedService.postMyFeed(
        categoryIds: selectedCategories,
        desc: description.trim(),
        image: selectedThumbnail!,
        video: selectedVideo!,
      );
      result.fold(
        (faliure) {
          feedPostLoading = false;
          notifyListeners();
        },
        (success) {
          log('got success feed post');
          feedPostLoading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post successfully added'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              duration: const Duration(seconds: 3),
            ),
          );
       
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => HomeScreen()));
        },
      );
    } catch (e) {
      feedPostLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMyFeeds() async {
    try {
      myFeedLoading = true;
      notifyListeners();
      final result = await myFeedService.getMyFeeds();
      result.fold(
        (failure) {
          myFeedLoading = false;
          notifyListeners();
        },
        (success) {
          myFeeds = success;
          log('getMyFeeds success');
          myFeedLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      myFeedLoading = false;
      notifyListeners();
      log('getMyFeeds ${e.toString()}');
    }
  }
}
