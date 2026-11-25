import 'package:flutter/material.dart';

import '../../../models/order_model.dart';
import 'order_card_actions.dart';
import 'order_card_header.dart';
import 'order_card_items.dart';
import 'order_card_total.dart';
import 'order_payment_expiry_notice.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderCardHeader(order: order),
          if (order.isAwaitingPayment || order.isPaymentExpired) ...[
            OrderPaymentExpiryNotice(order: order),
            const Divider(height: 1, color: Color(0xFFE8D9C9)),
          ],
          OrderCardItems(order: order),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          OrderCardTotal(order: order),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          OrderCardActions(order: order),
        ],
      ),
    );
  }
}
