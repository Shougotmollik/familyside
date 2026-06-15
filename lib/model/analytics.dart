class Analytics {
  final String? category;
  final int? year;
  final List<ChartItem>? chartData;
  final String? suggestionText;

  Analytics({this.category, this.year, this.chartData, this.suggestionText});

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      category: json['category'],
      year: json['year'],
      chartData: (json['chart_data'] as List<dynamic>?)
          ?.map((e) => ChartItem.fromJson(e))
          .toList(),
      suggestionText: json['suggestion_text'],
    );
  }
}

class ChartItem {
  final String? label;
  final num? value;

  ChartItem({this.label, this.value});

  factory ChartItem.fromJson(Map<String, dynamic> json) {
    return ChartItem(
      label: json['label'],
      value: json['value'] as num?,
    );
  }
}
