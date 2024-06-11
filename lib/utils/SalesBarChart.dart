import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../HomePage/DashboardModel.dart';

class SalesBarChart extends StatelessWidget {
  final List<SevenDaysSalesData> data;

  const SalesBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            'Last Seven Days Sales Data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250, // Adjust height as needed
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < data.length) {
                          return Text(
                            data[value.toInt()]
                                .date
                                .toString()
                                .substring(8, 10),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                      color: const Color.fromARGB(255, 215, 166, 19)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.totalSales))
                        .toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ],
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: 0,
                maxY: data
                        .map((e) => e.totalSales)
                        .reduce((a, b) => a > b ? a : b) +
                    10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
