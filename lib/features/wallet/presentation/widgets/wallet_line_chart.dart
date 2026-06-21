import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';

class WalletLineChart extends StatelessWidget {
  const WalletLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF7ED), // orange50
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(ImagePath.iconBarChartSvg, width: 24, height: 24),
                  ),
                  const SizedBox(width: 8),
                  const PrimaryText('Tiền vào theo ngày', fontWeight: FontWeight.bold),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.neutral8,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const PrimaryText('7 ngày qua', size: 12),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLineChart(),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    final days = [
      '05/05',
      '06/05',
      '07/05',
      '08/05',
      '09/05',
      '10/05',
      '11/05',
    ];

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 3,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(color: AppColors.neutral8, strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  if (value % 1 != 0 || value < 0) {
                    return const SizedBox();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: PrimaryText(
                      value == 0 ? '0 đ' : '${value.toInt()}.0M đ',
                      style: const TextStyle(fontSize: 10, color: AppColors.neutral4),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= days.length || value % 1 != 0 || value < 0) {
                    return const SizedBox();
                  }
                  final isLast = value.toInt() == 6;
                  return SideTitleWidget(
                    meta: meta,
                    child: PrimaryText(
                      days[value.toInt()],
                      style: TextStyle(
                        fontSize: 10,
                        color: isLast ? const Color(0xFFEA580C) : AppColors.neutral4,
                        fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${(spot.y * 1000000).toInt() == 2560000 ? "2.560.000" : (spot.y * 1000000).toInt()}đ',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 0),
                FlSpot(1, 0.7),
                FlSpot(2, 1.4),
                FlSpot(3, 1.9),
                FlSpot(4, 1.6),
                FlSpot(5, 2.1),
                FlSpot(6, 2.56),
              ],
              color: const Color(0xFFF97316),
              isCurved: true,
              curveSmoothness: 0.35,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: const Color(0xFFF97316),
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFF97316).withValues(alpha: 0.3),
                    const Color(0xFFF97316).withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


