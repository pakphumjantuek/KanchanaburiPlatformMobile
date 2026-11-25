import 'package:flutter/material.dart';
import 'home_colors.dart';

/// Placeholder layout shown while the home data is loading.
class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton({super.key});

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<HomeSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(
        begin: 0.45,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut)),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.paddingOf(context).top + 230,
              decoration: const BoxDecoration(
                color: HomeColors.darkHeader,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: _Box(height: 220, radius: 22),
            ),
            const SizedBox(height: 28),
            _section(cardWidth: 230, cardHeight: 260),
            const SizedBox(height: 28),
            _section(cardWidth: 180, cardHeight: 230),
          ],
        ),
      ),
    );
  }

  Widget _section({required double cardWidth, required double cardHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Box(width: 180, height: 20, radius: 6),
              SizedBox(height: 8),
              _Box(width: 240, height: 13, radius: 6),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (_, _) =>
                _Box(width: cardWidth, height: cardHeight, radius: 20),
          ),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _Box({this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFDCD3C9),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
