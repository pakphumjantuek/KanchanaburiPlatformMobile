import 'package:flutter/material.dart';

/// Network image that shows [placeholder] while loading or on error,
/// and fades in once the first frame is ready.
class HomeNetworkImage extends StatelessWidget {
  final String url;
  final Widget placeholder;

  const HomeNetworkImage({
    super.key,
    required this.url,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return Stack(
          fit: StackFit.expand,
          children: [
            placeholder,
            AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: child,
            ),
          ],
        );
      },
    );
  }
}
