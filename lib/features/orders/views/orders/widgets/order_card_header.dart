import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/order_model.dart';
import '../../order_date_format.dart';

class OrderCardHeader extends StatelessWidget {
  const OrderCardHeader({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final status = _statusFor(order.orderStatus);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 18,
                  color: Color(0xFFD96C2C),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  order.shopName ?? 'ร้านค้าชุมชนกาญจนบุรี',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF332820),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: status.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(status.icon, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            order.statusLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.krub(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE8D9C9)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'หมายเลข: #${order.orderNumber ?? order.id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: const Color(0xFF786B62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (order.createdAt != null) ...[
                const SizedBox(width: 8),
                Text(
                  formatOrderDate(order.createdAt!),
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    color: const Color(0xFF786B62),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE8D9C9)),
      ],
    );
  }
}

class _StatusPresentation {
  const _StatusPresentation({required this.background, required this.icon});

  final Color background;
  final IconData icon;
}

_StatusPresentation _statusFor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return const _StatusPresentation(
        background: Color(0xFFE76F51),
        icon: Icons.hourglass_empty_rounded,
      );
    case 'paid':
    case 'processing':
      return const _StatusPresentation(
        background: Color(0xFF2A9D8F),
        icon: Icons.inventory_2_outlined,
      );
    case 'shipped':
      return const _StatusPresentation(
        background: Color(0xFF2980B9),
        icon: Icons.local_shipping_outlined,
      );
    case 'completed':
      return const _StatusPresentation(
        background: Color(0xFF059669),
        icon: Icons.check_circle_outline_rounded,
      );
    case 'cancelled':
      return const _StatusPresentation(
        background: Color(0xFF786B62),
        icon: Icons.cancel_outlined,
      );
    case 'expired':
      return const _StatusPresentation(
        background: Color(0xFF786B62),
        icon: Icons.timer_off_rounded,
      );
    default:
      return const _StatusPresentation(
        background: Color(0xFFD96C2C),
        icon: Icons.info_outline_rounded,
      );
  }
}
