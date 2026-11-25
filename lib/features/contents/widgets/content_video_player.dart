import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;

  const ContentVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
  });

  @override
  State<ContentVideoPlayer> createState() => _ContentVideoPlayerState();
}

class _ContentVideoPlayerState extends State<ContentVideoPlayer> {
  YoutubePlayerController? _controller;
  String? _videoId;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    final id = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (id != null && id.isNotEmpty) {
      _videoId = id;
      _controller = YoutubePlayerController(
        initialVideoId: id,
        flags: YoutubePlayerFlags(
          autoPlay: widget.autoPlay,
          mute: false,
          enableCaption: true,
          isLive: false,
          forceHD: false,
        ),
      );
    } else {
      _hasError = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _openInYouTube() async {
    final url = widget.videoUrl.startsWith('http')
        ? widget.videoUrl
        : 'https://www.youtube.com/watch?v=$_videoId';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || _controller == null) {
      return Container(
        color: const Color(0xFF1E1E1E),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.video_library, color: Colors.white70, size: 44),
              const SizedBox(height: 8),
              const Text(
                'ไม่สามารถเล่นวิดีโอนี้ในแอปได้',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _openInYouTube,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text(
                  'เปิดดูบน YouTube',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
      ),
      builder: (context, player) {
        return Stack(
          children: [
            Positioned.fill(child: player),
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _openInYouTube,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_new, size: 13, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'แอป YouTube',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
