import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_media/application/controller/home_screen_feed_controller.dart';
import 'package:video_player_media/application/controller/my_feed_controller.dart';
import 'package:video_player_media/utils/custom_app_bar.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyFeedController(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                CustomAppBar(title: 'My Feed', fromAddFeed: true,),
                SizedBox(height: 40),
                _VideoPicker(),
                SizedBox(height: 20),
                _ThumbnailPicker(),
                SizedBox(height: 20),
                _DescriptionField(),
                SizedBox(height: 24),
                _CategoriesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _VideoPicker extends StatelessWidget {
  const _VideoPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyFeedController>();
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(10),
        color: Colors.grey.shade700,
        strokeWidth: 2,
        dashPattern: [15, 10],
      ),
      child: Container(
        height: 260,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: controller.selectedVideo == null
            ? InkWell(
                onTap: controller.pickVideo,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/Group 2364.png'),
                      SizedBox(height: 20),
                      Text(
                        'Select a video from Gallery',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // color: Colors.grey.shade900,
                        // borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.insert_drive_file,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              controller.selectedVideo!.path.split('/').last,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: controller.removeVideo,
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ThumbnailPicker extends StatelessWidget {
  const _ThumbnailPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyFeedController>();
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(10),
        color: Colors.grey.shade700,
        strokeWidth: 2,
        dashPattern: [15, 10],
      ),
      child: Container(
        height: 130,
        child: controller.selectedThumbnail == null
            ? InkWell(
                onTap: controller.pickThumbnail,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/Group 2361.png'),
                      SizedBox(width: 40),
                      Text(
                        'Add a Thumbnail',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(controller.selectedThumbnail!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: controller.removeThumbnail,
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyFeedController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Write something...',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            filled: true,
            fillColor: const Color.fromARGB(255, 14, 13, 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (val) => controller.setDescription(val),
        ),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyFeedController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories This Project',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade500,
                  size: 12,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Consumer<HomeScreenFeedController>(
          builder: (context, ref, child) {
            if (ref.categories.categories?.isEmpty ?? false) {
              return Text('there is no data');
            }
            if (ref.categoryLoading) {
              return CircularProgressIndicator();
            } else {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ref.categories.categories!.map((category) {
                  final isSelected = controller.selectedCategories.contains(
                    category.id,
                  );
                  return GestureDetector(
                    onTap: () => controller.toggleCategory(category.id ?? 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.redAccent
                              : Colors.grey.shade800,
                        ),
                      ),
                      child: Text(
                        category.title ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }
}
