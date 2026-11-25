import 'package:flutter/material.dart';
import '../../contents/widgets/content_video_player.dart';
import '../models/content_detail_model.dart';
import 'detail_ui.dart';

/// YouTube clip shown as a thumbnail; the player only loads once tapped.
class ContentVideoSection extends StatefulWidget {
  final ContentDetailModel item;
  const ContentVideoSection({super.key, required this.item});

  static bool hasVideo(ContentDetailModel item) =>
      item.youtubeUrl != null && item.youtubeUrl!.trim().isNotEmpty;

  @override
  State<ContentVideoSection> createState() => ContentVideoSectionState();
}

class ContentVideoSectionState extends State<ContentVideoSection> {
  bool _playing = false;

  /// Starts playback; used by the cover's "ดูวิดีโอ" button.
  void play() {
    if (!_playing) setState(() => _playing = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!ContentVideoSection.hasVideo(widget.item)) {
      return const SizedBox.shrink();
    }
    final thumb = widget.item.youtubeThumbnail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionTitle(title: 'วิดีโอพาเที่ยว'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _playing
                  ? ContentVideoPlayer(
                      videoUrl: widget.item.youtubeUrl!,
                      autoPlay: true,
                    )
                  : Material(
                      color: Colors.black,
                      child: InkWell(
                        onTap: play,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            DetailImage(
                              url: thumb.isNotEmpty
                                  ? widget.item.youtubeThumbnailHd
                                  : widget.item.coverImageUrl,
                              fallbackUrl: thumb,
                              placeholderIcon: Icons.smart_display_outlined,
                            ),
                            const ColoredBox(color: Color(0x33000000)),
                            Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 36,
                                  color: DetailColors.brand,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
