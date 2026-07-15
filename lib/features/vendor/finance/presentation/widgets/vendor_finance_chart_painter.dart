import 'dart:math' as math;

import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';

enum VendorFinanceChartMetric {
  cod,
  deliveryFee;

  Color get color {
    return switch (this) {
      VendorFinanceChartMetric.cod => AppColors.green600,
      VendorFinanceChartMetric.deliveryFee => AppColors.primary,
    };
  }

  int valueOf(DailyBreakdownEntity item) {
    return switch (this) {
      VendorFinanceChartMetric.cod => item.codCollected ?? 0,
      VendorFinanceChartMetric.deliveryFee => item.deliveryFee ?? 0,
    };
  }
}

class VendorFinanceChartPainter extends CustomPainter {
  VendorFinanceChartPainter({required this.items, required this.metric});

  static const double chartHeight = 156;
  static const int _gridLineCount = 4;
  static const double _leftPadding = 46;
  static const double _rightPadding = 12;
  static const double _topPadding = 12;
  static const double _bottomPadding = 34;
  static const double _labelMinSpacing = 48;

  final List<DailyBreakdownEntity> items;
  final VendorFinanceChartMetric metric;

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final gridPaint = Paint()
      ..color = AppColors.grey200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final linePaint = _linePaint(metric.color);
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotPaint = Paint()
      ..color = metric.color
      ..style = PaintingStyle.fill;

    final chartWidth = size.width - _leftPadding - _rightPadding;
    final chartHeight = size.height - _topPadding - _bottomPadding;
    if (chartWidth <= 0 || chartHeight <= 0) return;

    final maxAmount = _niceAxisMax(_maxAmount());

    _drawGridAndYAxis(canvas, size, chartHeight, maxAmount, gridPaint);

    final path = Path();
    final points = <Offset>[];

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final x = _xPosition(index, chartWidth);
      final y = _yPosition(metric.valueOf(item), chartHeight, maxAmount);
      final point = Offset(x, y);

      points.add(point);
      _extendPath(path, point, index);
      _drawXAxisLabel(canvas, item.date, index, chartWidth, chartHeight);
    }

    if (items.length > 1) {
      canvas.drawPath(path, linePaint);
    }

    for (final point in points) {
      _drawCircleMarker(canvas, point, dotBorderPaint, dotPaint);
    }
  }

  Paint _linePaint(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  int _maxAmount() {
    var maxAmount = 0;
    for (final item in items) {
      maxAmount = math.max(maxAmount, metric.valueOf(item));
    }
    return maxAmount;
  }

  double _niceAxisMax(int amount) {
    if (amount <= 0) return 1;

    final rawStep = amount / _gridLineCount;
    final magnitude = math.pow(10, rawStep.toStringAsFixed(0).length - 1);
    final normalized = rawStep / magnitude;
    final niceStep = switch (normalized) {
      <= 1 => 1,
      <= 2 => 2,
      <= 5 => 5,
      _ => 10,
    };

    return (niceStep * magnitude * _gridLineCount).toDouble();
  }

  void _drawGridAndYAxis(
    Canvas canvas,
    Size size,
    double chartHeight,
    double maxAmount,
    Paint gridPaint,
  ) {
    for (var index = 0; index <= _gridLineCount; index++) {
      final y = _topPadding + chartHeight * (1 - index / _gridLineCount);
      canvas.drawLine(
        Offset(_leftPadding, y),
        Offset(size.width - _rightPadding, y),
        gridPaint,
      );

      final amount = maxAmount * (index / _gridLineCount);
      final labelPainter = _textPainter(_formatAmountLabel(amount));
      labelPainter.paint(
        canvas,
        Offset(
          _leftPadding - labelPainter.width - AppDimensions.xxSmallSpacing,
          y - labelPainter.height / 2,
        ),
      );
    }
  }

  double _xPosition(int index, double chartWidth) {
    if (items.length == 1) return _leftPadding + chartWidth / 2;
    return _leftPadding + index * (chartWidth / (items.length - 1));
  }

  double _yPosition(int amount, double chartHeight, double maxAmount) {
    final ratio = (amount / maxAmount).clamp(0, 1).toDouble();
    return _topPadding + chartHeight * (1 - ratio);
  }

  void _extendPath(Path path, Offset point, int index) {
    if (index == 0) {
      path.moveTo(point.dx, point.dy);
      return;
    }
    path.lineTo(point.dx, point.dy);
  }

  void _drawXAxisLabel(
    Canvas canvas,
    String? rawDate,
    int index,
    double chartWidth,
    double chartHeight,
  ) {
    if (!_shouldDrawDateLabel(index, chartWidth)) return;

    final labelPainter = _textPainter(_formatDateLabel(rawDate));
    final x = _xPosition(index, chartWidth);
    final left = (x - labelPainter.width / 2).clamp(
      _leftPadding - AppDimensions.xSmallSpacing,
      _leftPadding + chartWidth - labelPainter.width,
    );

    labelPainter.paint(
      canvas,
      Offset(
        left.toDouble(),
        _topPadding + chartHeight + AppDimensions.xSmallSpacing,
      ),
    );
  }

  bool _shouldDrawDateLabel(int index, double chartWidth) {
    if (items.length <= 1) return true;
    if (index == 0 || index == items.length - 1) return true;

    final maxLabelCount = math.max(2, chartWidth ~/ _labelMinSpacing);
    final interval = math.max(1, (items.length / maxLabelCount).ceil());
    return index % interval == 0;
  }

  TextPainter _textPainter(String text) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.bodyXXSmall.copyWith(
          color: AppColors.grey500,
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  String _formatAmountLabel(double value) {
    if (value <= 0) return '0';
    if (value >= 1000000) {
      final millions = value / 1000000;
      return '${millions.toStringAsFixed(millions % 1 == 0 ? 0 : 1)}M';
    }
    if (value >= 1000) {
      final thousands = value / 1000;
      return '${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _formatDateLabel(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';

    final date = DateTime.tryParse(rawDate);
    if (date == null) return rawDate;

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  void _drawCircleMarker(
    Canvas canvas,
    Offset point,
    Paint borderPaint,
    Paint fillPaint,
  ) {
    canvas.drawCircle(point, 4.5, borderPaint);
    canvas.drawCircle(point, 3, fillPaint);
  }

  @override
  bool shouldRepaint(covariant VendorFinanceChartPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.metric != metric;
  }
}
