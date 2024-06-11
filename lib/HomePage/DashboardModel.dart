class DashboardModel {
  final int annualTotalSales;
  final int annualOrderDiscount;
  final String todaySalesAmount;
  final String yesterdaySalesAmount;
  final String currentWeekSalesAmount;
  final String previousWeekSalesAmount;
  final String currentMonthSalesAmount;
  final String previousMonthSalesAmount;
  final String currentYearSalesAmount;
  final List<SevenDaysSalesData> last7DaysSales;

  DashboardModel({
    required this.annualTotalSales,
    required this.annualOrderDiscount,
    required this.todaySalesAmount,
    required this.yesterdaySalesAmount,
    required this.currentWeekSalesAmount,
    required this.previousWeekSalesAmount,
    required this.currentMonthSalesAmount,
    required this.previousMonthSalesAmount,
    required this.currentYearSalesAmount,
    required this.last7DaysSales,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      annualTotalSales: json['annualTotalSales'] ?? 0,
      annualOrderDiscount: json['annualOrderDiscount'] ?? 0,
      todaySalesAmount: json['todaySalesAmount'] ?? "0.0",
      yesterdaySalesAmount: json['yesterdaySalesAmount'] ?? "0.0",
      currentWeekSalesAmount: json['currentWeekSalesAmount'] ?? "0.0",
      previousWeekSalesAmount: json['previousWeekSalesAmount'] ?? "0.0",
      currentMonthSalesAmount: json['currentMonthSalesAmount'] ?? "0.0",
      previousMonthSalesAmount: json['previousMonthSalesAmount'] ?? "0.0",
      currentYearSalesAmount: json['currentYearSalesAmount'] ?? "0.0",
      last7DaysSales: (json['last7DaysSales'] as List<dynamic>)
          .map((item) => SevenDaysSalesData.fromJson(item))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'DashboardModel {todaySalesAmount: $todaySalesAmount, yesterdaySalesAmount: $yesterdaySalesAmount, currentWeekSalesAmount: $currentWeekSalesAmount, previousWeekSalesAmount: $previousWeekSalesAmount, currentMonthSalesAmount: $currentMonthSalesAmount, currentYearSalesAmount: $currentYearSalesAmount}';
  }
}

class SevenDaysSalesData {
  final DateTime date;
  final double totalSales;

  SevenDaysSalesData({required this.date, required this.totalSales});

  factory SevenDaysSalesData.fromJson(Map<String, dynamic> json) {
    return SevenDaysSalesData(
      date: DateTime.parse(json['date']),
      totalSales: (json['total_sales'] as num).toDouble(),
    );
  }
  @override
  String toString() {
    return 'SevenDaysSalesData {date: $totalSales';
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'date': date.toIso8601String(),
  //     'total_sales': totalSales,
  //   };
  // }
}
