import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import 'pitch_image.dart';

/// Opens [photos] full screen at [initialIndex]: swipe sideways between
/// photos, pinch to zoom, tap a thumbnail to jump.
Future<void> showPhotoGallery(BuildContext context, List<String> photos,
    {int initialIndex = 0}) {
  if (photos.isEmpty) return Future.value();
  return Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
    opaque: false,
    barrierColor: Colors.black,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, __, ___) =>
        PhotoGallery(photos: photos, initialIndex: initialIndex),
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  ));
}

class PhotoGallery extends StatefulWidget {
  const PhotoGallery(
      {super.key, required this.photos, required this.initialIndex});

  final List<String> photos;
  final int initialIndex;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  late final _pages = PageController(initialPage: widget.initialIndex);
  late final _index = ValueNotifier(widget.initialIndex);

  @override
  void dispose() {
    _pages.dispose();
    _index.dispose();
    super.dispose();
  }

  void _jump(int i) => _pages.animateToPage(i,
      duration: const Duration(milliseconds: 250), curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos;
    final t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Counter + close.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    tooltip: S.close,
                    color: Colors.white,
                    icon: const Icon(AppIcons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<int>(
                    valueListenable: _index,
                    builder: (_, i, __) => Text(
                      S.photoCounter(i + 1, photos.length),
                      style: t.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: photos.length,
                onPageChanged: (i) => _index.value = i,
                itemBuilder: (_, i) => InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: PitchImage(
                          photoKey: photos[i], fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
            if (photos.length > 1)
              SizedBox(
                height: 76,
                child: ValueListenableBuilder<int>(
                  valueListenable: _index,
                  builder: (_, current, __) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => _jump(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 60,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm + 2),
                          border: Border.all(
                            color: i == current
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Opacity(
                          opacity: i == current ? 1 : .55,
                          child: PitchThumb(photoKey: photos[i], size: 52),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal strip of photo thumbnails; tapping one opens the gallery.
class PhotoStrip extends StatelessWidget {
  const PhotoStrip({super.key, required this.photos, this.size = 92});

  final List<String> photos;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => showPhotoGallery(context, photos, initialIndex: i),
          child: SizedBox(
            width: size * 4 / 3,
            child: PitchImage(
              photoKey: photos[i],
              height: size,
              cacheWidth: (size * 4).round(),
              borderRadius: BorderRadius.circular(AppSpacing.radius),
            ),
          ),
        ),
      ),
    );
  }
}
