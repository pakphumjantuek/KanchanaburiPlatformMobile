import 'package:flutter/material.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';

/// Sticky bottom bar: call the shop and get directions.
class ShopDetailBottomBar extends StatelessWidget {
  final VoidCallback? onCall;
  final VoidCallback onDirections;

  const ShopDetailBottomBar({
    super.key,
    required this.onCall,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: DetailColors.line)),
      ),
      child: Row(
        children: [
          if (onCall != null) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCall,
                style: OutlinedButton.styleFrom(
                  foregroundColor: DetailColors.ink,
                  side: const BorderSide(color: DetailColors.line, width: 1.5),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.call_outlined, size: 20),
                label: const Text(
                  'โทรหาร้าน',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: FilledButton.icon(
              onPressed: onDirections,
              style: FilledButton.styleFrom(
                backgroundColor: DetailColors.brand,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.directions_rounded, size: 21),
              label: const Text(
                'นำทางไปร้าน',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
