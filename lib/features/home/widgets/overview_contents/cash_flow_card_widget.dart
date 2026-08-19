import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/dummy_data/dummy_data_list.dart';
import 'package:custom_books/features/home/models/cash_flow_point_model.dart';
import 'package:custom_books/features/home/widgets/card_tile_widget.dart';
import 'package:flutter/material.dart';

class CashFlowCardWidget extends StatefulWidget {
  const CashFlowCardWidget({super.key});

  @override
  State<CashFlowCardWidget> createState() => _CashFlowCardWidgetState();
}

class _CashFlowCardWidgetState extends State<CashFlowCardWidget> {
  String _selectedPeriod = 'This Fiscal Year';
  int? _tappedIndex;

  void _showPeriodSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CashFlowPeriodSheet(
        selectedPeriod: _selectedPeriod,
        onSelected: (period) {
          setState(() => _selectedPeriod = period);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onChartTap(int index) {
    setState(() {
      // Toggle: tap same index again to dismiss
      _tappedIndex = (_tappedIndex == index) ? null : index;
    });
  }

  void _dismissTooltip() {
    if (_tappedIndex != null) {
      setState(() => _tappedIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalIncoming = cashFlowData.fold<double>(0, (p, e) => p + e.income);
    final totalOutgoing = cashFlowData.fold<double>(
      0,
      (p, e) => p + e.outgoing,
    );
    final last = cashFlowData.last;
    final first = cashFlowData.first;

    return GestureDetector(
      onTap: _dismissTooltip,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header with title and period dropdown ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardTitle(title: 'Cash Flow', icon: Icons.show_chart_rounded),
                GestureDetector(
                  onTap: _showPeriodSheet,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: Dimensions.height10 * 0.4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedPeriod,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.72,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textSecondary,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10 * 0.4),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: Dimensions.iconSize16,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            // ── Chart area with overlay tooltip ──
            SizedBox(
              height: Dimensions.screenHeight / 3.5,
              width: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ── The chart ──
                      Positioned.fill(
                        child: GestureDetector(
                          onTapDown: (details) {
                            final stepX =
                                constraints.maxWidth /
                                (cashFlowData.length - 1);
                            final index = (details.localPosition.dx / stepX)
                                .round()
                                .clamp(0, cashFlowData.length - 1);
                            _onChartTap(index);
                          },
                          child: CustomPaint(
                            size: Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                            painter: _InteractiveAreaChartPainter(
                              data: cashFlowData,
                              color: AppColors.accent,
                              highlightIndex: _tappedIndex,
                              gridColor: context.colors.border,
                              labelColor: context.colors.textTertiary,
                            ),
                          ),
                        ),
                      ),

                      // ── Floating tooltip over the chart ──
                      if (_tappedIndex != null)
                        _buildTooltipOverlay(constraints),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: Dimensions.height10),

            // ── Month labels ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: cashFlowData
                  .map(
                    (e) => Text(
                      e.month,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.6,
                        color: context.colors.textTertiary,
                      ),
                    ),
                  )
                  .toList(),
            ),

            Divider(height: Dimensions.height30, color: context.colors.border),

            // ── Summary stats ──
            _statLine(
              context,
              'Cash as on 01 Jan 2026',
              'AED${first.opening.toStringAsFixed(2)}',
              context.colors.textPrimary,
              bold: true,
            ),
            _statLine(
              context,
              '+ Incoming',
              'AED${totalIncoming.toStringAsFixed(2)}',
              AppColors.ok,
            ),
            _statLine(
              context,
              '- Outgoing',
              'AED${totalOutgoing.toStringAsFixed(2)}',
              AppColors.warn,
            ),
            _statLine(
              context,
              '= Ending Balance',
              'AED${last.ending.toStringAsFixed(2)}',
              AppColors.accent,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the floating tooltip positioned over the chart at the tapped point.
  Widget _buildTooltipOverlay(BoxConstraints constraints) {
    final point = cashFlowData[_tappedIndex!];
    final values = cashFlowData.map((e) => e.ending).toList();
    final maxVal = values
        .reduce((a, b) => a > b ? a : b)
        .clamp(1.0, double.infinity);
    final stepX = constraints.maxWidth / (cashFlowData.length - 1);
    final tooltipWidth = constraints.maxWidth * 0.62;
    final xCenter = _tappedIndex! * stepX;

    // Y position of the tapped data point on the chart
    final yPoint =
        constraints.maxHeight -
        (values[_tappedIndex!] / maxVal) * constraints.maxHeight;

    // Position tooltip so it doesn't overflow left/right
    double left = xCenter - tooltipWidth / 2;
    if (left < 0) left = 0;
    if (left + tooltipWidth > constraints.maxWidth) {
      left = constraints.maxWidth - tooltipWidth;
    }

    // Position tooltip above the tapped point; if too high, place below
    const tooltipEstimatedHeight = 120.0;
    double top = yPoint - tooltipEstimatedHeight - 12;
    if (top < 0) top = yPoint + 16;

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: tooltipWidth,
        padding: EdgeInsets.all(Dimensions.width10 * 1.2),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Month title
            Text(
              '${point.month} 2026',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10 * 0.6),

            // Opening Bal.
            _tooltipRow(
              'Opening Bal.',
              'AED${_formatNumber(point.opening)}',
              context.colors.textSecondary,
            ),
            SizedBox(height: Dimensions.height10 * 0.4),

            // Income
            _tooltipRow(
              'Income',
              'AED${_formatNumber(point.income)}',
              AppColors.ok,
            ),
            SizedBox(height: Dimensions.height10 * 0.4),

            // Outgoing
            _tooltipRow(
              'Outgoing',
              'AED${_formatNumber(point.outgoing)}',
              AppColors.warn,
            ),
            SizedBox(height: Dimensions.height10 * 0.4),

            // Ending Bal.
            _tooltipRow(
              'Ending Bal.',
              'AED${_formatNumber(point.ending)}',
              AppColors.accent,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tooltipRow(
    String label,
    String value,
    Color labelColor, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.78,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.78,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _statLine(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool bold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: bold ? color : context.colors.textSecondary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000) {
      return value
          .toStringAsFixed(2)
          .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
    }
    return value.toStringAsFixed(2);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ── Period Selection Bottom Sheet ─────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class _CashFlowPeriodSheet extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onSelected;

  const _CashFlowPeriodSheet({
    required this.selectedPeriod,
    required this.onSelected,
  });

  static const _periods = [
    'This Fiscal Year',
    'Previous Fiscal Year',
    'Last 12 Months',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20 * 1.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──
          Center(
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height15),
              width: Dimensions.width20 * 2,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.textTertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20),

          // ── Options list ──
          ...List.generate(_periods.length, (i) {
            final period = _periods[i];
            final isSelected = period == selectedPeriod;
            return GestureDetector(
              onTap: () => onSelected(period),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i < _periods.length - 1
                          ? context.colors.border.withValues(alpha: 0.5)
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 1.1,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ── Interactive Area Chart Painter ───────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class _InteractiveAreaChartPainter extends CustomPainter {
  final List<CashFlowPoint> data;
  final Color color;
  final int? highlightIndex;
  final Color gridColor;
  final Color labelColor;

  _InteractiveAreaChartPainter({
    required this.data,
    required this.color,
    this.highlightIndex,
    required this.gridColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final values = data.map((e) => e.ending).toList();
    final maxVal = values
        .reduce((a, b) => a > b ? a : b)
        .clamp(1.0, double.infinity);
    final stepX = size.width / (values.length - 1);

    // ── Draw horizontal grid lines ──
    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.4)
      ..strokeWidth = 0.5;

    const gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // ── Draw Y-axis labels ──
    final labelStyle = TextStyle(color: labelColor, fontSize: 10);
    for (int i = 0; i <= gridLines; i++) {
      final val = maxVal * (gridLines - i) / gridLines;
      final label = _shortNumber(val);
      final tp = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final y = size.height * i / gridLines - tp.height / 2;
      tp.paint(
        canvas,
        Offset(-tp.width - 4, y.clamp(0, size.height - tp.height)),
      );
    }

    // ── Build line path ──
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxVal) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // ── Draw dots ──
    final dotPaint = Paint()..color = color;
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxVal) * size.height;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }

    // ── Highlight tapped index with vertical line ──
    if (highlightIndex != null &&
        highlightIndex! >= 0 &&
        highlightIndex! < values.length) {
      final hx = highlightIndex! * stepX;
      final vertPaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(hx, 0), Offset(hx, size.height), vertPaint);

      // Highlight dot
      final hy = size.height - (values[highlightIndex!] / maxVal) * size.height;
      canvas.drawCircle(
        Offset(hx, hy),
        6,
        Paint()..color = color.withValues(alpha: 0.2),
      );
      canvas.drawCircle(Offset(hx, hy), 4, Paint()..color = color);
      canvas.drawCircle(Offset(hx, hy), 2, Paint()..color = Colors.white);
    }
  }

  String _shortNumber(double val) {
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(0)}K';
    return val.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(covariant _InteractiveAreaChartPainter oldDelegate) {
    return oldDelegate.highlightIndex != highlightIndex;
  }
}
