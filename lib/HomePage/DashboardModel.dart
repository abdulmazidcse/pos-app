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
    );
  }

  @override
  String toString() {
    return 'DashboardModel {todaySalesAmount: $todaySalesAmount, yesterdaySalesAmount: $yesterdaySalesAmount, currentWeekSalesAmount: $currentWeekSalesAmount, previousWeekSalesAmount: $previousWeekSalesAmount, currentMonthSalesAmount: $currentMonthSalesAmount, currentYearSalesAmount: $currentYearSalesAmount}';
  }
}
