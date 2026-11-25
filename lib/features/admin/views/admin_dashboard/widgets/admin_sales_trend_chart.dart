import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../models/admin_dashboard_model.dart';

String _formatTrendDate(String raw) {
  if (raw.isEmpty) return '';
  try {
    final parsed = DateTime.parse(raw);
    return '${parsed.day}/${parsed.month}';
  } catch (_) {
    if (raw.contains('T')) {
      final part = raw.split('T').first;
      final parts = part.split('-');
      if (parts.length == 3) {
        final d = int.tryParse(parts[2]) ?? parts[2];
        final m = int.tryParse(parts[1]) ?? parts[1];
        return '$d/$m';
      }
    } else if (raw.contains('-')) {
      final parts = raw.split('-');
      if (parts.length == 3) {
        final d = int.tryParse(parts[2]) ?? parts[2];
        final m = int.tryParse(parts[1]) ?? parts[1];
        return '$d/$m';
      }
    }
    return raw;
  }
}

class AdminSalesTrendChart extends StatefulWidget {
  final List<AdminSalesTrend> data;
  final int selectedDays;
  final ValueChanged<int>? onRangeChanged;

  const AdminSalesTrendChart({
    super.key,
    required this.data,
    this.selectedDays = 7,
    this.onRangeChanged,
  });

  @override
  State<AdminSalesTrendChart> createState() => _AdminSalesTrendChartState();
}

class _AdminSalesTrendChartState extends State<AdminSalesTrendChart> {
  bool _isSalesMetric = true; // true: ยอดขาย (Sales), false: ออเดอร์ (Orders)
  bool _isAreaChart = true; // true: Smooth Area Line, false: Rounded Bars
  late int _selectedDays;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.selectedDays;
  }

  @override
  void didUpdateWidget(covariant AdminSalesTrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDays != widget.selectedDays) {
      setState(() {
        _selectedDays = widget.selectedDays;
        _selectedIndex = null;
      });
    }
  }

  List<AdminSalesTrend> get _chartPoints {
    // 100% Real data from API - No Mock Data!
    if (widget.data.isEmpty) return const [];
    List<AdminSalesTrend> list = List<AdminSalesTrend>.from(widget.data);
    if (list.length > _selectedDays) {
      list = list.sublist(list.length - _selectedDays);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final points = _chartPoints;
    final totalSales = points.fold<double>(0.0, (sum, p) => sum + p.sales);
    final totalOrders = points.fold<int>(0, (sum, p) => sum + p.orders);

    final selectedPoint = points.isEmpty
        ? null
        : (_selectedIndex != null && _selectedIndex! < points.length
            ? points[_selectedIndex!]
            : points.last);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AdminColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Controls (Guaranteed overflow-free)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 3.5,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AdminColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สถิติและแนวโน้มการค้า',
                            style: GoogleFonts.krub(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _isSalesMetric
                                ? 'รวม ฿${totalSales.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} ($_selectedDays วันล่าสุด)'
                                : 'รวม $totalOrders ออเดอร์ ($_selectedDays วันล่าสุด)',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AdminColors.secondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Metric Switch (฿ vs 📦)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AdminColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AdminColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _metricChip(
                      label: 'ยอดขาย',
                      isSelected: _isSalesMetric,
                      onTap: () => setState(() => _isSalesMetric = true),
                    ),
                    _metricChip(
                      label: 'คำสั่งซื้อ',
                      isSelected: !_isSalesMetric,
                      onTap: () => setState(() => _isSalesMetric = false),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Active Touch Tooltip Bar (Real data status)
          if (selectedPoint != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AdminColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AdminColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Text(
                    'วันที่: ${_formatTrendDate(selectedPoint.date)}',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            _isSalesMetric
                                ? '฿${selectedPoint.sales.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
                                : '${selectedPoint.orders} ออเดอร์',
                            style: GoogleFonts.krub(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isSalesMetric
                              ? '(${selectedPoint.orders} ออเดอร์)'
                              : '(฿${selectedPoint.sales.toStringAsFixed(0)})',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Text(
                  'ไม่มีรายการยอดขายในช่วงเวลานี้ (ข้อมูลจริงจากระบบ)',
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AdminColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Interactive Chart Canvas (Handles 0, 1, or multiple real points)
          SizedBox(
            width: double.infinity,
            height: 175.0,
            child: points.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ยังไม่มีประวัติยอดขายหรือคำสั่งซื้อ',
                          style: GoogleFonts.krub(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ระบบจะแสดงเส้นกราฟเมื่อมีคำสั่งซื้อจริงเกิดขึ้น',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final chartWidth = constraints.maxWidth;
                      const chartHeight = 175.0;

                      return GestureDetector(
                        onPanDown: (details) => _handleTouch(details.localPosition, chartWidth, points.length),
                        onPanUpdate: (details) => _handleTouch(details.localPosition, chartWidth, points.length),
                        onTapDown: (details) => _handleTouch(details.localPosition, chartWidth, points.length),
                        child: SizedBox(
                          width: chartWidth,
                          height: chartHeight,
                          child: CustomPaint(
                            size: Size(chartWidth, chartHeight),
                            painter: _InteractiveChartPainter(
                              points: points,
                              isSalesMetric: _isSalesMetric,
                              isAreaChart: _isAreaChart,
                              selectedIndex: _selectedIndex,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 10),

          // Bottom Controls: Timeframe Range (7d default) + Chart Type Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timeframe Range (7 วัน / 14 วัน / 30 วัน)
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _rangeChip('7 วัน', 7),
                    _rangeChip('14 วัน', 14),
                    _rangeChip('30 วัน', 30),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _chartTypeToggle(
                    label: 'เส้น',
                    isSelected: _isAreaChart,
                    onTap: () => setState(() => _isAreaChart = true),
                  ),
                  const SizedBox(width: 6),
                  _chartTypeToggle(
                    label: 'แท่ง',
                    isSelected: !_isAreaChart,
                    onTap: () => setState(() => _isAreaChart = false),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleTouch(Offset localPosition, double chartWidth, int count) {
    if (count <= 1) {
      if (_selectedIndex != 0) {
        setState(() => _selectedIndex = 0);
      }
      return;
    }
    const paddingH = 16.0;
    final usableWidth = chartWidth - (paddingH * 2);
    final clampedX = (localPosition.dx - paddingH).clamp(0.0, usableWidth);
    final step = usableWidth / (count - 1);
    final index = (clampedX / step).round().clamp(0, count - 1);

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _rangeChip(String label, int days) {
    final isSelected = _selectedDays == days;
    return GestureDetector(
      onTap: () {
        if (_selectedDays != days) {
          setState(() {
            _selectedDays = days;
            _selectedIndex = null;
          });
          widget.onRangeChanged?.call(days);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AdminColors.primaryDark.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AdminColors.primary : AdminColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _metricChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AdminColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AdminColors.primary.withValues(alpha: 0.28),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : AdminColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _chartTypeToggle({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AdminColors.primary : AdminColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AdminColors.primary : AdminColors.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AdminColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _InteractiveChartPainter extends CustomPainter {
  final List<AdminSalesTrend> points;
  final bool isSalesMetric;
  final bool isAreaChart;
  final int? selectedIndex;

  _InteractiveChartPainter({
    required this.points,
    required this.isSalesMetric,
    required this.isAreaChart,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const padLeft = 16.0;
    const padRight = 16.0;
    const padTop = 16.0;
    const padBottom = 26.0;

    final drawWidth = size.width - padLeft - padRight;
    final drawHeight = size.height - padTop - padBottom;

    // Calculate max value
    double maxVal = 0.0;
    for (final p in points) {
      final v = isSalesMetric ? p.sales : p.orders.toDouble();
      if (v > maxVal) maxVal = v;
    }
    if (maxVal <= 0) maxVal = 100.0;
    maxVal *= 1.15; // 15% headroom

    // Draw grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 3; i++) {
      final y = padTop + (drawHeight * (i / 3));
      canvas.drawLine(Offset(padLeft, y), Offset(size.width - padRight, y), gridPaint);
    }

    final n = points.length;
    final stepX = n > 1 ? drawWidth / (n - 1) : 0.0;

    final offsets = <Offset>[];
    for (int i = 0; i < n; i++) {
      final v = isSalesMetric ? points[i].sales : points[i].orders.toDouble();
      final x = n > 1 ? padLeft + (i * stepX) : padLeft + (drawWidth / 2);
      final y = padTop + drawHeight - ((v / maxVal) * drawHeight);
      offsets.add(Offset(x, y));
    }

    if (isAreaChart) {
      if (offsets.length == 1) {
        // Single point mode
        final p = offsets.first;
        final singleDot = Paint()..color = AdminColors.primary;
        canvas.drawCircle(p, 5, singleDot);
      } else {
        // Area Path with Gradient
        final areaPath = Path()..moveTo(offsets.first.dx, offsets.first.dy);
        final linePath = Path()..moveTo(offsets.first.dx, offsets.first.dy);

        for (int i = 0; i < offsets.length - 1; i++) {
          final p0 = offsets[i];
          final p1 = offsets[i + 1];
          final midX = (p0.dx + p1.dx) / 2;

          linePath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
          areaPath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
        }

        areaPath.lineTo(offsets.last.dx, padTop + drawHeight);
        areaPath.lineTo(offsets.first.dx, padTop + drawHeight);
        areaPath.close();

        // Draw Gradient fill (Emerald River Mint)
        final fillPaint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AdminColors.secondary.withValues(alpha: 0.25),
              AdminColors.secondary.withValues(alpha: 0.01),
            ],
          ).createShader(Rect.fromLTWH(padLeft, padTop, drawWidth, drawHeight));

        canvas.drawPath(areaPath, fillPaint);

        // Draw Line stroke
        final strokePaint = Paint()
          ..shader = LinearGradient(
            colors: [
              AdminColors.primary,   // Forest Teal
              AdminColors.secondary, // Vibrant Mint Teal
            ],
          ).createShader(Rect.fromLTWH(padLeft, padTop, drawWidth, drawHeight))
          ..strokeWidth = 2.8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        canvas.drawPath(linePath, strokePaint);
      }
    } else {
      // Bar Chart mode
      final barWidth = n > 1 ? math.min(18.0, stepX * 0.55) : 22.0;
      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AdminColors.secondary,
            AdminColors.primary,
          ],
        ).createShader(Rect.fromLTWH(padLeft, padTop, drawWidth, drawHeight));

      for (int i = 0; i < offsets.length; i++) {
        final p = offsets[i];
        final r = Rect.fromLTWH(
          p.dx - (barWidth / 2),
          p.dy,
          barWidth,
          (padTop + drawHeight) - p.dy,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(6)),
          barPaint,
        );
      }
    }

    // Draw Selected Point / Active Indicator
    final activeIdx = selectedIndex ?? (points.length - 1);
    if (activeIdx < offsets.length) {
      final activeOffset = offsets[activeIdx];

      // Vertical guide line
      final guidePaint = Paint()
        ..color = AdminColors.secondary.withValues(alpha: 0.4)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(activeOffset.dx, padTop),
        Offset(activeOffset.dx, padTop + drawHeight),
        guidePaint,
      );

      // Glowing dot
      final glowPaint = Paint()
        ..color = AdminColors.secondary.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(activeOffset, 9, glowPaint);

      final outerDot = Paint()..color = AdminColors.primary;
      canvas.drawCircle(activeOffset, 5, outerDot);

      final innerDot = Paint()..color = Colors.white;
      canvas.drawCircle(activeOffset, 2.5, innerDot);
    }

    // Draw X-axis Date Labels
    for (int i = 0; i < points.length; i++) {
      final x = n > 1 ? padLeft + (i * stepX) : padLeft + (drawWidth / 2);
      final label = _formatTrendDate(points[i].date);

      final textSpan = TextSpan(
        text: label,
        style: GoogleFonts.krub(
          fontSize: 9.5,
          fontWeight: i == activeIdx ? FontWeight.bold : FontWeight.w500,
          color: i == activeIdx ? AdminColors.primary : AdminColors.textSecondary,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x - (textPainter.width / 2), size.height - padBottom + 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _InteractiveChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.isSalesMetric != isSalesMetric ||
        oldDelegate.isAreaChart != isAreaChart ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
