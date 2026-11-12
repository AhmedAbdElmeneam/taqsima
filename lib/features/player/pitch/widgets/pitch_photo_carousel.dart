part of 'pitch_details_widgets_imports.dart';

/// Swipeable photos with page dots.
class PitchPhotoCarousel extends StatefulWidget {
  const PitchPhotoCarousel({super.key, required this.photos});
  final List<String> photos;

  @override
  State<PitchPhotoCarousel> createState() => _PitchPhotoCarouselState();
}

class _PitchPhotoCarouselState extends State<PitchPhotoCarousel> {
  final _index = ValueNotifier(0);

  @override
  void dispose() {
    _index.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos.isEmpty ? const ['empty'] : widget.photos;
    return Stack(
      children: [
        PageView.builder(
          itemCount: photos.length,
          onPageChanged: (i) => _index.value = i,
          itemBuilder: (_, i) => PitchImage(photoKey: photos[i]),
        ),
        Positioned(
          bottom: 14,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<int>(
            valueListenable: _index,
            builder: (context, index, _) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < photos.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == index ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
